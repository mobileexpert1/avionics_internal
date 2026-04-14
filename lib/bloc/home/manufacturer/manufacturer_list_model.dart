import '../../../Database/db_helper.dart';

class ManufacturerListModel extends BaseModel {
  @override
  final String id;
  @override
  String? userId;
  final String companyName;
  final String? icon;

  ManufacturerListModel({
    required this.id,
    required this.companyName,
    this.icon,
    this.userId,
  });

  factory ManufacturerListModel.fromJson(Map<String, dynamic> json) =>
      ManufacturerListModel(
        id: json['id'] ?? '',
        companyName: json['company_name'] ?? '',
        icon: json['logo'],
        userId: json['user_id'],
      );

  factory ManufacturerListModel.fromMap(Map<String, dynamic> map) =>
      ManufacturerListModel(
        id: map['id'] as String,
        companyName: map['company_name'] as String,
        icon: map['logo'] as String?,
        userId: map['user_id'] as String?,
      );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'company_name': companyName,
    'logo': icon,
    'user_id': userId,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
    'logo': icon,
  };

  @override
  String get table => 'manufacturers';
}
