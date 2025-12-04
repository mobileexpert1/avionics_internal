import 'package:flutter/cupertino.dart';

class OnboardingInfo {
  final String title;
  final String description;
  final Widget imageWidget;
  final String? videoUrl;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.imageWidget,
    this.videoUrl,
  });
}
