import 'package:get_state/controllers/user_controller.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteService {
  static Database? _db;
  static final SqfliteService _service = SqfliteService._internal();
  static Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }
  
  static Future<Database?> initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        """);
      },
    );
  }

  Future<bool> getUser(String email) async {
    final db = await database;
    final result = await db.query("users", where: "email = ?", whereArgs: [email], limit: 1);
    if(result.isNotEmpty) {
        return true;
    }
    return false;
  }

  Future<bool> insertUser(User user) async {
    final db = await database;
    try {
      // check the user is exists
      final result = await db.query("users", where: "email = ?", whereArgs: [user.email], limit: 1);
      if(result.isNotEmpty) {
        return false;
      }
      await db.insert("users", user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      throw "Can't insert the User";
    }
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    try {
      List<Map<String, dynamic>> users = await db.query("users");
      return users.map((user) => User.fromJson(user),).toList();
    }catch (e) {
      throw "Can't get users";
    }
  }

  Future<bool> updateUser(User user) async {
    final db = await database;
    try {
      await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return true;
    } catch (e) {
      throw "Can't update the user";
    }
  }

  Future<bool> deleteUser(int id) async {
    final db = await database;
    try {
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      throw "Can't delete user";
    }
  }


  Future<bool> addUsers(List<User> users) async {
    try {
      final db = await database;
      Batch batch = db.batch();
      for (var user in users) {
        batch.insert("users", user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      throw "Can't add users";
    }
  }

  static Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }
  factory SqfliteService() => _service;
  SqfliteService._internal();
}