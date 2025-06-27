import '../../../Database/db_helper.dart';

class GlossaryItem extends BaseModel {
  @override
  final String id;
  final String title;
  final String description;

  GlossaryItem({
    required this.id,
    required this.title,
    required this.description,
  });

  factory GlossaryItem.fromJson(Map<String, dynamic> json) {
    final String title = json['title'] ?? '';
    return GlossaryItem(
      id: title.trim().toLowerCase().replaceAll(' ', '_'),
      title: title,
      description: json['description'] ?? '',
    );
  }


  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
  };

  @override
  String get table => 'glossary';
}
