import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/health_record.dart';
import '../models/detailed_record.dart';
import '../models/sleep_session.dart';
import '../core/helpers.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healthmate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS medications (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          dosage TEXT NOT NULL,
          frequency TEXT NOT NULL,
          timeOfDay TEXT NOT NULL,
          isActive INTEGER NOT NULL DEFAULT 1,
          createdAt TEXT NOT NULL,
          notes TEXT
        )
      ''');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        water INTEGER NOT NULL,
        UNIQUE(date)
      )
    ''');

    await db.execute('''
      CREATE TABLE detailed_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        date TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sleep_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_time INTEGER NOT NULL,
        end_time INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        quality INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        timeOfDay TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        notes TEXT
      )
    ''');

    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    final today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = DateHelper.formatDate(today.subtract(Duration(days: i)));
      await db.insert('health_records', {
        'date': date,
        'steps': 5000 + (i * 1000),
        'calories': 1800 + (i * 100),
        'water': 1500 + (i * 200),
      });
    }

    for (int i = 0; i < 5; i++) {
      final date = DateHelper.formatDate(today.subtract(Duration(days: i)));
      final startTime = today.subtract(Duration(days: i, hours: 8)).millisecondsSinceEpoch;
      final endTime = today.subtract(Duration(days: i)).millisecondsSinceEpoch;

      await db.insert('sleep_sessions', {
        'start_time': startTime,
        'end_time': endTime,
        'duration_minutes': 480,
        'quality': 3 + (i % 3),
        'date': date,
      });
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  Future<HealthRecord> createHealthRecord(HealthRecord record) async {
    final db = await database;
    final id = await db.insert(
      'health_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return record.copyWith(id: id);
  }

  Future<HealthRecord?> getHealthRecordByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (maps.isEmpty) return null;
    return HealthRecord.fromMap(maps.first);
  }

  Future<List<HealthRecord>> getAllHealthRecords() async {
    final db = await database;
    final maps = await db.query('health_records', orderBy: 'date DESC');
    return maps.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<List<HealthRecord>> getHealthRecordsByDateRange(String startDate, String endDate) async {
    final db = await database;
    final maps = await db.query(
      'health_records',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
    return maps.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<List<HealthRecord>> getLast7DaysRecords() async {
    final db = await database;
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 6));
    final maps = await db.query(
      'health_records',
      where: 'date >= ?',
      whereArgs: [DateHelper.formatDate(sevenDaysAgo)],
      orderBy: 'date ASC',
    );
    return maps.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<int> updateHealthRecord(HealthRecord record) async {
    final db = await database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteHealthRecord(int id) async {
    final db = await database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> createDetailedRecord(DetailedRecord record) async {
    final db = await database;
    return await db.insert('detailed_records', record.toMap());
  }

  Future<List<DetailedRecord>> getDetailedRecordsByType(String type) async {
    final db = await database;
    final maps = await db.query(
      'detailed_records',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => DetailedRecord.fromMap(map)).toList();
  }

  Future<int> createSleepSession(SleepSession session) async {
    final db = await database;
    return await db.insert('sleep_sessions', session.toMap());
  }

  Future<List<SleepSession>> getAllSleepSessions() async {
    final db = await database;
    final maps = await db.query('sleep_sessions', orderBy: 'date DESC');
    return maps.map((map) => SleepSession.fromMap(map)).toList();
  }

  Future<List<SleepSession>> getLast7DaysSleepSessions() async {
    final db = await database;
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 6));
    final maps = await db.query(
      'sleep_sessions',
      where: 'date >= ?',
      whereArgs: [DateHelper.formatDate(sevenDaysAgo)],
      orderBy: 'date DESC',
    );
    return maps.map((map) => SleepSession.fromMap(map)).toList();
  }

  Future<int> deleteSleepSession(int id) async {
    final db = await database;
    return await db.delete(
      'sleep_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

extension UserExtension on User {
  User copyWith({int? id}) {
    return User(
      id: id ?? this.id,
      name: name,
      email: email,
      passwordHash: passwordHash,
    );
  }
}
