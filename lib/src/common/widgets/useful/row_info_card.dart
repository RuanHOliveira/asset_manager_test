import 'package:flutter/material.dart';

class CustomRowInfoCard extends StatefulWidget {
  final String label;
  final String? value;
  final IconData icon;

  const CustomRowInfoCard({
    super.key,
    required this.label,
    required this.icon,
    this.value,
  });

  @override
  State<CustomRowInfoCard> createState() => _CustomRowInfoCardState();
}

class _CustomRowInfoCardState extends State<CustomRowInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(widget.icon, color: Colors.blue.shade900),
        const SizedBox(width: 10),
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.value ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
