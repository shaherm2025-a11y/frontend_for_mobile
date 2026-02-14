import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "farmer_local.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE questions (
            id INTEGER PRIMARY KEY,
            question TEXT,
            answer TEXT,
            image_path TEXT,
            question_audio_path TEXT,
            answer_audio_path TEXT,
            status INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertQuestion(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      "questions",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await database;
    return await db.query("questions");
  }

  static Future<void> updateAnswer(
      int id, String answer, String? answerAudioPath) async {
    final db = await database;
    await db.update(
      "questions",
      {
        "answer": answer,
        "answer_audio_path": answerAudioPath,
        "status": 1
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
  static Future<Map<String, dynamic>?> getQuestionById(int id) async {
  final db = await database;

  final result = await db.query(
    'questions',
    where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first;
  }

  return null;
}
static Future<String?> getImagePath(int id) async {
  final db = await database;

  final result = await db.query(
    'questions',
    columns: ['image_path'],
    where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['image_path'] as String?;
  }

  return null;
}

}
