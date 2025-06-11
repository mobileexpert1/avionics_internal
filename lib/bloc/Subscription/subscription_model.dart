class SubscriptionPlanModel {
  final String id;
  final int duration;
  final bool isYearly;
  final int price;
  final int trial;

  SubscriptionPlanModel({
    required this.id,
    required this.duration,
    required this.isYearly,
    required this.price,
    required this.trial,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'],
      duration: json['duration'],
      isYearly: json['is_yearly'],
      price: json['price'],
      trial: json['trial'],
    );
  }
}
