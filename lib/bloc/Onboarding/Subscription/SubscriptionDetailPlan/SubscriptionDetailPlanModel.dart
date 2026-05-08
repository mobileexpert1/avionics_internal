class PlanDetailSubscriptionModel {
  final String title;
  final String price;
  final String subtitle;
  final String tag;
  final String buttonText;
  final List<String> features;
  final bool isPremium;
  final bool isCustom;

  PlanDetailSubscriptionModel({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.tag,
    required this.buttonText,
    required this.features,
    this.isPremium = false,
    this.isCustom = false,
  });
}