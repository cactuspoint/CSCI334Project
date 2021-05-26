import 'package:client/utils/constants/app_globals.dart' as globals;
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

  /// Attach a databse to another
  static Future<Database> attachDb(
      Database db, String db2Path, String db2Alias) async {
    await db.rawQuery("ATTACH DATABASE '$db2Path' as '$db2Alias'");
    return db;
  }

  static Future<bool> exposed() async {
    final Database db = await getDatabaseVisits(dbVisits);
    final Database db2 = await getDatabaseExposures(dbExposures);

    if (!globals.dbExposedAttached) {
      await attachDb(
          db,
          join(await getDatabasesPath(), '${dbExposures}_database.db'),
          dbExposures);
      globals.dbExposedAttached = true;
    }

    int exposureCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) '
            'FROM ${dbVisits} v, ${dbExposures}.${dbExposures} e '
            'WHERE v.datetime = e.datetime AND v.location = e.location'));

    if (exposureCount > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getDatabasePathVisits() async {
    final dbName = 'visits';
    return join(await getDatabasesPath(), '${dbName}_database.db');
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
