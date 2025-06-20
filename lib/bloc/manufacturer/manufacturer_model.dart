class Manufacturer {
  final String name;
  final String? icon;

  Manufacturer({
    required this.name,
    this.icon,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      name: json['company_name'] ?? '',
      icon: json['logo'],
    );
  }
}
