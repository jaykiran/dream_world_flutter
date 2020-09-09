import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models.dart';

class DreamDatabaseService {
  String path;

  DreamDatabaseService._();

  static final DreamDatabaseService db = DreamDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'dreams.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Dreams (_id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, isImportant INTEGER);');
      print('New table created at $path');
    });
  }

  Future<List<DreamsModel>> getDreamsFromDB() async {
    final db = await database;
    List<DreamsModel> dreamsList = [];
    List<Map> maps = await db.query('dreams',
        columns: ['_id', 'title', 'content', 'date', 'isImportant']);
    if (maps.length > 0) {
      maps.forEach((map) {
        dreamsList.add(DreamsModel.fromMap(map));
      });
    }
    return dreamsList;
  }

  updateDreamInDB(DreamsModel updatedDream) async {
    final db = await database;
    await db.update('Dreams', updatedDream.toMap(),
        where: '_id = ?', whereArgs: [updatedDream.id]);
    print('Dream updated: ${updatedDream.title} ${updatedDream.content}');
  }

  deleteDreamInDB(DreamsModel dreamToDelete) async {
    final db = await database;
    await db.delete('Dreams', where: '_id = ?', whereArgs: [dreamToDelete.id]);
    print('Dream deleted');
  }

  Future<DreamsModel> addDreamInDB(DreamsModel newDream) async {
    final db = await database;
    if (newDream.title.trim().isEmpty) newDream.title = 'Untitled Dream';
    int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Dreams(title, content, date, isImportant) VALUES ("${newDream.title}", "${newDream.content}", "${newDream.date.toIso8601String()}", ${newDream.isImportant == true ? 1 : 0});');
    });
    newDream.id = id;
    print('Dream added: ${newDream.title} ${newDream.content}');
    return newDream;
  }
}
