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
         if ((q["question_audio_path"] != null &&
            q["question_audio_path"].toString().isNotEmpty) ||
            q["question_has_audio"] == 1 ||
            q["question_has_audio"] == true) ...[
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
		  ],
if (answered &&
   (answerText.isNotEmpty ||
    (q["answer_audio_path"] != null &&
     q["answer_audio_path"].toString().isNotEmpty) ||
    (q["answer_image_path"] != null &&
     q["answer_image_path"].toString().isNotEmpty))) ...[

  const SizedBox(height: 6),

  // 🖼️ صورة الرد
  if (q["answer_image_path"] != null &&
      q["answer_image_path"].toString().isNotEmpty)
    Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Image.file(
        File(q["answer_image_path"]),
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),

  // ✍️ نص الرد
  if (answerText.isNotEmpty)
    Text(
      "${loc.label_answer} $answerText",
      style: const TextStyle(color: Colors.green),
    ),

  // 🔊 صوت الرد
  if (q["answer_audio_path"] != null &&
      q["answer_audio_path"].toString().isNotEmpty)
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
@override
Widget build(BuildContext context) {

  final loc = AppLocalizations.of(context)!;

  return Scaffold(

    appBar: AppBar(
      title: Text(loc.farmer_page_title),
      backgroundColor: Colors.green[700],
    ),

    backgroundColor: Colors.grey[100],

    body: _loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          )

        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 1,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        loc.tab_answered,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (answered.isEmpty)
                        Text(
                          loc.noPreviousDiagnoses,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                      ...answered
                          .map((q) =>
                              _buildQuestionCard(q, answered: true))
                          .toList(),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  flex: 2,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      TextField(
                        controller: _questionController,
                        decoration: InputDecoration(
                          labelText: loc.label_write_question,
                          border: const OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_a_photo),
                        label: Text(loc.button_pick_image),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(

                        onPressed:
                            _recording
                                ? _stopRecording
                                : _startRecording,

                        icon: Icon(
                            _recording
                                ? Icons.stop
                                : Icons.mic),

                        label: Text(
                          _recording
                              ? loc.button_stop_recording
                              : loc.button_record_audio,
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                      ),

                      if (_audioQuestionFile != null) ...[

                        const SizedBox(height: 10),

                       Row(
                        children: [

                        const Icon(Icons.mic, color: Colors.green),

                       const SizedBox(width: 8),

                       Expanded(
                        child: Text(loc.label_audio_attached),
                       ),

                      // تشغيل الصوت
                       IconButton(
                       icon: const Icon(Icons.play_arrow, color: Colors.blue),
                       tooltip: loc.label_play_question_audio,
                       onPressed: () async {
                       await _audioPlayer.stop();
                       await _audioPlayer.play(
                       DeviceFileSource(_audioQuestionFile!.path),
                       );
                      },
                      ),

                     // حذف الصوت
                     IconButton(
                     icon: const Icon(Icons.delete, color: Colors.red),
                     tooltip: loc.label_delete_audio,
                     onPressed: () {
                     setState(() {
                      _audioQuestionFile = null;
                       });
                      },
                     ),
                    ],
                   ),
                  ],
                      const SizedBox(height: 10),

                      if (_imageFile != null ||
                          _webImage != null)

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16),

                          child: _imageFile != null
                              ? Image.file(
                                  _imageFile!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  _webImage!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                        ),

                      const SizedBox(height: 10),

                      ElevatedButton(

                        onPressed: _sendQuestion,

                        child:
                            Text(loc.button_send_question),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        loc.tab_unanswered,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (unanswered.isEmpty)
                        Text(
                          loc.noPreviousDiagnoses,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                      ...unanswered
                          .map((q) =>
                              _buildQuestionCard(q))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
  );
