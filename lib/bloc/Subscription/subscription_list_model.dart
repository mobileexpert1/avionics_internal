import 'package:avionics_internal/bloc/Subscription/subscription_state.dart';

import 'package:avionics_internal/bloc/Subscription/subscription_state.dart';

class SubscriptionItemModel {
  final String id;
  final int duration;
  final bool isYearly;
  final double price;
  final int trial;
  final SubscriptionOption option;

  SubscriptionItemModel({
    required this.id,
    required this.duration,
    required this.isYearly,
    required this.price,
    required this.trial,
  }) : option = isYearly ? SubscriptionOption.oneYear : SubscriptionOption.oneMonth;

  factory SubscriptionItemModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionItemModel(
      id: json['id'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      isYearly: json['is_yearly'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      trial: json['trial'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
      'is_yearly': isYearly,
      'price': price,
      'trial': trial,
    };
  }
}
