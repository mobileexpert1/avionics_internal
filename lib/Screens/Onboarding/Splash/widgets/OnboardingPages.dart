import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../../CustomFiles/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingInfo info;

  const OnboardingPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double _getResponsiveFontSize(double baseFontSize) {
      final width = size.width;
      if (kIsWeb) {
        final scale = (width / 600).clamp(0.8, 1.2);
        return baseFontSize * scale;
      }
      return baseFontSize * (width / 375);
    }

    Widget _buildTitle({required String text, required double baseFontSize}) {
      return Text(
        text,
        style: TextStyle(
          fontSize: _getResponsiveFontSize(baseFontSize),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2E2E3A),
        ),
      );
    }

    Widget _buildDescription({
      required String text,
      required double baseFontSize,
      Color? color,
    }) {
      return Text(
        text,
        style: TextStyle(
          fontSize: _getResponsiveFontSize(baseFontSize),
          color: color ?? Colors.grey[600],
        ),
      );
    }

    if (kIsWeb) {
      // ---------------- WEB ----------------
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height * 0.65,
            child: info.imageWidget,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(text: info.title, baseFontSize: 30),
                  const SizedBox(height: 20),
                  _buildDescription(text: info.description, baseFontSize: 20),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // ---------------- MOBILE ----------------
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: info.imageWidget),
          Positioned(
            top: size.height * 0.62,
            left: size.width * 0.13,
            right: size.width * 0.04,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(text: info.title, baseFontSize: 24),
                SizedBox(height: size.height * 0.015),
                _buildDescription(text: info.description, baseFontSize: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
