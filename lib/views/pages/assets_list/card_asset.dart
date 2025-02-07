import 'package:asset_manager_test/controllers/assets_controller.dart';
import 'package:asset_manager_test/controllers/users_controller.dart';
import 'package:asset_manager_test/models/asset.dart';
import 'package:asset_manager_test/models/user.dart';
import 'package:asset_manager_test/src/common/widgets/useful/row_info_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CardAsset extends StatefulWidget {
  final Asset asset;
  final User? userLinked;
  final Function refreshFunction;

  const CardAsset({
    super.key,
    required this.asset,
    required this.refreshFunction,
    this.userLinked,
  });

  @override
  State<CardAsset> createState() => _CardAssetState();
}

class _CardAssetState extends State<CardAsset> {
  final UsersController usersController = UsersController();
  final AssetsController assetsController = AssetsController();

  String userLinkedName = 'Nenhum usuário vinculado.';

  @override
  void initState() {
    super.initState();
    if (widget.userLinked != null) {
      setState(() {
        userLinkedName = widget.userLinked?.name as String;
      });
    }
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.asset.name.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
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
                  icon: Icons.person_rounded,
                  label: 'Usuário:',
                  value: userLinkedName,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.blue.shade900),
                    ),
                    onPressed: () async {
                      await _linkUser();
                    },
                    child: const Text(
                      'Vincular usuário',
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

  Future<void> _linkUser() async {
    List<User>? users = await usersController.getAllUsers();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              const Text(
                'Selecione um usuário',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: users?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue.shade900,
                      ),
                      title: Text(users?[index].name as String),
                      onTap: () async {
                        setState(() {
                          userLinkedName == users?[index].name;
                        });
                        await _updateAsset(id: users?[index].id as int);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _updateAsset({required int id}) async {
    if (await assetsController.linkAsset(
        assetId: widget.asset.id as int, userId: id)) {
      Fluttertoast.showToast(
        msg: 'Usuário vinculado!',
        toastLength: Toast.LENGTH_LONG,
      );

      widget.refreshFunction();
      return true;
    }

    Fluttertoast.showToast(
      msg: 'Erro ao vincular usuário!',
      toastLength: Toast.LENGTH_LONG,
    );
    return false;
  }
}
