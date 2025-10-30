import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/catatan.dart';
import '../models/quiz_result.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aplikasi_materi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // UPGRADE VERSION untuk tambah kolom baru
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel Catatan
    await db.execute('''
      CREATE TABLE catatan (
        id TEXT PRIMARY KEY,
        isi TEXT NOT NULL,
        modulId TEXT,
        babId TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Tabel Quiz Results - UPDATED dengan kolom lengkap
    await db.execute('''
      CREATE TABLE quiz_results (
        babId TEXT PRIMARY KEY,
        score INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Upgrade database jika ada perubahan struktur
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tambah kolom baru jika upgrade dari version 1
      await db.execute('''
        ALTER TABLE quiz_results ADD COLUMN totalQuestions INTEGER DEFAULT 5
      ''');
      await db.execute('''
        ALTER TABLE quiz_results ADD COLUMN timestamp TEXT
      ''');
    }
  }

  // ============================================
  // CATATAN OPERATIONS
  // ============================================

  Future<void> insertCatatan(Catatan catatan) async {
    final db = await instance.database;
    await db.insert(
      'catatan',
      catatan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Catatan>> getAllCatatan() async {
    final db = await instance.database;
    final maps = await db.query('catatan', orderBy: 'createdAt DESC');
    return maps.map((map) => Catatan.fromMap(map)).toList();
  }

  Future<void> updateCatatan(Catatan catatan) async {
    final db = await instance.database;
    await db.update(
      'catatan',
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  Future<void> deleteCatatan(String id) async {
    final db = await instance.database;
    await db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============================================
  // QUIZ RESULTS OPERATIONS - FIXED
  // ============================================

  Future<void> saveQuizResult(QuizResult result) async {
    final db = await instance.database;
    await db.insert(
      'quiz_results',
      result.toMap(), // GANTI dari toJson() ke toMap()
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, QuizResult>> getQuizResults() async {
    final db = await instance.database;
    final maps = await db.query('quiz_results');

    final results = <String, QuizResult>{};
    for (final map in maps) {
      final result =
          QuizResult.fromMap(map); // GANTI dari fromJson() ke fromMap()
      results[result.babId] = result;
    }

    return results;
  }

  // Hapus hasil quiz untuk bab tertentu
  Future<void> deleteQuizResult(String babId) async {
    final db = await instance.database;
    await db.delete(
      'quiz_results',
      where: 'babId = ?',
      whereArgs: [babId],
    );
  }

  // Hapus semua hasil quiz
  Future<void> deleteAllQuizResults() async {
    final db = await instance.database;
    await db.delete('quiz_results');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
