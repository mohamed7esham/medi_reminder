import 'package:flutter/widgets.dart';
import 'package:medi_reminder/model/dose_history.dart';
import 'package:medi_reminder/model/medicine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  // Singleton pattern to ensure only one instance of the database is created
  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // Initialize the database and create the medicines table if it doesn't exist
  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'medicines.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE medicines(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            date TEXT,
            time TEXT,
            repeatDaily INTEGER,
            imagePath TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE dose_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicineId INTEGER,
            scheduledDate TEXT,
            taken INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE medicines ADD COLUMN imagePath TEXT');
        }
      },
    );
  }

  // Insert a new medicine into the database and return its ID
  static Future<int> insertMedicine(Medicine medicine) async {
    final dbClient = await db;
    return await dbClient.insert('medicines', medicine.toMap());
  }

  // Retrieve all medicines from the database and return them as a list of Medicine objects
  static Future<List<Medicine>> getMedicines() async {
    final dbClient = await db;
    final result = await dbClient.query('medicines');

    return result.map((e) => Medicine.fromMap(e)).toList();
  }

  // Delete a medicine from the database by its ID
  static Future<void> deleteMedicine(int id) async {
    final dbClient = await db;
    await dbClient.delete('medicines', where: 'id=?', whereArgs: [id]);
  }

  // ✏️ Update medicine
  static Future<void> updateMedicine(Medicine medicine) async {
    final dbClient = await db;

    await dbClient.update(
      'medicines',
      medicine.toMap(),
      where: 'id=?',
      whereArgs: [medicine.id],
    );

    debugPrint("✏️ Medicine updated");
  }

  // For testing purposes only print all medicines in the database
  static Future<void> printAllMedicines() async {
    final dbClient = await db;

    final result = await dbClient.query('medicines');

    debugPrint(
      "📦 ==////////=====//////==== MEDICINES DATABASE ==///////==/////////===",
    );

    if (result.isEmpty) {
      debugPrint("📭 Database is empty");
      return;
    }

    for (final row in result) {
      debugPrint(
        "🧾 ID: ${row['id']} | "
        "Name: ${row['name']} | "
        "Date: ${row['date']} | "
        "Time: ${row['time']} | "
        "Repeat: ${row['repeatDaily']} | "
        "Image Path: ${row['imagePath']}",
      );
    }

    debugPrint(
      "📦 ==////////=====//////===== END DATABASE ==////////=====//////////===",
    );
  }

  static Future insertDoseHistory(DoseHistory dose) async {
    final dbClient = await db;

    await dbClient.insert('dose_history', dose.toMap());
  }

  static Future<List<DoseHistory>> getDoseHistory() async {
    final dbClient = await db;

    final result = await dbClient.query(
      'dose_history',
      orderBy: 'scheduledDate DESC',
    );

    return result.map((e) => DoseHistory.fromMap(e)).toList();
  }

  // For testing purposes only clearDatabase
  static Future<void> clearDatabase() async {
    final dbClient = await db;

    await dbClient.delete('medicines');
    await dbClient.delete('dose_history');

    await dbClient.execute(
      "DELETE FROM sqlite_sequence WHERE name='medicines'",
    );
    await dbClient.execute(
      "DELETE FROM sqlite_sequence WHERE name='dose_history'",
    );

    debugPrint("🧹 Database cleared and ID reset");
  }
}
