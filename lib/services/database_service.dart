import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      version: 3, // ✅ UPGRADE VERSION untuk add userId column
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // ✅ Tabel Catatan dengan userId
    await db.execute('''
      CREATE TABLE catatan (
        id TEXT PRIMARY KEY,
        isi TEXT NOT NULL,
        modulId TEXT,
        babId TEXT,
        createdAt TEXT NOT NULL,
        userId TEXT NOT NULL
      )
    ''');

    // ✅ Tabel Quiz Results dengan userId
    await db.execute('''
      CREATE TABLE quiz_results (
        id TEXT PRIMARY KEY,
        babId TEXT NOT NULL,
        score INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        userId TEXT NOT NULL
      )
    ''');

    // ✅ Tabel Friends dengan userId
    await db.execute('''
      CREATE TABLE friends (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        picture TEXT NOT NULL,
        location TEXT NOT NULL,
        registeredDate TEXT NOT NULL,
        userId TEXT NOT NULL,
        PRIMARY KEY (id, userId)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE quiz_results ADD COLUMN totalQuestions INTEGER DEFAULT 5
      ''');
      await db.execute('''
        ALTER TABLE quiz_results ADD COLUMN timestamp TEXT
      ''');
    }

    if (oldVersion < 3) {
      // ✅ Add userId column to existing tables
      try {
        await db.execute('ALTER TABLE catatan ADD COLUMN userId TEXT');
        await db.execute('ALTER TABLE quiz_results ADD COLUMN userId TEXT');
      } catch (e) {
        // Column might already exist
      }

      // ✅ Create friends table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS friends (
          id TEXT NOT NULL,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          phone TEXT NOT NULL,
          picture TEXT NOT NULL,
          location TEXT NOT NULL,
          registeredDate TEXT NOT NULL,
          userId TEXT NOT NULL,
          PRIMARY KEY (id, userId)
        )
      ''');

      // ✅ Add id column to quiz_results if not exists
      try {
        await db.execute('ALTER TABLE quiz_results ADD COLUMN id TEXT');
      } catch (e) {
        // Column might already exist
      }
    }
  }

  // ✅ Get current userId
  String _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  // ============================================
  // CATATAN OPERATIONS (USER ISOLATED)
  // ============================================

  Future<void> insertCatatan(Catatan catatan) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    final map = catatan.toMap();
    map['userId'] = userId; // ✅ Add userId

    await db.insert(
      'catatan',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Catatan>> getAllCatatan() async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    // ✅ Filter by userId
    final maps = await db.query(
      'catatan',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Catatan.fromMap(map)).toList();
  }

  Future<void> updateCatatan(Catatan catatan) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    final map = catatan.toMap();
    map['userId'] = userId;

    await db.update(
      'catatan',
      map,
      where: 'id = ? AND userId = ?',
      whereArgs: [catatan.id, userId],
    );
  }

  Future<void> deleteCatatan(String id) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    await db.delete(
      'catatan',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  // ============================================
  // QUIZ RESULTS OPERATIONS (USER ISOLATED)
  // ============================================

  Future<void> saveQuizResult(QuizResult result) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    final map = result.toMap();
    map['userId'] = userId; // ✅ Add userId
    map['id'] = '${result.babId}_$userId'; // Unique ID per user per bab

    await db.insert(
      'quiz_results',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, QuizResult>> getQuizResults() async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    // ✅ Filter by userId
    final maps = await db.query(
      'quiz_results',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    final results = <String, QuizResult>{};
    for (final map in maps) {
      final result = QuizResult.fromMap(map);
      results[result.babId] = result;
    }

    return results;
  }

  Future<void> deleteQuizResult(String babId) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    await db.delete(
      'quiz_results',
      where: 'babId = ? AND userId = ?',
      whereArgs: [babId, userId],
    );
  }

  Future<void> deleteAllQuizResults() async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    await db.delete(
      'quiz_results',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // ============================================
  // FRIENDS OPERATIONS (USER ISOLATED)
  // ============================================

  Future<void> insertFriend(Map<String, dynamic> friendData) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    friendData['userId'] = userId; // ✅ Add userId

    await db.insert(
      'friends',
      friendData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllFriends() async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    // ✅ Filter by userId
    return await db.query(
      'friends',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deleteFriend(String friendId) async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    await db.delete(
      'friends',
      where: 'id = ? AND userId = ?',
      whereArgs: [friendId, userId],
    );
  }

  // ============================================
  // CLEAR USER DATA ON LOGOUT
  // ============================================

  Future<void> clearUserData() async {
    final db = await instance.database;
    final userId = _getCurrentUserId();

    // ✅ Delete all data for current user
    await db.delete('catatan', where: 'userId = ?', whereArgs: [userId]);
    await db.delete('quiz_results', where: 'userId = ?', whereArgs: [userId]);
    await db.delete('friends', where: 'userId = ?', whereArgs: [userId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
