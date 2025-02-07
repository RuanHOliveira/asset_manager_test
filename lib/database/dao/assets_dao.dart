import 'package:asset_manager_test/database/db.dart';
import 'package:asset_manager_test/models/asset.dart';
import 'package:asset_manager_test/models/user.dart';
import 'package:sqflite/sqflite.dart';

class AssetsDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_name TEXT, '
      '$_code TEXT, '
      '$_userId INTEGER DEFAULT NULL, '
      '$_dtInventory TEXT DEFAULT NULL, '
      '$_status INTEGER DEFAULT 1)';

  static const String _tableName = 'assets';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _code = 'code';
  static const String _userId = 'userId';
  static const String _dtInventory = 'dtInventory';
  static const String _status = 'status';

  Future<bool> setAsset({required String name, required String code}) async {
    try {
      final Database db = await DB.instance.database;
      int result = await db.insert(
        _tableName,
        {
          _name: name,
          _code: code,
        },
      );

      return result > 0;
    } catch (e) {
      print('Erro ao inserir equipamento: $e');
      return false;
    }
  }

  Future<bool> verifyExistAssetByNameAndCode({
    required String name,
    required String code,
  }) async {
    try {
      final Database db = await DB.instance.database;

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_name = ? AND $_code = ?',
        whereArgs: [name, code],
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar equipámento: $e');
      return false;
    }
  }

  Future<List<Asset>?> getAssetsLinkedInUser({required User user}) async {
    try {
      final Database db = await DB.instance.database;
      List<Asset> listReturn = List.empty(growable: true);

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_userId = ?',
        whereArgs: [user.id],
      );

      if (result.isNotEmpty) {
        for (var assetMap in result) {
          listReturn.add(Asset.fromMap(assetMap));
        }

        return listReturn;
      }
    } catch (e) {
      print('Erro ao consultar o equipamentos: $e');
      return null;
    }
    return null;
  }

  Future<Asset?> getAssetById({required int id}) async {
    try {
      final Database db = await DB.instance.database;
      List<Asset> listReturn = List.empty(growable: true);

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_id = ?',
        whereArgs: [id],
      );

      return result.isNotEmpty ? Asset.fromMap(result.first) : null;
    } catch (e) {
      print('Erro ao consultar o equipamentos: $e');
      return null;
    }
  }

  Future<List<Asset>?> getAllAssets() async {
    try {
      final Database db = await DB.instance.database;
      List<Asset> listReturn = List.empty(growable: true);

      List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: '$_status = ?',
        whereArgs: [1],
      );

      if (result.isNotEmpty) {
        for (var assetMap in result) {
          listReturn.add(Asset.fromMap(assetMap));
        }

        return listReturn;
      }
    } catch (e) {
      print('Erro ao consultar o equipamentos: $e');
      return null;
    }
    return null;
  }

  Future<bool> linkAsset({required int assetId, required int userId}) async {
    try {
      Map<String, Object?> values = {'userId': userId};
      Asset? asset = await getAssetById(id: assetId);

      if (asset != null && asset?.userId != userId) {
        values['dtInventory'] = null;
      }

      final Database db = await DB.instance.database;

      int updatedRows = await db.update(
        _tableName,
        values,
        where: 'id = ?',
        whereArgs: [assetId],
      );

      return updatedRows > 0;
    } catch (e) {
      print('Erro ao atualizar o equipamento: $e');
      return false;
    }
  }

  Future<bool> updateDtInventoryAssetById({
    required String id,
    required String dtInventory,
  }) async {
    try {
      final Database db = await DB.instance.database;

      int updatedRows = await db.update(
        _tableName,
        {'dtInventory': dtInventory},
        where: 'id = ?',
        whereArgs: [id],
      );

      return updatedRows > 0;
    } catch (e) {
      print('Erro ao atualizar o equipamento: $e');
      return false;
    }
  }
}
