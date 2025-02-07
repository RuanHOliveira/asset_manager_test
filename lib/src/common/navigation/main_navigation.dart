import 'package:asset_manager_test/models/user.dart';
import 'package:asset_manager_test/src/common/widgets/useful/custom_bottom_navigation_bar.dart';
import 'package:asset_manager_test/views/pages/assets_linked_list/assets_link_list.dart';
import 'package:asset_manager_test/views/pages/assets_list/assets_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainNavigation extends StatefulWidget {
  final User? user;

  const MainNavigation({super.key, this.user});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AssetsLinkList(user: widget.user!),
      AssetsList(user: widget.user),
    ];
  }

  void _navigateBottomBar(int index) {
    if (index != 1) {
      setState(() {
        _selectedIndex = index;
      });
    }

    if (index == 1) {
      if (widget.user?.type == 1) {
        setState(() {
          _selectedIndex = index;
        });
      }

      if (widget.user?.type != 1) {
        Fluttertoast.showToast(
          msg: 'Usuário sem acesso!',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: const Text(
          'Controle de equipamentos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        navigateBottomBar: _navigateBottomBar,
      ),
    );
  }
}
