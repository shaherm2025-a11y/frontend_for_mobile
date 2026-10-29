import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics =
      FirebaseAnalytics.instance;

  static Future<void> logLogin() async {
    await _analytics.logLogin(
      loginMethod: 'auto_login',
    );
  }

  static Future<void> logDiagnosisStarted() async {
    await _analytics.logEvent(
      name: 'diagnosis_started',
    );
  }

  static Future<void> logDiagnosisCompleted({
  required String disease,
}) async {
  await _analytics.logEvent(
    name: 'diagnosis_completed',
    parameters: {
      'disease': disease,
    },
  );
}

  static Future<void> logQuestionSent({
    required String type,
  }) async {
    await _analytics.logEvent(
      name: 'question_sent',
      parameters: {
        'question_type': type,
      },
    );
  }
  
  static Future<void> setFarmerProperties({
  required String language,
}) async {
  await _analytics.setUserProperty(
    name: 'user_type',
    value: 'farmer',
  );

  await _analytics.setUserProperty(
    name: 'language',
    value: language,
  );
}
  static Future<void> logVoiceQuestionSent() async {
    await _analytics.logEvent(
      name: 'voice_question_sent',
    );
  }

  static Future<void> logImageQuestionSent() async {
    await _analytics.logEvent(
      name: 'image_question_sent',
    );
  }

  static Future<void> logExpertSelected({
    required int expertId,
  }) async {
    await _analytics.logEvent(
      name: 'expert_selected',
      parameters: {
        'expert_id': expertId,
      },
    );
  }

  static Future<void> logExpertReplyReceived() async {
    await _analytics.logEvent(
      name: 'expert_reply_received',
    );
  }

  static Future<void> logAudioPlayed() async {
    await _analytics.logEvent(
      name: 'audio_played',
    );
  }

  static Future<void> logAppUpdateAvailable() async {
    await _analytics.logEvent(
      name: 'app_update_available',
    );
  }
}