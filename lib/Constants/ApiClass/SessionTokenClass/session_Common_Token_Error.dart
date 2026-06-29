import 'dart:io';

import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared_prefs_helper.dart';

class SessionCommonTokenError {
  static void handleUnauthorizedError(BuildContext context, Object error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains("unauthorized") || errorMessage.contains("401")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please login again.')),
      );

      Future.delayed(const Duration(seconds: 1), () async {
        await SharedPrefsHelper.clearAll([], false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      });
    }
  }
}