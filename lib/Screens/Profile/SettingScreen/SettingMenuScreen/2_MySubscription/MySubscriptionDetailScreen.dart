import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_cubit.dart';
import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/AppColors.dart';
import '../../../../../Constants/ConstantStrings.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../Helpers/AppText.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Profile/MySubscription/my_subscription_model.dart';
import 'SubscriptionPlanCard.dart';

class MySubscriptionDetailScreen extends StatefulWidget {
  final MySubscriptionItem subscriptionItem;

  const MySubscriptionDetailScreen({super.key, required this.subscriptionItem});

  @override
  State<MySubscriptionDetailScreen> createState() =>
      _MySubscriptionDetailState();
}

class _MySubscriptionDetailState extends State<MySubscriptionDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: SubscriptionTexts.billingDetailsTitle,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
          builder: (context, state) {
            if (state.isLoading == true) {
              return const Center(child: CircularProgressIndicator());
            }

            final namePlan = widget.subscriptionItem.plan.name;
            final planPrinceWithSymbol =
                "${widget.subscriptionItem.currencySymbol} ${widget.subscriptionItem.priceInPurchasedCurrency}";
            final isPlanExpired = widget.subscriptionItem.status == "expired";
            final isPlanActive = widget.subscriptionItem.status
                .toUpperCase()
                .replaceAll("_", " ")
                .capitalize();
            final expiryDate =
                "${widget.subscriptionItem.startDateLocal} - ${widget.subscriptionItem.expiryDateLocal}";
            final startDate = widget.subscriptionItem.startDateLocal;
            final transactionId = widget.subscriptionItem.originalTransactionId;

            String planPriceWithSymbol = "";

            if (widget.subscriptionItem.priceInPurchasedCurrency != null &&
                widget.subscriptionItem.priceInPurchasedCurrency
                    .toString()
                    .isNotEmpty) {
              planPriceWithSymbol =
                  "${widget.subscriptionItem.currencySymbol} ${widget.subscriptionItem.priceInPurchasedCurrency}";
            }

            var isPremiumPlan =
                widget.subscriptionItem.plan.name == "Premium Plan";

            final isAddOnPacksModelAvailable =
                widget.subscriptionItem.addOnPacksModel;

            return LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth > 1500
                    ? 1500
                    : constraints.maxWidth;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          SubscriptionPlanCard(
                            isPremiumPlan: isPremiumPlan,
                            isPlanExpired: isPlanExpired,
                            namePlan: namePlan,
                            planPriceWithSymbol: planPriceWithSymbol,
                            expiryDate: expiryDate,
                            isPlanActive: isPlanActive,
                          ),

                          const SizedBox(height: 20),

                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: .05,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Transaction Details",
                                      style: AppTextStyles.bold(16).copyWith(
                                        height: 1.0,
                                        color: AppColors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 15),
                                    buildRow(title: "Plan", value: namePlan),

                                    buildDivider(),

                                    buildRow(
                                      title: "Billing period",
                                      value: "Monthly",
                                    ),

                                    buildDivider(),

                                    buildRow(
                                      title: "Invoice date",
                                      value: startDate,
                                    ),

                                    buildDivider(),

                                    buildRow(
                                      title: "Invoice ID",
                                      value: transactionId,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              if (planPriceWithSymbol != "") ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: .05,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Breakdown",
                                        style: AppTextStyles.bold(16).copyWith(
                                          height: 1.0,
                                          color: AppColors.black,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Total Charged",
                                              style: AppTextStyles.bold(16)
                                                  .copyWith(
                                                    height: 1.0,
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            planPrinceWithSymbol,
                                            style: AppTextStyles.bold(16)
                                                .copyWith(
                                                  height: 1.0,
                                                  color: AppColors.black,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              if (isAddOnPacksModelAvailable.isNotEmpty) ...[
                                const SizedBox(height: 20),

                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(22),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: .10,
                                            ),
                                            blurRadius: 25,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 10),
                                          ),
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: .05,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryDark
                                                      .withValues(alpha: .10),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  Icons.add_card_rounded,
                                                  color: AppColors.primaryDark,
                                                  size: 20,
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              Text(
                                                "Added Extra Packs",
                                                style: AppTextStyles.bold(18)
                                                    .copyWith(
                                                      color: AppColors.black,
                                                    ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 22),

                                          ListView.separated(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                isAddOnPacksModelAvailable
                                                    .length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 16),
                                            itemBuilder: (context, index) {
                                              final addedOnModel =
                                                  isAddOnPacksModelAvailable[index];

                                              final addedNamePlan =
                                                  (addedOnModel.credit) != 0
                                                  ? "Purchased Extra Credits"
                                                  : "Purchased Extra Tokens";

                                              final planPrinceWithSymbol =
                                                  "${addedOnModel.currencySymbol} "
                                                  "${addedOnModel.priceInPurchasedCurrency}";

                                              final purchaseDate = addedOnModel
                                                  .purchaseDateLocal;

                                              return Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xffF8F9FC,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  border: Border.all(
                                                    color: Colors.black
                                                        .withValues(alpha: .05),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: .03,
                                                          ),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 7,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .primaryDark
                                                            .withValues(
                                                              alpha: .08,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        addedNamePlan,
                                                        style:
                                                            AppTextStyles.medium(
                                                              12,
                                                            ).copyWith(
                                                              color: AppColors
                                                                  .primaryDark,
                                                            ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 18),

                                                    buildRow(
                                                      title: "Price",
                                                      value:
                                                          planPrinceWithSymbol,
                                                    ),

                                                    buildDivider(),

                                                    buildRow(
                                                      title: "Invoice date",
                                                      value: purchaseDate,
                                                    ),

                                                    if ((addedOnModel.credit) !=
                                                        0) ...[
                                                      buildDivider(),
                                                      buildRow(
                                                        title: "Credits",
                                                        value:
                                                            "${addedOnModel.credit}",
                                                      ),
                                                    ],

                                                    if ((addedOnModel.token) !=
                                                        0) ...[
                                                      buildDivider(),
                                                      buildRow(
                                                        title: "Tokens",
                                                        value:
                                                            "${addedOnModel.token}",
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildRow({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.regular(
              12,
            ).copyWith(height: 1.0, color: AppColors.greyForTextSubscription),
          ),
        ),

        Text(
          value,
          style: AppTextStyles.bold(
            12,
          ).copyWith(height: 1.0, color: AppColors.black),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(color: AppColors.greyWithBottomLine, height: 0.5),
    );
  }
}
