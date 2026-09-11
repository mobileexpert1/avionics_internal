import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../../bloc/Onboarding/Subscription/SubscriptionPlanList/subscriptionPlanList_cubit.dart';
import '../../../../../../bloc/Onboarding/Subscription/SubscriptionPlanList/subscriptionPlanList_state.dart';

class AllSubPlanListPopup extends StatelessWidget {
  final VoidCallback onContinueButton;

  const AllSubPlanListPopup({super.key, required this.onContinueButton});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoading) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SubscriptionError) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            color: Colors.white,
            child: Center(
              child: Text(state.message, textAlign: TextAlign.center),
            ),
          );
        }

        if (state is! SubscriptionLoaded) {
          return const SizedBox.shrink();
        }

        if (state.plans.isEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            color: Colors.white,
            child: const Center(child: Text('No subscription plans available')),
          );
        }

        final plan = state.plans.first;
        final durations = plan.durations;

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: AppColors.primaryDark,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              plan.name,
                              style: AppTextStyles.bold(
                                22,
                              ).copyWith(color: Colors.white),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Container(height: 5, color: AppColors.extraDarkYellow),
                      ],
                    ),
                  ),

                  // =========================================================
                  // TITLE
                  // =========================================================
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 15,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose a Subscription Plan',
                        style: AppTextStyles.semiBold(18),
                      ),
                    ),
                  ),

                  // =========================================================
                  // PLAN LIST
                  // =========================================================
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: durations.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final duration = durations[index];

                        final isSelected = state.selectedIndex == index;

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            context.read<SubscriptionCubit>().selectDuration(
                              index,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black.withValues(alpha: 0.15),
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // =================================================
                                // CUSTOM RADIO
                                // =================================================
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : AppColors.grayMedium,
                                      width: 1,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 10),

                                // =================================================
                                // PLAN DETAILS
                                // =================================================
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              duration.title,
                                              style: AppTextStyles.semiBold(16),
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          Text(
                                            '\$${duration.totalPrice.toStringAsFixed(2)}',
                                            style: AppTextStyles.bold(16),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        '\$${duration.monthlyPrice.toStringAsFixed(2)} per month',
                                        style: AppTextStyles.regular(
                                          14,
                                        ).copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // =========================================================
                  // CONTINUE BUTTON
                  // =========================================================
                  if (durations.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: CustomBottomButton(
                        fontStyle: AppTextStyles.semiBold(
                          18,
                        ).copyWith(color: Colors.white),
                        backgroundColor: AppColors.primaryDark,
                        textColor: Colors.white,
                        title: 'Continue',
                        isEnabled: state.selectedIndex != -1,
                        icon: const SizedBox(),
                        onPressed: () {
                          if (state.selectedIndex < 0 ||
                              state.selectedIndex >= durations.length) {
                            return;
                          }

                          final selectedDuration =
                              durations[state.selectedIndex];

                          debugPrint(
                            'Selected Plan: ${selectedDuration.title}',
                          );

                          debugPrint(
                            'Total Price: ${selectedDuration.totalPrice}',
                          );

                          debugPrint(
                            'Monthly Price: ${selectedDuration.monthlyPrice}',
                          );

                          Navigator.pop(context, true);
                          onContinueButton.call();
                        },
                      ),
                    ),
                ],
              ),

              // =============================================================
              // LOADING OVERLAY
              // =============================================================
              if (state is SubscriptionLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
