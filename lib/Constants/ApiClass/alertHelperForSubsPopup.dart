import 'package:flutter/material.dart';
import 'package:avionics_internal/Constants/AppColors.dart';

class AlertHelperForSubsPopup {
  static void showSubscriptionEndAlert({
    required BuildContext context,
    required String title,
    required String message,
    required Widget navigateTo,
    String buttonText = "Go to Subscription",
    Color buttonTextColor = AppColors.customBottomEnabledColour,
    Color? buttonBackgroundColor,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true, // ✅ IMPORTANT FIX
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              style: buttonBackgroundColor != null
                  ? TextButton.styleFrom(
                backgroundColor: buttonBackgroundColor,
              )
                  : null,
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => navigateTo,
                  ),
                );
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  color: buttonBackgroundColor != null
                      ? Colors.white
                      : buttonTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}