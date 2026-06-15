import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../Constants/AppColors.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final bool isPremiumPlan;
  final bool isPlanExpired;

  final String namePlan;
  final String planPriceWithSymbol;
  final String expiryDate;
  final String isPlanActive;
  final bool showActions;

  final VoidCallback? onModifyTap;
  final VoidCallback? onCancelTap;

  const SubscriptionPlanCard({
    super.key,
    required this.isPremiumPlan,
    required this.isPlanExpired,
    required this.namePlan,
    required this.planPriceWithSymbol,
    required this.expiryDate,
    required this.isPlanActive,
    this.showActions = false,
    this.onModifyTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPrice = planPriceWithSymbol.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPremiumPlan
            ? AppColors.primaryBlue
            : AppColors.grayForFeedbackAndText,
        borderRadius: BorderRadius.circular(showActions ? 20 : 15),
      ),
      child: Column(
        children: [
          /// TOP SECTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namePlan,
                      style: AppTextStyles.semiBold(26).copyWith(
                        height: 1.0,
                        color: isPremiumPlan
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),

                    if (hasPrice) ...[
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: isPremiumPlan
                                ? AppColors.greyWithBottomLine
                                : AppColors.greyForTextSubscription,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            planPriceWithSymbol,
                            style: AppTextStyles.regular(14).copyWith(
                              height: 1.0,
                              color: isPremiumPlan
                                  ? AppColors.greyWithBottomLine
                                  : AppColors.greyForTextSubscription,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              /// STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isPlanExpired
                        ? Colors.red
                        : (isPremiumPlan
                              ? AppColors.white
                              : AppColors.greenColourForPlan),
                  ),
                ),
                child: Text(
                  isPlanActive,
                  style: AppTextStyles.medium(14).copyWith(
                    height: 1.0,
                    color: isPlanExpired
                        ? Colors.red
                        : (isPremiumPlan
                              ? AppColors.white
                              : AppColors.greenColourForPlan),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// BILLING DATE CARD
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(showActions ? 10 : 15),
            decoration: BoxDecoration(
              color: isPremiumPlan
                  ? AppColors.blueColorForSubsBackgroundColour
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: isPremiumPlan
                        ? AppColors.primaryBlue
                        : AppColors.greenColourForCalender,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.greenColourForPlan,
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showActions
                          ? (isPlanExpired == true
                                ? "Last Billing Details"
                                : "Next Billing Date")
                          : "Last Billing Date",
                      style: AppTextStyles.medium(13).copyWith(
                        height: 1.0,
                        color: isPremiumPlan
                            ? AppColors.greyWithBottomLine
                            : AppColors.greyForTextSubscription,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      expiryDate,
                      style: AppTextStyles.semiBold(showActions ? 16 : 11)
                          .copyWith(
                            height: 1.0,
                            color: isPremiumPlan
                                ? AppColors.white
                                : AppColors.black,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ACTIONS
          if (showActions) ...[
            if (!isPlanExpired) ...[
              const SizedBox(height: 20),

              SizedBox(
                width: kIsWeb
                    ? MediaQuery.of(context).size.width * 0.5
                    : double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isPlanExpired
                        ? (isPremiumPlan
                              ? AppColors.white
                              : AppColors.primaryBlue)
                        : (isPremiumPlan
                              ? AppColors.white
                              : AppColors.greenColourForPlan),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onModifyTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isPlanExpired ? "Renew" : "Modify Plan",
                        style: AppTextStyles.semiBold(18).copyWith(
                          height: 1.0,
                          color: isPremiumPlan
                              ? AppColors.black
                              : AppColors.white,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Icon(
                        Icons.open_in_new,
                        color: isPremiumPlan
                            ? AppColors.black
                            : AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            GestureDetector(
              onTap: onCancelTap,
              child: Text(
                isPlanExpired ? "Review" : "Cancel Subscription",
                style: AppTextStyles.regular(16).copyWith(
                  height: 1.0,
                  color: isPlanExpired
                      ? (isPremiumPlan
                            ? AppColors.white
                            : AppColors.primaryBlue)
                      : isPremiumPlan
                      ? AppColors.dividerLineColourForComparison
                      : AppColors.grayMedium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
