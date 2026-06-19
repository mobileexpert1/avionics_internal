import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/AppColors.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final bool isPremiumPlan;
  final bool isPlanExpired;

  final String namePlan;
  final String planPriceWithSymbol;
  final String expiryDate;
  final String isPlanActive;
  final bool showActions;
  final int isCreditCount;
  final int isTokenCount;

  final VoidCallback? onModifyTap;
  final VoidCallback? onAddOnTap;
  final VoidCallback? onViewCreditsTokensTap;
  final VoidCallback? onCancelTap;

  const SubscriptionPlanCard({
    super.key,
    required this.isPremiumPlan,
    required this.isPlanExpired,

    required this.isCreditCount,
    required this.isTokenCount,

    required this.namePlan,
    required this.planPriceWithSymbol,
    required this.expiryDate,
    required this.isPlanActive,
    this.showActions = false,
    this.onModifyTap,
    this.onAddOnTap,
    this.onViewCreditsTokensTap,
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
                        : AppColors.greenColourForPlan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.white,
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
                      style: AppTextStyles.medium(12).copyWith(
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

          const SizedBox(height: 10),
          if (showActions) ...[
            GestureDetector(
              onTap: onViewCreditsTokensTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(showActions ? 10 : 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColors.greenColourForPlan,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.viewCreditsToken),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Check your available balance",
                          style: AppTextStyles.medium(12).copyWith(
                            height: 1.0,
                            color: AppColors.greyForTextSubscription,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "View Credits & Tokens",
                          style: AppTextStyles.semiBold(
                            16,
                          ).copyWith(height: 1.0, color: AppColors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            if (isCreditCount != 0 || isCreditCount != 0) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(showActions ? 10 : 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColors.extraDarkYellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        size: 20,
                        Icons.add,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add-ons",
                          style: AppTextStyles.semiBold(
                            16,
                          ).copyWith(height: 1.0, color: AppColors.black),
                        ),

                        const SizedBox(height: 8),
                        if (isCreditCount != 0)
                          Text(
                            "Credit Pack × $isCreditCount",
                            style: AppTextStyles.medium(12).copyWith(
                              height: 1.0,
                              color: AppColors.grayMedium,
                            ),
                          ),

                        const SizedBox(height: 8),
                        if (isTokenCount != 0)
                          Text(
                            "Token Pack × $isTokenCount",
                            style: AppTextStyles.medium(12).copyWith(
                              height: 1.0,
                              color: AppColors.grayMedium,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],

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

              const SizedBox(height: 10),

              SizedBox(
                width: kIsWeb
                    ? MediaQuery.of(context).size.width * 0.5
                    : double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primaryBlue,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onAddOnTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Buy Add-ons",
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
