import '../../Database/db_helper.dart';


class Manufacturer implements BaseModel {
  final String id;
  final String companyName;
  final String? icon;

  Manufacturer({
    required this.id,
    required this.companyName,
    this.icon,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) => Manufacturer(
    id: json['id'] ?? '',
    companyName: json['company_name'] ?? '',
    icon: json['logo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
    'logo': icon,
  };
  @override
  String get table => 'manufacturers';

  factory Manufacturer.fromMap(Map<String, dynamic> map) => Manufacturer(
    id: map['id'] as String,
    companyName: map['company_name'] as String,
    icon: map['logo'] as String?,
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'company_name': companyName,
    'logo': icon,
  };
}
