import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../Constants/AppColors.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Profile/MySubscription/my_subscription_model.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final bool isPremiumPlan;
  final bool isPlanExpired;

  final String namePlan;
  final String planPriceWithSymbol;
  final String expiryDate;
  final String isPlanActive;
  final bool showActions;
  final MySubscriptionItem? currentPlan;

  final VoidCallback? onModifyTap;
  final VoidCallback? onAddOnTap;
  final VoidCallback? onViewCreditsTokensTap;
  final VoidCallback? onCancelTap;

  const SubscriptionPlanCard({
    super.key,
    required this.isPremiumPlan,
    required this.isPlanExpired,

    required this.namePlan,
    required this.planPriceWithSymbol,
    required this.expiryDate,
    required this.isPlanActive,

    this.currentPlan,

    this.showActions = false,
    this.onModifyTap,
    this.onAddOnTap,
    this.onViewCreditsTokensTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPrice = planPriceWithSymbol.trim().isNotEmpty;

    final addOns = currentPlan?.addOnPacksModel ?? [];

    final creditCounts = getCreditPackageCount(addOns);
    final tokenCounts = getTokenPackageCount(addOns);

    final addOnItems = <String>[
      if (creditCounts.small > 0) '10,000 × ${creditCounts.small} Light (L)',
      if (creditCounts.medium > 0) '25,000 × ${creditCounts.medium} Medium (M)',
      if (creditCounts.large > 0) '50,000 × ${creditCounts.large} Heavy (H)',

      if (tokenCounts.small > 0) '100,000 × ${tokenCounts.small} Light (L)',
      if (tokenCounts.medium > 0) '300,000 × ${tokenCounts.medium} Medium (M)',
      if (tokenCounts.large > 0) '600,000 × ${tokenCounts.large} Heavy (H)',
    ];

    final creditItems = <String>[
      if (creditCounts.small > 0) '10,000 × ${creditCounts.small} Light (L)',
      if (creditCounts.medium > 0) '25,000 × ${creditCounts.medium} Medium (M)',
      if (creditCounts.large > 0) '50,000 × ${creditCounts.large} Heavy (H)',
    ];

    final tokenItems = <String>[
      if (tokenCounts.small > 0) '100,000 × ${tokenCounts.small} Light (L)',
      if (tokenCounts.medium > 0) '300,000 × ${tokenCounts.medium} Medium (M)',
      if (tokenCounts.large > 0) '600,000 × ${tokenCounts.large} Heavy (H)',
    ];

    //final hasAddOns = addOnItems.isNotEmpty;

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
                      namePlan.replaceAll("(avioflai)", ""),
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
                                : AppColors.black,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "$planPriceWithSymbol/ month",
                            style: AppTextStyles.regular(14).copyWith(
                              height: 1.0,
                              color: isPremiumPlan
                                  ? AppColors.greyWithBottomLine
                                  : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (showActions) ...[
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Next Billing Date on ',
                                    style: AppTextStyles.regular(14).copyWith(
                                      height: 1.0,
                                      color: AppColors.grayMedium,
                                    ),
                                  ),
                                  TextSpan(
                                    text: expiryDate,
                                    style: AppTextStyles.regular(14).copyWith(
                                      height: 1.0,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Padding(
                    //   padding:
                    //   const EdgeInsets.symmetric(
                    //     horizontal: 20,
                    //   ),
                    //   child:
                    //)
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

          const SizedBox(height: 10),

          if (showActions) ...[
            SizedBox(
              width: double.infinity,
              child: Divider(thickness: 1.2, color: AppColors.grayLight),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: onViewCreditsTokensTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Available Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey.shade600),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (addOnItems.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildBalanceRow('Credits', creditItems),

                          const SizedBox(height: 10),

                          _buildBalanceRow('Tokens', tokenItems),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Your available Credits and AI Tokens are valid until your subscription expires.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // BILLING DATE CARD
          if (!showActions) ...[
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
                            ? "Last Billing Details"
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
          ],

          if (showActions) ...[
            // GestureDetector(
            //   onTap: onViewCreditsTokensTap,
            //   child: Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(showActions ? 10 : 15),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           height: 35,
            //           width: 35,
            //           decoration: BoxDecoration(
            //             color: AppColors.greenColourForPlan,
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: Padding(
            //             padding: EdgeInsets.all(6),
            //             child: SvgPicture.asset(
            //               CommonUi.setSvgImage(AssetsPath.viewCreditsToken),
            //               fit: BoxFit.contain,
            //             ),
            //           ),
            //         ),
            //
            //         const SizedBox(width: 12),
            //
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "Check your available balance",
            //               style: AppTextStyles.medium(12).copyWith(
            //                 height: 1.0,
            //                 color: AppColors.greyForTextSubscription,
            //               ),
            //             ),
            //
            //             const SizedBox(height: 8),
            //
            //             Text(
            //               "View Credits & Tokens",
            //               style: AppTextStyles.semiBold(
            //                 16,
            //               ).copyWith(height: 1.0, color: AppColors.black),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 10),
            // if (hasAddOns) ...[
            //   Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(showActions ? 10 : 15),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           height: 35,
            //           width: 35,
            //           decoration: BoxDecoration(
            //             color: AppColors.extraDarkYellow,
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: const Icon(
            //             Icons.add,
            //             size: 20,
            //             color: AppColors.black,
            //           ),
            //         ),
            //
            //         const SizedBox(width: 12),
            //
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "Add-ons",
            //                 style: AppTextStyles.semiBold(
            //                   16,
            //                 ).copyWith(height: 1.0, color: AppColors.black),
            //               ),
            //
            //               const SizedBox(height: 8),
            //               ...addOnItems.map(
            //                 (item) => Padding(
            //                   padding: const EdgeInsets.only(bottom: 8),
            //                   child: Text(
            //                     item,
            //                     style: AppTextStyles.medium(12).copyWith(
            //                       height: 1.0,
            //                       color: AppColors.grayMedium,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],
          ],

          /// ACTIONS
          if (showActions) ...[
            if (!isPlanExpired) ...[
              const SizedBox(height: 20),

              SizedBox(
                width: kIsWeb
                    ? MediaQuery.of(context).size.width * 0.45
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
                    ? MediaQuery.of(context).size.width * 0.45
                    : double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: (isPremiumPlan
                        ? AppColors.white
                        : AppColors.primaryBlue),

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

  Widget _buildBalanceRow(String title, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: items.isEmpty
                ? [
                    const Text(
                      '-',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]
                : items.map((e) => _buildPackText(e)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPackText(String value) {
    final match = RegExp(
      r'^(\d{1,3}(?:,\d{3})*\s×\s\d+)\s(.*)$',
    ).firstMatch(value);

    if (match == null) {
      return Text(value);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        textAlign: TextAlign.right,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${match.group(1)} ',
              style: AppTextStyles.medium(
                14,
              ).copyWith(height: 1.3, color: AppColors.black),
            ),
            TextSpan(
              text: match.group(2),
              style: AppTextStyles.regular(
                14,
              ).copyWith(height: 1.3, color: AppColors.grayMedium),
            ),
          ],
        ),
      ),
    );
  }
}
