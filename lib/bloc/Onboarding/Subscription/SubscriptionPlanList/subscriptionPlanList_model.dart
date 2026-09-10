class SubscriptionDuration {
  final String title;
  final double totalPrice;
  final double monthlyPrice;

  SubscriptionDuration({
    required this.title,
    required this.totalPrice,
    required this.monthlyPrice,
  });
}

class SubscriptionPlan {
  final String name;
  final String tag;
  final List<String> features;
  final List<SubscriptionDuration> durations;

  SubscriptionPlan({
    required this.name,
    required this.tag,
    required this.features,
    required this.durations,
  });
}