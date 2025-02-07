import 'dart:convert';

import 'package:asset_manager_test/controllers/assets_controller.dart';
import 'package:asset_manager_test/controllers/users_controller.dart';
import 'package:asset_manager_test/models/asset.dart';
import 'package:asset_manager_test/models/user.dart';
import 'package:asset_manager_test/src/common/widgets/useful/custom_search_bar.dart';
import 'package:asset_manager_test/views/pages/assets_list/card_asset.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssetsList extends StatefulWidget {
  final User? user;

  const AssetsList({super.key, required this.user});

  @override
  State<AssetsList> createState() => _AssetsListState();
}

class _AssetsListState extends State<AssetsList> {
  final AssetsController assetsController = AssetsController();
  final UsersController usersController = UsersController();

  bool _isLoading = true;
  List<CardAsset> _cards = [];
  List<CardAsset> _filteredCards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _buildLoadingIndicator() : _buildContent(),
      floatingActionButton: _buildFloatActionButton(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade900),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 10),
        CustomSearchBar(onChanged: _filterCards),
        Expanded(
          child: _filteredCards.isNotEmpty
              ? ListView.builder(
                  itemCount: _filteredCards.length,
                  itemBuilder: (context, index) {
                    return _filteredCards[index];
                  },
                )
              : const Center(
                  heightFactor: 5,
                  child: Text("Nenhum registro encontrado."),
                ),
        ),
      ],
    );
  }

  Widget _buildFloatActionButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: Colors.blue.shade900,
      child: const Icon(
        Icons.qr_code_2_rounded,
        size: 30.0,
        color: Colors.white,
      ),
      onPressed: () => _readQrCode(),
    );
  }

  Future<void> _readQrCode() async {
    try {
      var resultScan = await BarcodeScanner.scan(
        options: const ScanOptions(
          android: AndroidOptions(),
          restrictFormat: [BarcodeFormat.qr],
        ),
      );

      if (resultScan.rawContent.isNotEmpty) {
        Map<String, dynamic> resultJson = jsonDecode(resultScan.rawContent);
        Map<String, String> parsedResult =
            resultJson.map((key, value) => MapEntry(key, value.toString()));

        bool exists = await assetsController.verifyExistAssetByNameAndCode(
          name: parsedResult['name'] as String,
          code: parsedResult['code'] as String,
        );

        if (!exists) {
          bool confirm = await _showConfirmationDialog(
            context,
            title: "Confirmar cadastro",
            content:
                "Deseja cadastrar o equipamento '${parsedResult['name']}' com código '${parsedResult['code']}'?",
          );

          if (confirm) {
            bool success = await assetsController.setAsset(
              name: parsedResult['name'] as String,
              code: parsedResult['code'] as String,
            );

            if (success) {
              Fluttertoast.showToast(
                msg: 'Equipamento cadastrado com sucesso!',
                toastLength: Toast.LENGTH_LONG,
              );
              _loadCards();
            }
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Equipamento já cadastrado!',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'QR Code vazio ou leitura cancelada!',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      print('Erro ao ler QR Code: $e');
    }
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Confirmar"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _loadCards() async {
    setState(() => _isLoading = true);
    try {
      List<Asset>? listAssets = await assetsController.getAllAssets();
      if (listAssets != null) {
        _cards = await _buildListCards(
          listAssets: listAssets,
          refreshFunction: _loadCards,
        );
        setState(() {
          _filteredCards = _cards;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<List<CardAsset>> _buildListCards({
    List<Asset>? listAssets,
    required refreshFunction,
  }) async {
    List<CardAsset> listCards = List.empty(growable: true);

    for (Asset asset in listAssets!) {
      User? userLinked =
          await usersController.getUserById(id: asset.userId.toString());
      listCards.add(CardAsset(
        asset: asset,
        userLinked: userLinked,
        refreshFunction: refreshFunction,
      ));
    }
    return listCards;
  }

  void _filterCards(String query) {
    setState(() {
      _filteredCards = query.isNotEmpty
          ? _cards.where((asset) {
              final queryLower = query.toLowerCase();
              return [
                asset.asset.name.toString(),
                asset.asset.code.toString(),
              ].any((field) => field.toLowerCase().contains(queryLower));
            }).toList()
          : _cards;
    });
  }
}
