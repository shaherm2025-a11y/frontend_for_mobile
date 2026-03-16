Widget _buildQuestionCard(Map<String, dynamic> q, {bool answered = false}) {
  final loc = AppLocalizations.of(context)!;

  final questionId = q["id"];
  final questionText = q["question"] ?? "";
  final answerText = q["answer"] ?? "";

  return Card(
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "${loc.label_question} $questionText",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),


// ===== عرض الصورة =====
(q["image_path"] != null && q["image_path"].toString().isNotEmpty)

    ? Image.file(
        File(q["image_path"]),
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      )

    : (q["has_image"] == 1 || q["has_image"] == true)

        ? FutureBuilder<String?>(
            future: _getOrDownloadImage(questionId),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 130,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                return Image.file(
                  File(snapshot.data!),
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }

              return SizedBox(
                height: 130,
                child: Center(
                  child: Text(loc.label_no_image),
                ),
              );
            },
          )

        : SizedBox(
            height: 130,
            child: Center(
              child: Text(loc.label_no_image),
            ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                loc.label_question_audio,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.volume_up),
                tooltip: loc.label_play_question_audio,
                onPressed: () async {

                  final prefs = await SharedPreferences.getInstance();

                  final question =
                      await LocalDB.getQuestionById(questionId);

                  final localPath =
                      question?['question_audio_path'];

                  if (kIsWeb) {

                    final url =
                        "${AppConstants.baseUrl}/expert_question_audio/$questionId";

                    await _audioPlayer.stop();
                    await _audioPlayer.play(UrlSource(url));
                    return;

                  } else {

                    if (localPath != null &&
                        await File(localPath).exists()) {

                      await _audioPlayer.stop();
                      await _audioPlayer.play(
                        DeviceFileSource(localPath),
                      );

                    } else {

                      final url =
                          "${AppConstants.baseUrl}/expert_question_audio/$questionId";

                      final response = await http.get(Uri.parse(url));

                      if (response.statusCode != 200 ||
                          response.bodyBytes.isEmpty) {

                        debugPrint("No question audio for $questionId");
                        return;
                      }

                      final dir =
                          await getApplicationDocumentsDirectory();

                      final filePath =
                          '${dir.path}/question_$questionId.m4a';

                      final file = File(filePath);
                      await file.writeAsBytes(response.bodyBytes);

                      await prefs.setString(
                        "question_audio_$questionId",
                        filePath,
                      );

                      await LocalDB.updateQuestionAudioPath(
                        questionId,
                        filePath,
                      );

                      await _audioPlayer.stop();
                      await _audioPlayer.play(
                        DeviceFileSource(filePath),
                      );
                    }
                  }
                },
              ),
            ],
          ),

          if (answered && answerText.isNotEmpty) ...[

            const SizedBox(height: 6),

            Text(
              "${loc.label_answer} $answerText",
              style: const TextStyle(color: Colors.green),
            ),

            Row(
              children: [
                Text(
                  loc.label_answer_audio,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.play_circle_fill),
                  tooltip: loc.label_play_answer_audio,
                  onPressed: () => _playExpertAudio(questionId),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
