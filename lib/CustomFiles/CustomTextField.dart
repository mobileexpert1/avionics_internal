import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Helpers/AppTextStyles/AppTextStyles.dart';

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
        style: const TextStyle(color: AppColors.primaryDark),
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
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryDark),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryDark),
          ),
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 30),
          floatingLabelStyle: AppTextStyles.regular(
            17.16,
          ).copyWith(height: 1.0, color: AppColors.greyForTextfield),
          errorText: widget.errorText,
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: widget.obscureText
              ? IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20.0,
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(
                      _isObscure == true
                          ? AssetsPath.visibilityOff
                          : AssetsPath.visibilityOn,
                    ),
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
