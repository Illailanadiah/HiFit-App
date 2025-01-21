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
      version: 2, // Increment version for schema updates
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Create the medications table
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
  }

  /// Handle database schema upgrades
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE medications ADD COLUMN type TEXT NOT NULL DEFAULT 'Bottle';
      ''');
      await db.execute('''
      ALTER TABLE medications ADD COLUMN interval INTEGER NOT NULL DEFAULT 24;
      ''');
    }
  }

  /// Add a new medication
  Future<int> addMedication(Map<String, dynamic> data) async {
    try {
      final db = await instance.database;
      return await db.insert('medications', data);
    } catch (e) {
      throw Exception('Failed to add medication: $e');
    }
  }

  /// Fetch all medications ordered by time
  Future<List<Map<String, dynamic>>> fetchMedications() async {
    try {
      final db = await instance.database;
      return await db.query('medications', orderBy: 'time ASC');
    } catch (e) {
      throw Exception('Failed to fetch medications: $e');
    }
  }

  /// Fetch a single medication by ID
  Future<Map<String, dynamic>?> fetchMedicationById(int id) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'medications',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      throw Exception('Failed to fetch medication by ID: $e');
    }
  }

  /// Update an existing medication
  Future<int> updateMedication(int id, Map<String, dynamic> data) async {
    try {
      final db = await instance.database;
      return await db.update('medications', data, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to update medication: $e');
    }
  }

  /// Delete a medication by ID
  Future<int> deleteMedication(int id) async {
    try {
      final db = await instance.database;
      return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete medication: $e');
    }
  }

  /// Clear all medications in the database
  Future<void> clearDatabase() async {
    try {
      final db = await instance.database;
      await db.delete('medications');
    } catch (e) {
      throw Exception('Failed to clear database: $e');
    }
  }

  /// Close the database
  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
    } catch (e) {
      throw Exception('Failed to close database: $e');
    }
  }
}
