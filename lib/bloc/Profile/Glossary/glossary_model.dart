class GlossaryItem {
  final String title;
  final String description;

  GlossaryItem({required this.title, required this.description});

  factory GlossaryItem.fromJson(Map<String, dynamic> json) {
    return GlossaryItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
