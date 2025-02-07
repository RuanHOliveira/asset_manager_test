import 'package:asset_manager_test/database/dao/assets_dao.dart';
import 'package:asset_manager_test/models/asset.dart';
import 'package:asset_manager_test/models/user.dart';

class AssetsController {
  final AssetsDao assetsDao = AssetsDao();

  Future<List<Asset>?> getAssetsLinkedInUser({required User user}) async {
    return await assetsDao.getAssetsLinkedInUser(user: user);
  }

  Future<List<Asset>?> getAllAssets() async {
    return await assetsDao.getAllAssets();
  }

  Future<bool> linkAsset({required int assetId, required int userId}) async {
    return assetsDao.linkAsset(assetId: assetId, userId: userId);
  }

  Future<bool> setAsset({required String name, required String code}) async {
    return assetsDao.setAsset(name: name, code: code);
  }

  Future<bool> verifyExistAssetByNameAndCode({
    required String name,
    required String code,
  }) async {
    return assetsDao.verifyExistAssetByNameAndCode(name: name, code: code);
  }

  Future<bool> updateDtInventoryAssetById({
    required String id,
    required String dtInventory,
  }) async {
    return assetsDao.updateDtInventoryAssetById(
        id: id, dtInventory: dtInventory);
  }
}
