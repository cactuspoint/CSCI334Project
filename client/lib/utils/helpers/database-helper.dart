import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// A helper class to operate on a SQL-Lite local database with sqflite.
/// ```dart
/// DatabaseHelper.insertVisit(Visit visit);          // add a Visit to the database
/// DatabaseHelper.deleteVisitsOlderThanNdays(int n); // drop all visits older than n days
/// ```
class DatabaseHelper {
  static final dbVisits = 'visits';
  static final dbExposures = 'exposures';

  static Future<Database> getDatabaseVisits(String dbName) async {
    return openDatabase(
      join(await getDatabasesPath(), '${dbName}_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE ${dbName}'
          '('
          'datetime TEXT PRIMARY KEY, '
          'location TEXT'
          ')',
        );
      },
      version: 1,
    );
  }

  static Future<Database> getDatabaseExposures(String dbName) async {
    String db2Path =
        join(await getDatabasesPath(), '${dbExposures}_database.db');
    return openDatabase(
      join(await getDatabasesPath(), '${dbName}_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE ${dbName}'
            '('
            'datetime TEXT PRIMARY KEY, '
            'location TEXT'
            ')');
      },
      version: 1,
    );
  }

  static Future<void> insertVisit(Visit visit) async {
    final Database db = await getDatabaseVisits(dbVisits);
    await db.insert(
      '${dbVisits}',
      visit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllRows(String dbName) async {
    final Database db = await getDatabaseVisits(dbName);
    return await db.query(dbName);
  }

  static Future<void> deleteAllRows(String dbName) async {
    final Database db = await getDatabaseVisits(dbName);
    await db.execute('DELETE FROM ${dbName}');
  }

  static Future<void> executeArbitrarySQL(String dbName, String s) async {
    final Database db = await getDatabaseVisits(dbName);
    await db.execute(s);
  }

  static Future<void> deleteVisit(String dbName, String datetime) async {
    final Database db = await getDatabaseVisits(dbName);
    await db.delete(
      '${dbName}',
      where: "datetime = ?",
      whereArgs: [datetime],
    );
  }

  static Future<void> deleteVisitsOlderThanNdays(
      String dbName, int nDays) async {
    var rows = await DatabaseHelper.getAllRows(
      dbName,
    );
    rows.forEach((row) {
      if (DateTime.parse(row['datetime'])
          .isBefore(DateTime.now().subtract(Duration(days: nDays)))) {
        DatabaseHelper.deleteVisit(dbName, row['datetime']);
      }
    });
  }
}

class Visit {
  final String datetime; // iso8601
  final String location; // iso6709

  Visit(this.datetime, this.location);

  Map<String, dynamic> toMap() {
    return {'datetime': datetime, 'location': location};
  }

  @override
  String toString() {
    return "datetime:${datetime} location:${location}";
  }
}
