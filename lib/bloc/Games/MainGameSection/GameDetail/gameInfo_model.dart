import 'package:flutter/cupertino.dart';

class GameInfo {
  final String title;
  final String description;
  final int questions;
  final String questionType;
  final String moduleType;
  final Widget iconWidget;
  final bool isTopicWise;
  final bool isCalculation;

  const GameInfo({
    required this.title,
    required this.description,
    required this.questions,
    required this.questionType,
    required this.moduleType,
    required this.iconWidget,
    this.isTopicWise = false,
    this.isCalculation = false,
  });
}
