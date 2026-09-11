import 'package:avionics_internal/bloc/Onboarding/Subscription/SubscriptionPlanList/subscriptionPlanList_model.dart';

class SubscriptionRepository {
  Future<List<SubscriptionPlan>> getPlans(bool isForBasic) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return isForBasic
        ? [
            SubscriptionPlan(
              name: "Basic",
              tag: "Starter",
              features: [
                "Aircraft Encyclopedia",
                "Live Aircraft Tracking",
                "Company Modules",
              ],
              durations: [
                SubscriptionDuration(
                  title: "1 month",
                  totalPrice: 12.99,
                  monthlyPrice: 12.99,
                ),
                SubscriptionDuration(
                  title: "6 months",
                  totalPrice: 71.24,
                  monthlyPrice: 11.99,
                ),
                SubscriptionDuration(
                  title: "1 year",
                  totalPrice: 119.88,
                  monthlyPrice: 9.99,
                ),
              ],
            ),
          ]
        : [
            SubscriptionPlan(
              name: "Premium",
              tag: "Premium",
              features: [
                "Aircraft Encyclopedia",
                "Live Aircraft Tracking",
                "Company Modules",
              ],
              durations: [
                SubscriptionDuration(
                  title: "1 month",
                  totalPrice: 24.99,
                  monthlyPrice: 24.99,
                ),
                SubscriptionDuration(
                  title: "6 months",
                  totalPrice: 137.94,
                  monthlyPrice: 22.99,
                ),
                SubscriptionDuration(
                  title: "1 year",
                  totalPrice: 227.88,
                  monthlyPrice: 18.99,
                ),
              ],
            ),
          ];
  }
}
