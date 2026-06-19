import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

class AlertHelperForSubsPopup {
  static void showSubscriptionEndAlert({
    required BuildContext context,
    required String title,
    required String message,
    required Widget navigateTo,
    bool? isFromTrackingClass,
    String buttonText = "Go to Subscription",
    Color buttonTextColor = AppColors.customBottomEnabledColour,
    Color? buttonBackgroundColor,
    VoidCallback? onGoToFirstTab,
    bool? isFromWilcoAndTrackingScreen,
    VoidCallback? onGoToActionBlock,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 20, 10),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (isFromTrackingClass == true) {
                    Navigator.of(ctx).pop();
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onGoToFirstTab?.call();
                  });
                },
                child: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          content: Text(message),
          actions: [
            if (isFromWilcoAndTrackingScreen == true) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: buttonBackgroundColor != null
                        ? TextButton.styleFrom(
                            backgroundColor: buttonBackgroundColor,
                          )
                        : null,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onGoToActionBlock?.call();
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

                  TextButton(
                    style: buttonBackgroundColor != null
                        ? TextButton.styleFrom(
                            backgroundColor: buttonBackgroundColor,
                          )
                        : null,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: buttonBackgroundColor != null
                            ? Colors.white
                            : buttonTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              TextButton(
                style: buttonBackgroundColor != null
                    ? TextButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                      )
                    : null,
                onPressed: () {
                  Navigator.of(ctx).pop();

                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => navigateTo));
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
