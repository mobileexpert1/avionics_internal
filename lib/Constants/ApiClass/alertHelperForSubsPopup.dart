import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

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
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: Colors.white,
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
                  MaterialPageRoute(builder: (_) => navigateTo),
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
