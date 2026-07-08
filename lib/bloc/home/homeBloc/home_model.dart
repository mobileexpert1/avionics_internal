import '../../home/manufacturer/manufacturer_list_model.dart';

class HomeResponse {
  final String detail;
  final bool isActiveSubscription;
  final List<ManufacturerListModel> manufacturers;
  final CurrentPlan? currentPlan;
  final UserDetails? userDetails;

  HomeResponse({
    required this.detail,
    required this.isActiveSubscription,
    required this.manufacturers,
    this.currentPlan,
    this.userDetails,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
    detail: json['detail'] ?? '',
    isActiveSubscription: json['is_active_subscription'] ?? false,
    manufacturers: (json['manufacturer'] as List<dynamic>? ?? [])
        .map((e) => ManufacturerListModel.fromJson(e))
        .toList(),
    currentPlan: json['current_plan'] != null
        ? CurrentPlan.fromJson(json['current_plan'])
        : null,
    userDetails: json['user'] != null
        ? UserDetails.fromJson(json['user'])
        : null,
  );
}

class CurrentPlan {
  final String id;
  final String name;
  final double price;
  final String billingCycle;
  final String startDate;
  final String expiryDate;
  final double totalToken;
  final double totalCredit;
  final double tokenUsage;
  final double creditUsage;
  final double creditLimit;
  final double alreadyTotalAddOnToken;
  final double alreadyTotalAddOnCredit;

  CurrentPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.startDate,
    required this.expiryDate,
    required this.totalToken,
    required this.totalCredit,
    required this.tokenUsage,
    required this.creditUsage,
    required this.creditLimit,

    required this.alreadyTotalAddOnToken,
    required this.alreadyTotalAddOnCredit,
  });

  factory CurrentPlan.fromJson(Map<String, dynamic> json) {
    return CurrentPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      billingCycle: json['billing_cycle'] ?? '',
      startDate: (json['start_date']),
      expiryDate: (json['expiry_date']),
      totalToken: (json['total_token'] ?? 0).toDouble(),
      totalCredit: (json['total_credit'] ?? 0).toDouble(),
      tokenUsage: (json['token_usage'] ?? 0).toDouble(),
      creditUsage: (json['credit_usage'] ?? 0).toDouble(),
      creditLimit: json['credit_usage'] ?? '',

      alreadyTotalAddOnToken: (json['total_add_on_token'] ?? 0).toDouble(),
      alreadyTotalAddOnCredit: (json['total_add_on_credit'] ?? 0).toDouble(),
    );
  }
}

class UserDetails {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String userTypeUrl;

  UserDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userTypeUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      userTypeUrl: json['user_type_url'] ?? '',
    );
  }
}
