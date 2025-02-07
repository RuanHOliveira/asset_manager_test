import 'package:asset_manager_test/database/db.dart';
import 'package:asset_manager_test/src/asset_manager_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.database;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const AssetManagerApp());
}
