import '../../bloc/home/homeBloc/home_model.dart';

class CreditManager {
  static final CreditManager _instance = CreditManager._internal();

  factory CreditManager() => _instance;

  CreditManager._internal();

  double totalCredit = 0;
  double creditUsage = 0;

  double totalToken = 0;
  double tokenUsage = 0;

  DateTime? expiryDate;

  void initialize(CurrentPlan plan) {
    totalCredit = plan.totalCredit + 100;
    creditUsage = plan.creditUsage;

    totalToken = plan.totalToken + 100;
    tokenUsage = plan.tokenUsage;

    expiryDate = plan.expiryDate;
    print(
      "totalCredit-=-=-= $totalCredit,creditUsage-=-=-=- $creditUsage totalToken-=-=-= $totalToken,tokenUsage-=-=-=- $tokenUsage",
    );
  }

  double get remainingToken {
    final value = totalCredit - creditUsage;
    return value < 0 ? 0 : value;
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

  Future<bool> tryUseCredit({
    required double amount,
    required bool isComeFromTabbar,
    required Future<void> Function(String message) onError,
  }) async {
    print("isExpired: $isExpired");
    print("remainingCredit: $remainingCredit");

    if (isExpired) {
      await onError("Plan expired. Please renew subscription.");
      return false;
    }

    if (remainingCredit <= 0) {
      await onError("Credits finished. Please buy subscription.");
      return false;
    }

    if (amount > remainingCredit) {
      await onError(
        "Not enough credits. Used: $creditUsage | Remaining: $remainingCredit | Total: $totalCredit",
      );
      return false;
    }
    print(isComeFromTabbar);
    if (isComeFromTabbar == false) {
      creditUsage += amount;
    }
    print(
      "After Addition Used: $creditUsage | Remaining: $remainingCredit | Total: $totalCredit",
    );
    return true;
  }
}
