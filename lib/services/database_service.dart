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
    _database = await _initDB('app_data.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE catatan (
        id TEXT PRIMARY KEY,
        isi TEXT NOT NULL,
        modulId TEXT,
        babId TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_result (
        babId TEXT PRIMARY KEY,
        score INTEGER NOT NULL
      )
    ''');
  }

  // ==============================
  // CATATAN CRUD
  // ==============================
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
    final result = await db.query('catatan', orderBy: 'createdAt DESC');
    return result.map((json) => Catatan.fromMap(json)).toList();
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
    await db.delete('catatan', where: 'id = ?', whereArgs: [id]);
  }

  // ==============================
  // QUIZ RESULT CRUD
  // ==============================
  Future<void> saveQuizResult(QuizResult result) async {
    final db = await instance.database;
    await db.insert(
      'quiz_result',
      result.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, QuizResult>> getQuizResults() async {
    final db = await instance.database;
    final result = await db.query('quiz_result');

    final map = <String, QuizResult>{};
    for (var row in result) {
      final qr = QuizResult.fromJson(row);
      map[qr.babId] = qr;
    }
    return map;
  }

  Future<void> close() async {
    final db = _database;
    db?.close();
  }
}
