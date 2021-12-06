import 'dart:io';

import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:schedule_it/model/activity_item.dart';
import 'package:schedule_it/model/table_item.dart';
import 'package:schedule_it/model/timeTable_item.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
//////////////////////////
  final String tableName = "activity";
  final String columnId = "id";
  final String columnActivityName = "activityName";
  final String columnStartTime = "startTime";
  final String columnEndTime = "endTime";
  final String columnLocation = "location";
  final String columnDescription = "description";
  final String columnDateCreated = "dateCreated";
  ///////////////////////////////
  final String timeTableTableName = "timeTables";
  final String columnTimeTableId = "id";
  final String columnTimeTableName = "timeTableName";
  final String columnTimeTableDescription = "description";
  final String columnTimeTableDateCreated = "dateCreated";
  /////////////////////////////////////////////

  final String tableTableName = "timeTable";
  final String timeTableName = "timeTableName";
  final String columnTableId = "id";
  final String columnTableActivityName = "activityName";
  final String columnTableStartTime = "startTime";
  final String columnTableEndTime = "endTime";
  final String columnTableLocation = "location";
  final String columnTableDay = "day";
  final String columnTableDateCreated = "dateCreated";
  ////////////////////////////////////////////////


  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notodo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnActivityName TEXT, $columnStartTime TEXT, $columnEndTime TEXT, $columnLocation TEXT, $columnDescription TEXT, $columnDateCreated TEXT)");
    print("Table Activities is created");

    await db.execute(
        "CREATE TABLE $timeTableTableName(id INTEGER PRIMARY KEY, $columnTimeTableName TEXT, $columnTimeTableDescription TEXT, $columnTimeTableDateCreated TEXT)");
    print("Table timeTablesTable is created");

    await db.execute(
        "CREATE TABLE $tableTableName(id INTEGER PRIMARY KEY, $timeTableName TEXT, $columnTableActivityName TEXT, $columnTableStartTime TEXT, $columnTableEndTime TEXT, $columnTableLocation TEXT, $columnTableDay TEXT, $columnTableDateCreated TEXT )");
    print("Table TimeTable is created");
  }

//////////insertion///////////////
  Future<int> saveActivityItem(ActivityItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  Future<int> saveTimeTableItem(TimeTableItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$timeTableTableName", item.toMap());
    print(res.toString());
    return res;
  }

  Future<int> saveTableItem(TableItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableTableName", item.toMap());
    print(res.toString());
    return res;
  }

  //////////////////Get/////////////

  Future<List> getActivityItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnActivityName ASC"); //ASC

    return result.toList();

  }
  Future<List> getTimeTableItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $timeTableTableName ORDER BY $columnTimeTableName ASC"); //ASC

    return result.toList();

  }

  Future<List> getTableItems(String name) async {
    var tTableName = name;
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTableName WHERE $timeTableName IN (?) ORDER BY $columnTableActivityName ASC", [tTableName]); //ASC

    return result.toList();


  }

  Future<List> getDayItems(String day) async {
    var tTableDay = day;
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTableName WHERE $columnTableDay IN (?) ORDER BY $columnTableActivityName ASC", [tTableDay]); //ASC

    return result.toList();


  }


//////////////////GET COUNT/////////////////////

  Future<int> getActivityItemCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }
  Future<int> getTimeTableItemCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $timeTableTableName"
    ));
  }

  Future<int> getTableCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableTableName"
    ));
  }
//////////////////READ////////////////////////////
  Future<ActivityItem> getActivityItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new ActivityItem.fromMap(result.first);
  }

  Future<TimeTableItem> getTimeTableItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $timeTableTableName WHERE id = $id");
    if (result.length == 0) return null;
    return new TimeTableItem.fromMap(result.first);
  }

  Future<TableItem> getTableItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTableName WHERE id = $id");
    if (result.length == 0) return null;
    return new TableItem.fromMap(result.first);
  }
  //deletion
//  Future<int> deleteItem(int id) async {
//    var dbClient = await db;
//    var result = await dbClient.rawQuery("DELETE FROM $tableName WHERE id = $id");
//    if (result.length == 0) return null;
//    return result.first as int;
//  }
/////////////////////////DELETE/////////////////////
  Future<int> deleteActivityItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$columnId = ?", whereArgs: [id]);

  }

  Future<int> deleteTimeTableItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(timeTableTableName,
        where: "$columnId = ?", whereArgs: [id]);


  }

  Future<int> deleteTableItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableTableName,
        where: "$columnTableId = ?", whereArgs: [id]);

  }
  Future<int> deleteDependentTableItem(String tTableName) async {
    var dbClient = await db;
    return await dbClient.delete(tableTableName,
        where: "$timeTableName = ?", whereArgs: [tTableName]);

  }
  /////////////UPDATE//////////////////////////
  Future<int> updateActivityItem(ActivityItem item) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);

  }
  Future<int> updateTimeTableItem(TimeTableItem item) async {
    var dbClient = await db;
    return await dbClient.update("$timeTableTableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);

  }

  Future<int> updateTableItem(TableItem item) async {
    var dbClient = await db;
    return await dbClient.update("$tableTableName", item.toMap(),
        where: "$columnTableId = ?", whereArgs: [item.id]);

  }
//////////////CLOSE////////////////
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
