
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  static Database? _db;

  // ============================================================
  // الحصول على قاعدة البيانات
  // ============================================================

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB();

    return _db!;
  }

  // ============================================================
  // إنشاء / فتح قاعدة البيانات
  // ============================================================

  static Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();

    final path = join(
      dir.path,
      "farmer_local.db",
    );

    return await openDatabase(
      path,

      // تم رفع الإصدار لإضافة جدول answer_images
      version: 3,

      // ========================================================
      // إنشاء قاعدة البيانات لأول مرة
      // ========================================================

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

            -- قديم: صورة واحدة
            answer_image_path TEXT,

            -- قديم
            answer_image INTEGER,

            -- جديد
            answer_image_count INTEGER DEFAULT 0,

            parent_question_id INTEGER,
            status INTEGER
          )
        ''');

        // ======================================================
        // جدول صور إجابات الخبراء المتعددة
        // ======================================================

        await db.execute('''
          CREATE TABLE answer_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question_id INTEGER NOT NULL,
            image_path TEXT NOT NULL
          )
        ''');
      },

      // ========================================================
      // تحديث قاعدة البيانات القديمة
      // ========================================================

      onUpgrade: (db, oldVersion, newVersion) async {

        // ------------------------------------------------------
        // الإصدار 2
        // ------------------------------------------------------

        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE questions ADD COLUMN parent_question_id INTEGER",
          );
        }

        // ------------------------------------------------------
        // الإصدار 3
        // إضافة دعم الصور المتعددة
        // ------------------------------------------------------

        if (oldVersion < 3) {

          // إضافة عدد صور الرد
          await db.execute(
            "ALTER TABLE questions ADD COLUMN answer_image_count INTEGER DEFAULT 0",
          );

          // إنشاء جدول الصور المتعددة
          await db.execute('''
            CREATE TABLE answer_images (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              question_id INTEGER NOT NULL,
              image_path TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // ============================================================
  // إضافة / تحديث السؤال
  // ============================================================

  static Future<void> insertQuestion(
    Map<String, dynamic> data,
  ) async {

    final db = await database;

    final existing = await db.query(
      "questions",
      where: "id = ?",
      whereArgs: [data["id"]],
    );

    if (existing.isEmpty) {

      // إدخال جديد
      await db.insert(
        "questions",
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } else {

      // تحديث بيانات السؤال فقط
      // لا نلمس مسارات الصور والصوت الموجودة محلياً

      await db.update(
        "questions",
        {
          "question": data["question"],
          "answer": data["answer"],
          "status": data["status"],
          "parent_question_id": data["parent_question_id"],

          // جديد
          "answer_image_count":
              data["answer_image_count"] ?? 0,
        },
        where: "id = ?",
        whereArgs: [data["id"]],
      );
    }
  }

  // ============================================================
  // جلب جميع الأسئلة
  // ============================================================

  static Future<List<Map<String, dynamic>>> getQuestions() async {

    final db = await database;

    return await db.query(
      "questions",
      orderBy: "id DESC",
    );
  }

  // ============================================================
  // جلب سؤال واحد
  // ============================================================

  static Future<Map<String, dynamic>?> getQuestionById(
    int id,
  ) async {

    final db = await database;

    final result = await db.query(
      "questions",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // ============================================================
  // تحديث إجابة الخبير
  // ============================================================

  static Future<void> updateAnswer(
    int id,
    String answer,
    String? answerAudioPath,
  ) async {

    final db = await database;

    await db.update(
      "questions",
      {
        "answer": answer,
        "answer_audio_path": answerAudioPath,
        "status": 1,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // ============================================================
  // صورة السؤال
  // ============================================================

  static Future<String?> getImagePath(
    int id,
  ) async {

    final db = await database;

    final result = await db.query(
      "questions",
      columns: ["image_path"],
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first["image_path"] as String?;
    }

    return null;
  }

  // ============================================================
  // تحديث مسار صوت السؤال
  // ============================================================

  static Future<void> updateQuestionAudioPath(
    int id,
    String audioPath,
  ) async {

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

  // ============================================================
  // تحديث مسار صورة السؤال
  // ============================================================

  static Future<void> updateQuestionImagePath(
    int id,
    String imagePath,
  ) async {

    final db = await database;

    await db.update(
      "questions",
      {
        "image_path": imagePath,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // ============================================================
  // تحديث مسار صوت الإجابة
  // ============================================================

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

  // ============================================================
  // ============================================================
  // دعم الصور المتعددة لإجابة الخبير
  // ============================================================
  // ============================================================

  // ============================================================
  // إضافة صورة واحدة إلى إجابة السؤال
  // ============================================================

  static Future<void> insertAnswerImage(
    int questionId,
    String imagePath,
  ) async {

    final db = await database;

    await db.insert(
      "answer_images",
      {
        "question_id": questionId,
        "image_path": imagePath,
      },
    );
  }

  // ============================================================
  // جلب جميع صور إجابة سؤال
  //
  // النتيجة:
  //
  // [
  //   "/data/.../answer_25_10.jpg",
  //   "/data/.../answer_25_11.jpg",
  //   "/data/.../answer_25_12.jpg"
  // ]
  // ============================================================

  static Future<List<String>> getAnswerImages(
    int questionId,
  ) async {

    final db = await database;

    final result = await db.query(
      "answer_images",
      columns: ["image_path"],
      where: "question_id = ?",
      whereArgs: [questionId],
      orderBy: "id ASC",
    );

    return result
        .map(
          (row) => row["image_path"] as String,
        )
        .toList();
  }

  // ============================================================
  // حذف جميع صور إجابة سؤال
  //
  // مهم عند إعادة تحميل الصور من السيرفر
  // ============================================================

  static Future<void> clearAnswerImages(
    int questionId,
  ) async {

    final db = await database;

    await db.delete(
      "answer_images",
      where: "question_id = ?",
      whereArgs: [questionId],
    );
  }

  // ============================================================
  // معرفة عدد الصور المخزنة محلياً
  // ============================================================

  static Future<int> getAnswerImagesCount(
    int questionId,
  ) async {

    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS count
      FROM answer_images
      WHERE question_id = ?
      ''',
      [questionId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ============================================================
  // الدالة القديمة
  //
  // نبقيها حتى لا يتعطل أي جزء قديم من التطبيق.
  //
  // لاحقاً يمكن حذفها بعد التأكد أن جميع الواجهة تستخدم
  // getAnswerImages().
  // ============================================================

  static Future<void> updateAnswerImagePath(
    int id,
    String path,
  ) async {

    final db = await database;

    await db.update(
      "questions",
      {
        "answer_image_path": path,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
