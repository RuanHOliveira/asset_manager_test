import 'dart:convert';

import 'package:asset_manager_test/controllers/assets_controller.dart';
import 'package:asset_manager_test/controllers/users_controller.dart';
import 'package:asset_manager_test/models/asset.dart';
import 'package:asset_manager_test/models/user.dart';
import 'package:asset_manager_test/src/common/widgets/useful/row_info_card.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CardAssetLinked extends StatefulWidget {
  final User user;
  final Asset asset;
  final Function refreshFunction;

  const CardAssetLinked({
    super.key,
    required this.asset,
    required this.refreshFunction,
    required this.user,
  });

  @override
  State<CardAssetLinked> createState() => _CardAssetLinkedState();
}

class _CardAssetLinkedState extends State<CardAssetLinked> {
  final AssetsController assetsController = AssetsController();
  final UsersController usersController = UsersController();

  User? userLinked;
  String dtInventory = 'Inventário necessário.';

  @override
  void initState() {
    super.initState();
    if (widget.asset.userId != null) {
      _getUserLinked(id: widget.asset.userId.toString());
    }

    if (widget.asset.dtInventory != null) {
      dtInventory = DateFormat('dd/MM/yyyy')
          .format(DateTime.parse(widget.asset.dtInventory!));
    }
  }

  Future<void> _getUserLinked({required String id}) async {
    userLinked = await usersController.getUserById(id: id);
  }

  bool isInventoryOutdated() {
    if (widget.asset.dtInventory == null) return true;

    DateTime? inventoryDate = DateTime.tryParse(widget.asset.dtInventory!);
    if (inventoryDate == null) return true;

    DateTime today = DateTime.now();
    int differenceInDays = today.difference(inventoryDate).inDays;

    return differenceInDays > 30;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: isInventoryOutdated()
                        ? Colors.red.shade500
                        : Colors.green.shade500,
                    width: 5),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.asset.name.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      Text(
                        isInventoryOutdated()
                            ? 'Necessário novo inventário'
                            : 'Inventário válido',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isInventoryOutdated()
                              ? Colors.red.shade500
                              : Colors.green.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 20, thickness: 1),
                CustomRowInfoCard(
                  icon: Icons.qr_code_2_rounded,
                  label: 'Código:',
                  value: widget.asset.code.toString(),
                ),
                const SizedBox(height: 10),
                CustomRowInfoCard(
                  icon: Icons.date_range_rounded,
                  label: 'Data inventário:',
                  value: dtInventory,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.blue.shade900),
                    ),
                    onPressed: () {
                      _readQrCode();
                    },
                    child: const Text(
                      'Realizar inventário',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _readQrCode() async {
    var resultScan = await BarcodeScanner.scan(
      options: const ScanOptions(
        restrictFormat: [
          BarcodeFormat.qr,
        ],
      ),
    );
    if (resultScan.rawContent.isNotEmpty) {
      Map<String, dynamic> resultJson = jsonDecode(resultScan.rawContent);
      Map<String, String> parsedResult =
          resultJson.map((key, value) => MapEntry(key, value.toString()));

      if (widget.asset.code.toString() == parsedResult['code'] &&
          widget.asset.name.toString() == parsedResult['name']) {
        if (await assetsController.updateDtInventoryAssetById(
          id: widget.asset.id.toString(),
          dtInventory: DateTime.now().toString().substring(0, 10),
        )) {
          Fluttertoast.showToast(
            msg: 'Inventário realizado com sucesso!',
            toastLength: Toast.LENGTH_LONG,
          );
          widget.refreshFunction();
        }
      } else {
        Fluttertoast.showToast(
          msg: 'QR Code divergente do equipamentoo vinculado!',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }
}
