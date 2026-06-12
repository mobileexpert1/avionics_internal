class StickerModel {
  final String id;
  final String brand;
  final String model;
  final bool isUnlocked;
  final String? imageUrl;

  const StickerModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.isUnlocked,
    this.imageUrl,
  });

  StickerModel copyWith({
    String? id,
    String? brand,
    String? model,
    bool? isUnlocked,
    String? imageUrl,
  }) {
    return StickerModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}