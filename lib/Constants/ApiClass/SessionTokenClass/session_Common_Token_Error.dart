import 'package:flutter/material.dart';
import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';

class SessionCommonTokenError {
  static void handleUnauthorizedError(BuildContext context, Object error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains("unauthorized") || errorMessage.contains("401")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please login again.')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
              (route) => false,
        );
      });
    }
  }
}
