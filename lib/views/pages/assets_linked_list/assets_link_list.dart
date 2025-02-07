import 'package:asset_manager_test/controllers/assets_controller.dart';
import 'package:asset_manager_test/models/asset.dart';
import 'package:asset_manager_test/models/user.dart';
import 'package:asset_manager_test/src/common/widgets/useful/custom_search_bar.dart';
import 'package:asset_manager_test/views/pages/assets_linked_list/card_asset_linked.dart';
import 'package:flutter/material.dart';

class AssetsLinkList extends StatefulWidget {
  final User user;

  const AssetsLinkList({super.key, required this.user});

  @override
  State<AssetsLinkList> createState() => _AssetsLinkListState();
}

class _AssetsLinkListState extends State<AssetsLinkList> {
  final AssetsController assetsController = AssetsController();

  bool _isLoading = true;
  List<CardAssetLinked> _cards = [];
  List<CardAssetLinked> _filteredCards = [];

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

  Future<void> _loadCards() async {
    setState(() => _isLoading = true);
    try {
      List<Asset>? listAssets =
          await assetsController.getAssetsLinkedInUser(user: widget.user);
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

  Future<List<CardAssetLinked>> _buildListCards({
    List<Asset>? listAssets,
    required refreshFunction,
  }) async {
    List<CardAssetLinked> listCards = List.empty(growable: true);

    for (Asset asset in listAssets!) {
      listCards.add(CardAssetLinked(
        asset: asset,
        refreshFunction: refreshFunction,
        user: widget.user,
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
                asset.asset.dtInventory.toString(),
              ].any((field) => field.toLowerCase().contains(queryLower));
            }).toList()
          : _cards;
    });
  }
}
