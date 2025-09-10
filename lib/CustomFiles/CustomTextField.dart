import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
        errorText: widget.errorText,
        errorMaxLines: 3,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: widget.obscureText
            ? IconButton(
                padding: const EdgeInsets.all(0),
                iconSize: 20.0,
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: _isObscure ? Colors.grey : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
