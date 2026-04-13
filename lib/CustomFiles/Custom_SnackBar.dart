import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSnackBar {
  AppSnackBar._();

  static void custom(
      BuildContext ctx, {
        required String message,
        required String svgAsset,
        Color backgroundColor = AppColors.primaryDark,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        elevation: 6,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            svgAsset == ""
                ? const Wrap()
                : SvgPicture.asset(
              svgAsset,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            SizedBox(width: svgAsset == ""
                ?  0
                : 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(ctx).hideCurrentSnackBar(),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
