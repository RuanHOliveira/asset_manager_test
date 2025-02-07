import 'package:asset_manager_test/database/db.dart';
import 'package:asset_manager_test/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UsersDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_cpf TEXT UNIQUE, '
      '$_name TEXT, '
      '$_password TEXT, '
      '$_type INTEGER DEFAULT 2, '
      '$_status INTEGER DEFAULT 1)';

  static const String _tableName = 'users';
  static const String _id = 'id';
  static const String _cpf = 'cpf';
  static const String _name = 'name';
  static const String _password = 'password';
  static const String _type = 'type';
  static const String _status = 'status';

  Future<bool> registerUser({
    required String name,
    required String cpf,
    required String password,
  }) async {
    try {
      final Database db = await DB.instance.database;
      int result = await db.insert(
        _tableName,
        {
          _name: name,
          _cpf: cpf,
          _password: password,
        },
      );

      return result > 0;
    } catch (e) {
      print('Erro ao inserir usuário: $e');
      return false;
    }
  }

  Future<bool> verifyExistUserByCpf({required String cpf}) async {
    try {
      final Database db = await DB.instance.database;

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_cpf = ?',
        whereArgs: [cpf],
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar usuário por CPF: $e');
      return false;
    }
  }

  Future<User?> getUserByCpf({required String cpf}) async {
    try {
      final Database db = await DB.instance.database;

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_cpf = ?',
        whereArgs: [cpf],
      );

      return result.isNotEmpty ? User.fromMap(result.first) : null;
    } catch (e) {
      print('Erro ao consultar o usuário: $e');
      return null;
    }
  }

  Future<User?> getUserById({required String id}) async {
    try {
      final Database db = await DB.instance.database;

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_id = ?',
        whereArgs: [id],
      );

      return result.isNotEmpty ? User.fromMap(result.first) : null;
    } catch (e) {
      print('Erro ao consultar o usuário: $e');
      return null;
    }
  }

  Future<bool> tryLogin({
    required String cpf,
    required String password,
  }) async {
    try {
      final Database db = await DB.instance.database;

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_cpf = ? AND $_password = ?',
        whereArgs: [cpf, password],
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Erro ao consultar o usuário: $e');
      return false;
    }
  }

  Future<List<User>?> getAllUsers() async {
    try {
      final Database db = await DB.instance.database;
      List<User> listReturn = List.empty(growable: true);

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_status = ?',
        whereArgs: [1],
      );

      if (result.isNotEmpty) {
        for (var userMap in result) {
          listReturn.add(User.fromMap(userMap));
        }

        return listReturn;
      }
    } catch (e) {
      print('Erro ao consultar usuários: $e');
      return null;
    }
    return null;
  }
}
