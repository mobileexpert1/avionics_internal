import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/OnboardingTexts.dart';
import '../Constants/constantImages.dart';
import '../CustomFiles/CustomBottomButton.dart';
import '../Onboarding/HomeScreen.dart';
import '../bloc/Subscription/subscription_cubit.dart';
import '../bloc/Subscription/subscription_state.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(OnboardingTexts.startSubscription),
          backgroundColor: Colors.white,
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shape: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            final selectedOption = state is SubscriptionInitial
                ? state.selectedOption
                : SubscriptionOption.oneYear;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.logoMain),
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 30),

                  /// Features
                  _buildFeatureRow(
                    iconWidget: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.starIcon),
                      height: 28,
                      width: 28,
                    ),
                    text: SubscriptionTexts.featureSaveFavorites,
                  ),
                  const Divider(
                    color: Color.fromRGBO(246, 246, 246, 1.0),
                    height: 3,
                  ),
                  _buildFeatureRow(
                    iconWidget: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.trackIcon),
                      height: 28,
                      width: 28,
                    ),
                    text: SubscriptionTexts.featureComparePlanes,
                  ),

                  const Divider(
                    color: Color.fromRGBO(246, 246, 246, 1.0),
                    height: 3,
                  ),

                  _buildFeatureRow(
                    iconWidget: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.trackIcon),
                      height: 28,
                      width: 28,
                    ),
                    text: SubscriptionTexts.featureTrackAircrafts,
                  ),

                  const SizedBox(height: 30),

                  /// Subscription Options
                  _buildSubscriptionOption(
                    context: context,
                    option: SubscriptionOption.oneYear,
                    title: SubscriptionTexts.oneYearTitle,
                    subtitle: SubscriptionTexts.oneYearSubtitle,
                    price: SubscriptionTexts.oneYearPrice,
                    isSelected: selectedOption == SubscriptionOption.oneYear,
                  ),
                  const SizedBox(height: 15),
                  _buildSubscriptionOption(
                    context: context,
                    option: SubscriptionOption.oneMonth,
                    title: SubscriptionTexts.oneMonthTitle,
                    subtitle: SubscriptionTexts.oneMonthSubtitle,
                    price: SubscriptionTexts.oneMonthPrice,
                    isSelected: selectedOption == SubscriptionOption.oneMonth,
                  ),
                  const SizedBox(height: 40),

                  /// Go Premium Button
                  CustomBottomButton(
                    backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                    textColor: Colors.white,
                    title: SubscriptionTexts.goPremiumTitle,
                    icon: Wrap(),
                    isEnabled: state is SubscriptionInitial,
                    // Enable only when state is valid
                    onPressed: () {
                      if (state is SubscriptionInitial) {
                        final selected = state.selectedOption;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                        print('Go Premium clicked with option: $selected');
                        // Add your navigation or subscription logic here
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    SubscriptionTexts.trialMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(98, 98, 98, 1.0),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureRow({required Widget iconWidget, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color.fromRGBO(98, 98, 98, 1.0),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption({
    required BuildContext context,
    required SubscriptionOption option,
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => context.read<SubscriptionCubit>().selectOption(option),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_off,
                  color: isSelected ? Colors.blueAccent : Colors.grey,
                  size: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
