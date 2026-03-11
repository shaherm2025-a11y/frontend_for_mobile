Future<void> _playExpertAudio(int questionId) async {

  // ===== WEB =====
  if (kIsWeb) {
    final url =
        "${AppConstants.baseUrl}/expert_answer_audio/$questionId";

    await _audioPlayer.stop();
    await _audioPlayer.setSource(UrlSource(url));
    await _audioPlayer.resume();
    return;
  }

  // ===== ANDROID =====

  // ? ���� �� SQLite
  final local = await LocalDB.getQuestions();
  final question =
      local.firstWhere((q) => q['id'] == questionId);

  final path = question['answer_audio_path'];

  // ? ��� ����� ������ ���� ������
  if (path != null && await File(path).exists()) {
    await _audioPlayer.stop();
    await _audioPlayer.setSource(DeviceFileSource(path));
    await _audioPlayer.resume();
    return;
  }

  // ? ��� ��� ����� ���� �� �������
  final url =
      "${AppConstants.baseUrl}/expert_answer_audio/$questionId";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
    debugPrint("No answer audio for $questionId");
    return;
   }


    // ����� ������
    await _saveAnswerAudioLocally(
        questionId,
        response.bodyBytes);

    // ���� ��� �����
    final updated =
        await LocalDB.getQuestions();

    final updatedQuestion =
        updated.firstWhere((q) => q['id'] == questionId);

    final newPath =
        updatedQuestion['answer_audio_path'];

    if (newPath != null &&
        await File(newPath).exists()) {

      await _audioPlayer.stop();
      await _audioPlayer.setSource(
          DeviceFileSource(newPath));
      await _audioPlayer.resume();
    }
  
}
