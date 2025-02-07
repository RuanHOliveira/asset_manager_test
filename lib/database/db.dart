import 'package:asset_manager_test/database/dao/assets_dao.dart';
import 'package:asset_manager_test/database/dao/users_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'asset_manager_test.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(UsersDao.tableSql);
    await db.execute(AssetsDao.tableSql);
    await db.insert('users', {
      'cpf': '99999999999',
      'name': 'Usuário Administrador',
      'password': '123456',
      'type': 1,
    });
  }
}
