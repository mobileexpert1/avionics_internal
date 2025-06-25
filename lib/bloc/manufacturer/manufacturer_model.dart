class Manufacturer {
  final String id;
  final String companyName;
  final String? icon;

  Manufacturer({
    required this.id,
    required this.companyName,
    this.icon,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'] ?? '',
      companyName: json['company_name'] ?? '',
      icon: json['logo'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_name': companyName,
      'logo': icon,
    };
  }
}