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
    version: 2,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE questions (
          id INTEGER PRIMARY KEY,
          question TEXT,
          answer TEXT,
          image_path TEXT,
          question_audio_path TEXT,
          answer_audio_path TEXT,
          has_image INTEGER,
          question_has_audio INTEGER,
          answer_has_audio INTEGER,
          answer_image_path TEXT,
          answer_image INTEGER,
          parent_question_id INTEGER,
          status INTEGER
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          "ALTER TABLE questions ADD COLUMN parent_question_id INTEGER",
        );

      }
    },
  );
}
 static Future<void> insertQuestion(Map<String, dynamic> data) async {
  final db = await database;

  final existing = await db.query(
    "questions",
    where: "id = ?",
    whereArgs: [data["id"]],
  );

  if (existing.isEmpty) {
    // إدخال جديد فقط
    await db.insert("questions", data);
  } else {
    // تحديث فقط النصوص بدون لمس الملفات
    await db.update(
      "questions",
      {
        "question": data["question"],
        "answer": data["answer"],
        "status": data["status"],
		"parent_question_id": data["parent_question_id"],
      },
      where: "id = ?",
      whereArgs: [data["id"]],
    );
  }
}

  static Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await database;
    return await db.query("questions",orderBy: "id DESC");
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

static Future<void> updateQuestionAudioPath(
    int id, String audioPath) async {
  final db = await database;

  await db.update(
    "questions",
    {
      "question_audio_path": audioPath,
    },
    where: "id = ?",
    whereArgs: [id],
  );
}

static Future<void> updateQuestionImagePath(
    int id, String imagePath) async {

  final db = await database;

  await db.update(
    'questions',
    {"image_path": imagePath},
    where: 'id = ?',
    whereArgs: [id],
  );
}

static Future<void> updateAnswerAudioPath(
  int questionId,
  String audioPath,
) async {

  final db = await database;

  await db.update(
    "questions",
    {
      "answer_audio_path": audioPath,
    },
    where: "id = ?",
    whereArgs: [questionId],
  );

}
static Future<void> updateAnswerImagePath(int id, String path) async {
  final db = await database;

  await db.update(
    'questions',
    {"answer_image_path": path},
    where: "id = ?",
    whereArgs: [id],
  );
}
}
