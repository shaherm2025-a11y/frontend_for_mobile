import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
Future<String> getDeviceId() async {
  final prefs = await SharedPreferences.getInstance();

  const key = 'installation_uuid';

  // إذا كان UUID موجودًا مسبقًا، نعيد استخدامه
  final existingUuid = prefs.getString(key);

  if (existingUuid != null && existingUuid.isNotEmpty) {
    return existingUuid;
  }

  // إنشاء UUID جديد خاص بهذا التثبيت
  final newUuid = const Uuid().v4();

  await prefs.setString(key, newUuid);
  
  return newUuid;
}