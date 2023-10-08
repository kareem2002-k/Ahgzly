import 'package:flutter/material.dart';

class SportButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const SportButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 42,
        width: 140, // Increase button width
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2ECC71)
              : const Color.fromARGB(255, 239, 236, 236),
          borderRadius: BorderRadius.circular(10.69),
          boxShadow: [
            if (selected)
              const BoxShadow(
                color: Color(0x14363B64),
                blurRadius: 25.66,
                offset: Offset(0, 8.55),
                spreadRadius: 2.14,
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF848484),
              fontSize: 14, // Increase font size
              fontFamily: 'Raleway',
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
