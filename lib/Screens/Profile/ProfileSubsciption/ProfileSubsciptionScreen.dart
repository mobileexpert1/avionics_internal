import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Onboarding/Subscription/subscription_cubit.dart';
import '../../../bloc/Onboarding/Subscription/subscription_state.dart';
import '../../Onboarding/Subscription/SubscriptionOptionCard.dart';

class ProfileSubscriptionScreen extends StatelessWidget {
  const ProfileSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: SubscriptionTexts.currentSubTitle,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: kIsWeb ? 1500 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                builder: (context, state) {
                  if (state is! SubscriptionInitial) {
                    return const SizedBox.shrink();
                  }

                  final selectedOption = state.selectedId;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            SubscriptionTexts.currentPlanTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...state.subscriptionList.map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: SubscriptionOptionCard(
                              item: item,
                              isSelected: selectedOption == item.id,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// Change Subscription Plan Button
                        CustomBottomButton(
                          fontStyle: AppTextStyles.regular(21.46).copyWith(
                            height: 1.0,
                            color: state is SubscriptionInitial
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                          backgroundColor: const Color.fromRGBO(
                            63,
                            61,
                            81,
                            1.0,
                          ),
                          textColor: Colors.white,
                          title: SubscriptionTexts.changeSubPlanTitle,
                          icon: const SizedBox(),
                          isEnabled: state is SubscriptionInitial,
                          onPressed: () {
                            if (state is SubscriptionInitial) {
                              final selected = context
                                  .read<SubscriptionCubit>()
                                  .selectedItem;
                              if (selected != null) {
                                print({
                                  "duration": selected.duration,
                                  "is_yearly": selected.isYearly,
                                  "price": selected.price,
                                  "trial": selected.trial,
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        /// Restore Subscription Button
                        CustomBottomButton(
                          fontStyle: AppTextStyles.regular(21.46).copyWith(
                            height: 1.0,
                            color: state is SubscriptionInitial
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),

                          backgroundColor: const Color.fromRGBO(
                            30,
                            128,
                            242,
                            1.0,
                          ),
                          textColor: Colors.white,
                          title: SubscriptionTexts.restoreSubTitle,
                          icon: const SizedBox(),
                          isEnabled: state is SubscriptionInitial,
                          onPressed: () {
                            if (state is SubscriptionInitial) {
                              final selected = state.selectedId;
                              print(
                                'Restore Subscription clicked with option: $selected',
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
