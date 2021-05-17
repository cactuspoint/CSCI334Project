import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// A helper class to operate on a SQL-Lite local database with sqflite.
/// ```dart
/// DatabaseHelper.insertVisit(Visit visit);          // add a Visit to the database
/// DatabaseHelper.deleteVisitsOlderThanNdays(int n); // drop all visits older than n days
/// ```
class DatabaseHelper {
  static final table = 'visits';

  static Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), '${table}_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ${table}(datetime TEXT PRIMARY KEY, location TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insertVisit(Visit visit) async {
    final Database db = await getDatabase();
    await db.insert(
      '${table}',
      visit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllRows() async {
    final Database db = await getDatabase();
    return await db.query(table);
  }

  static Future<void> deleteAllRows() async {
    final Database db = await getDatabase();
    await db.execute('DELETE FROM ${table}');
  }

  static Future<void> executeArbitrarySQL(String s) async {
    final Database db = await getDatabase();
    await db.execute(s);
  }

  static Future<void> deleteVisit(String datetime) async {
    final Database db = await getDatabase();
    await db.delete(
      '${table}',
      where: "datetime = ?",
      whereArgs: [datetime],
    );
  }

  static Future<void> deleteVisitsOlderThanNdays(int nDays) async {
    var rows = await DatabaseHelper.getAllRows();
    rows.forEach((row) {
      if (DateTime.parse(row['datetime'])
          .isBefore(DateTime.now().subtract(Duration(days: nDays)))) {
        DatabaseHelper.deleteVisit(row['datetime']);
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
