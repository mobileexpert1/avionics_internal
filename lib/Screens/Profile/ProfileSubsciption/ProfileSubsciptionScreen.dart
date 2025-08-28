import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is! SubscriptionInitial) return SizedBox.shrink();
            final selectedOption = state.selectedId;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(SubscriptionTexts.currentPlanTitle),
                        ),
                      ],
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

                    /// Go Premium Button
                    CustomBottomButton(
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      title: SubscriptionTexts.changeSubPlanTitle,
                      icon: Wrap(),
                      isEnabled: state is SubscriptionInitial,
                      // Enable only when state is valid
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

                    CustomBottomButton(
                      backgroundColor: const Color.fromRGBO(30, 128, 242, 1.0),
                      textColor: Colors.white,
                      title: SubscriptionTexts.restoreSubTitle,
                      icon: Wrap(),
                      isEnabled: state is SubscriptionInitial,
                      onPressed: () {
                        if (state is SubscriptionInitial) {
                          final selected = state.selectedId;
                          print('Go Premium clicked with option: $selected');
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
