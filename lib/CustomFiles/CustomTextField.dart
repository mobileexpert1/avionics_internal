import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    required this.label,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, errorText: errorText),
    );
  }
}
