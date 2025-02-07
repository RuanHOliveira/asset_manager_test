import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function onChanged;

  const CustomSearchBar({super.key, required this.onChanged});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          style: TextStyle(
            color: Colors.blue.shade500,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            hintText: 'Pesquisar',
            hintStyle: const TextStyle(
              color: Colors.blue,
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.blue,
            ),
          ),
          onChanged: (String value) {
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}
