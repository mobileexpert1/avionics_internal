import '../../../Database/db_helper.dart';

class GlossaryItem extends BaseModel {
  @override
  final String id;
  @override
  String? userId;

  final String title;
  final String description;

  GlossaryItem({
    required this.id,
    required this.title,
    required this.description,
    this.userId,
  });

  factory GlossaryItem.fromJson(Map<String, dynamic> json) {
    final String t = json['title'] ?? '';
    return GlossaryItem(
      id   : t.trim().toLowerCase().replaceAll(' ', '_'),
      title: t,
      description: json['description'] ?? '',
      userId: json['user_id'],
    );
  }

  factory GlossaryItem.fromMap(Map<String, dynamic> map) => GlossaryItem(
    id  : map['id'],
    title: map['title'],
    description: map['description'],
    userId: map['user_id'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'id'        : id,
    'title'     : title,
    'description': description,
    'user_id'   : userId,
  };

  @override
  String get table => 'glossary';
}
