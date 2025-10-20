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
      version: 1,
      onCreate: _createDB,
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

    // Tabel Quiz Results
    await db.execute('''
      CREATE TABLE quiz_results (
        babId TEXT PRIMARY KEY,
        score INTEGER NOT NULL
      )
    ''');
  }

  // CATATAN OPERATIONS
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

  // QUIZ RESULTS OPERATIONS
  Future<void> saveQuizResult(QuizResult result) async {
    final db = await instance.database;
    await db.insert(
      'quiz_results',
      result.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, QuizResult>> getQuizResults() async {
    final db = await instance.database;
    final maps = await db.query('quiz_results');

    final results = <String, QuizResult>{};
    for (final map in maps) {
      final result = QuizResult.fromJson(map);
      results[result.babId] = result;
    }

    return results;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
