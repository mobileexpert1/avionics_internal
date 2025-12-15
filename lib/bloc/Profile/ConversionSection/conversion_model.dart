class ConversionItem {
  final String fromTo;
  final String formula;
  final String example;

  ConversionItem({
    required this.fromTo,
    required this.formula,
    required this.example,
  });

  factory ConversionItem.fromJson(Map<String, dynamic> json) {
    return ConversionItem(
      fromTo: json['from_to'] ?? '',
      formula: json['formula'] ?? '',
      example: json['example'] ?? '',
    );
  }
}

class ConversionCategory {
  final String title;
  final List<ConversionItem> items;

  ConversionCategory({
    required this.title,
    required this.items,
  });

  factory ConversionCategory.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['conversions'] as List<dynamic>? ?? [];
    return ConversionCategory(
      title: json['name'] ?? '',
      items: itemsJson.map((e) => ConversionItem.fromJson(e)).toList(),
    );
  }
}
