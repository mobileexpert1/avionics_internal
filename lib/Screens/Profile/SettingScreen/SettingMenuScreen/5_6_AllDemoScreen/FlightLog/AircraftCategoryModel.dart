import 'dart:ui';

class AircraftCategoryModel {
  final String id;
  final String letter;
  final String title;
  final String image;
  final Color color;
  final int unlockedCount;
  final int totalCount;

  const AircraftCategoryModel({
    required this.id,
    required this.letter,
    required this.title,
    required this.image,
    required this.color,
    required this.unlockedCount,
    required this.totalCount,
  });

  double get progress =>
      totalCount == 0 ? 0 : unlockedCount / totalCount;

  AircraftCategoryModel copyWith({
    String? id,
    String? letter,
    String? title,
    String? image,
    Color? color,
    int? unlockedCount,
    int? totalCount,
  }) {
    return AircraftCategoryModel(
      id: id ?? this.id,
      letter: letter ?? this.letter,
      title: title ?? this.title,
      image: image ?? this.image,
      color: color ?? this.color,
      unlockedCount: unlockedCount ?? this.unlockedCount,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}