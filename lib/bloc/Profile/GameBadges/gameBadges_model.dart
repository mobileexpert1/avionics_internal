class BadgeResponse {
  final String? detail;
  final int totalEarnPoint;
  final List<BadgeModel> data;

  BadgeResponse({
    this.detail,
    required this.totalEarnPoint,
    required this.data,
  });

  factory BadgeResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] ?? [];
    return BadgeResponse(
      detail: json['detail'],
      totalEarnPoint: json['total_earn_point'] ?? 0,
      data: list.map((e) => BadgeModel.fromJson(e)).toList(),
    );
  }
}

class BadgeModel {
  final String id;
  final String name;
  final int wins;
  final String icon;
  final bool isEarned;
  final int requireWin;
  final int totalWin;

  BadgeModel({
    required this.id,
    required this.name,
    required this.wins,
    required this.icon,
    required this.isEarned,
    required this.requireWin,
    required this.totalWin,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      wins: json['wins'] ?? 0,
      icon: json['icon'] ?? '',
      isEarned: json['is_earned'] ?? false,
      requireWin: json['require_win'] ?? 0,
      totalWin: json['total_win'] ?? 0,
    );
  }
}
