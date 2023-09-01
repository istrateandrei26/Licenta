import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LoggedUser {
  final int userId;
  final int signedWithGoogle;

  LoggedUser({required this.userId, required this.signedWithGoogle});

  factory LoggedUser.fromMap(Map<String, dynamic> json) => LoggedUser(
      userId: json['userId'], signedWithGoogle: json['signedWithGoogle']);

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'signedWithGoogle': signedWithGoogle};
  }
}

class SqliteDatabaseHelper {
  SqliteDatabaseHelper._privateConstructor();

  static final SqliteDatabaseHelper instance =
      SqliteDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'loggedUsers.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE loggedUsers(
        userId INTEGER PRIMARY KEY,
        signedWithGoogle INTEGER
      )
    ''');
  }

  static Future deleteLocalDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'loggedUsers.db');
  await SqliteDatabaseHelper.instance.deleteDatabase(path);

  }

  Future<List<LoggedUser>> getLoggedUsers() async {
    Database db = await instance.database;

    var loggedUsers = await db.query('loggedUsers', orderBy: 'userId');
    List<LoggedUser> loggedUsersList = loggedUsers.isNotEmpty
        ? loggedUsers.map((e) => LoggedUser.fromMap(e)).toList()
        : [];

    return loggedUsersList;
  }

  Future<int> add(LoggedUser user) async {
    Database db = await instance.database;

    await db.rawDelete("delete from loggedUsers"); // only one logged user at a time

    return await db.insert('loggedUsers', user.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;

    return await db.delete('loggedUsers', where: 'userId = ?', whereArgs: [id]);
  }
}
