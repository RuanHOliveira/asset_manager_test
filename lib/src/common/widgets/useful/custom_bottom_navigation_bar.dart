import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) navigateBottomBar;
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.navigateBottomBar,
  });
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue.shade900,
      currentIndex: widget.selectedIndex,
      onTap: widget.navigateBottomBar,
      selectedLabelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade500,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list_rounded,
            color: Colors.grey.shade500,
          ),
          activeIcon: const Icon(
            Icons.list_rounded,
            color: Colors.white,
          ),
          label: 'Equipamentos vinculados',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.computer_rounded,
            color: Colors.grey.shade500,
          ),
          activeIcon: const Icon(
            Icons.computer_rounded,
            color: Colors.white,
          ),
          label: 'Equipamentos',
        ),
      ],
    );
  }
}
