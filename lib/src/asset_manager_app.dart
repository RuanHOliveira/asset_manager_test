import 'package:asset_manager_test/src/pages/splash_page.dart';
import 'package:flutter/material.dart';

class AssetManagerApp extends StatefulWidget {
  const AssetManagerApp({super.key});

  @override
  State<AssetManagerApp> createState() => _AssetManagerAppState();
}

class _AssetManagerAppState extends State<AssetManagerApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
