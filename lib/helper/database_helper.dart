import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Singleton instance of the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hifit.db');
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // Incremented version for new schema updates
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'Bottle',
        interval INTEGER NOT NULL DEFAULT 24,
        time TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE moodLogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        energyLevel TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        scheduledTime TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending'
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE medications ADD COLUMN type TEXT NOT NULL DEFAULT 'Bottle';
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN interval INTEGER NOT NULL DEFAULT 24;
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS moodLogs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          mood TEXT NOT NULL,
          energyLevel TEXT NOT NULL,
          timestamp TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notifications (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          scheduledTime TEXT NOT NULL,
          status TEXT NOT NULL DEFAULT 'pending'
        )
      ''');
    }
  }

  /// Add a new medication
  Future<int> addMedication(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('medications', data);
  }

  /// Fetch all medications ordered by time
  Future<List<Map<String, dynamic>>> fetchMedications() async {
    final db = await instance.database;
    return await db.query('medications', orderBy: 'time ASC');
  }

  /// Delete a medication by ID
  Future<int> deleteMedication(int id) async {
    final db = await instance.database;
    return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  /// Add a new mood log
  Future<int> addMoodLog(Map<String, dynamic> moodData) async {
    final db = await instance.database;
    return await db.insert('moodLogs', moodData);
  }

  /// Fetch all mood logs ordered by timestamp
  Future<List<Map<String, dynamic>>> fetchMoodLogs() async {
    final db = await instance.database;
    return await db.query('moodLogs', orderBy: 'timestamp DESC');
  }

  /// Delete a mood log by ID
  Future<int> deleteMoodLog(int id) async {
    final db = await instance.database;
    return await db.delete('moodLogs', where: 'id = ?', whereArgs: [id]);
  }

  /// Add a new notification
  Future<int> addNotification(Map<String, dynamic> notificationData) async {
    final db = await instance.database;
    return await db.insert('notifications', notificationData);
  }

  /// Fetch all pending notifications
  Future<List<Map<String, dynamic>>> fetchPendingNotifications() async {
    final db = await instance.database;
    return await db.query('notifications', where: 'status = ?', whereArgs: ['pending']);
  }

  /// Update notification status
  Future<int> updateNotificationStatus(int id, String status) async {
    final db = await instance.database;
    return await db.update(
      'notifications',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Clear a specific table
  Future<void> clearTable(String tableName) async {
    final db = await instance.database;
    await db.delete(tableName);
  }

  /// Clear the entire database
  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('medications');
    await db.delete('moodLogs');
    await db.delete('notifications');
  }

  /// Close the database
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
