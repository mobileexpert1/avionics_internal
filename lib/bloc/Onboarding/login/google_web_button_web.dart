import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

class GoogleWebButton extends StatefulWidget {
  const GoogleWebButton({super.key});

  @override
  State<GoogleWebButton> createState() => _GoogleWebButtonState();
}

class _GoogleWebButtonState extends State<GoogleWebButton> {
  late final Widget _button;

  @override
  void initState() {
    super.initState();

    debugPrint("Google button created ONCE");

    _button = SizedBox(
      width: double.infinity,
      height: 60,
      child: web.renderButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Google button rebuild");

    return _button;
  }
}