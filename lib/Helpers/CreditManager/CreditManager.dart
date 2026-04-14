import 'package:avionics_internal/bloc/home/homeBloc/home_model.dart';

class CreditManager {
  static final CreditManager _instance = CreditManager._internal();

  factory CreditManager() => _instance;

  CreditManager._internal();

  double totalCredit = 0;
  double creditUsage = 0;
  DateTime? expiryDate;

  void initialize(CurrentPlan plan) {
    totalCredit = plan.totalCredit;
    creditUsage = plan.creditUsage;
    expiryDate = plan.expiryDate;
  }

  double get remainingCredit {
    final value = totalCredit - creditUsage;
    return value < 0 ? 0 : value;
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isCreditFinished => remainingCredit <= 0;

  bool tryUseCredit({
    required double amount,
    required Function(String message) onError,
  }) {
    if (isExpired) {
      onError("Plan expired. Please renew subscription.");
      return false;
    }

    if (remainingCredit <= 0) {
      onError("Credits finished. Please buy subscription.");
      return false;
    }

    if (amount > remainingCredit) {
      onError("Not enough credits.");
      return false;
    }

    creditUsage += amount;
    return true;
  }
}
