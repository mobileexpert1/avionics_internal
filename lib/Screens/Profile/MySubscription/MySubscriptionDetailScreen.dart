import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppText.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_cubit.dart';
import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_state.dart';
import '../../../bloc/Profile/MySubscription/my_subscription_model.dart';
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
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
                "${widget.subscriptionItem.startDate} - ${widget.subscriptionItem.expiryDate} UTC";

            final startDate = "${widget.subscriptionItem.startDate} UTC";

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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),
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
                              color: Colors.black.withValues(alpha: .05),
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
                              style: AppTextStyles.bold(
                                16,
                              ).copyWith(height: 1.0, color: AppColors.black),
                            ),

                            const SizedBox(height: 15),
                            buildRow(title: "Plan", value: namePlan),

                            buildDivider(),

                            buildRow(title: "Billing period", value: "Monthly"),

                            buildDivider(),

                            buildRow(title: "Invoice date", value: startDate),

                            buildDivider(),

                            buildRow(title: "Invoice ID", value: transactionId),
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
                                color: Colors.black.withValues(alpha: .05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Breakdown",
                                style: AppTextStyles.bold(
                                  16,
                                ).copyWith(height: 1.0, color: AppColors.black),
                              ),

                              const SizedBox(height: 20),

                              // buildRow(title: "Subtotal", value: "\$13.00"),
                              //
                              // buildDivider(),
                              //
                              // buildRow(title: "Tax", value: "\$2.01"),
                              //
                              // buildDivider(),

                              /// TOTAL
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Total Charged",
                                      style: AppTextStyles.bold(16).copyWith(
                                        height: 1.0,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    planPrinceWithSymbol,
                                    style: AppTextStyles.bold(16).copyWith(
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
                    ],
                  ),
                ],
              ),
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
