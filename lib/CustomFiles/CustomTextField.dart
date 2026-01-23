import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onEnterPressed;
  final bool enabled;
  final bool isMultiline;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.onChanged,
    this.onEnterPressed,
    this.enabled = true,
    this.isMultiline = false,
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
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (widget.onEnterPressed == null) return;
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter &&
            !event.isShiftPressed) {
          widget.onEnterPressed?.call(widget.controller.text.trim());
        }
      },
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscure,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        minLines: widget.isMultiline ? 1 : 1,
        maxLines: widget.isMultiline ? 5 : 1,
        keyboardType: widget.isMultiline
            ? TextInputType.multiline
            : TextInputType.text,
        textInputAction: widget.isMultiline
            ? TextInputAction.newline
            : TextInputAction.done,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.black),
          floatingLabelStyle: const TextStyle(color: Colors.black),
          errorText: widget.errorText,
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: widget.obscureText
              ? IconButton(
                  padding: EdgeInsets.zero,
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
      ),
    );
  }
}
