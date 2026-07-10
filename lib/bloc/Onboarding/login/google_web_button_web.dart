import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

class GoogleWebButton extends StatelessWidget {
  const GoogleWebButton({super.key});

  @override
  Widget build(BuildContext context) {
    print('===== WEB BUTTON FILE LOADED =====');
    print('kIsWeb = $kIsWeb');

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: web.renderButton(),
    );
  }
}
