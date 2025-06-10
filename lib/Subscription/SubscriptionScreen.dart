import 'package:avionics_internal/Home/RootTabbarScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Constants/ConstantStrings.dart';
import '../Constants/constantImages.dart';
import '../CustomFiles/CustomBottomButton.dart';
import '../Home/HomeScreen.dart';
import '../bloc/Subscription/subscription_cubit.dart';
import '../bloc/Subscription/subscription_state.dart';
import 'SubscriptionOptionCard.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(ConstantStrings.startSubscription),
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
                      height: 25,
                      width: 25,
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
                      height: 25,
                      width: 25,
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
                      height: 25,
                      width: 25,
                    ),
                    text: SubscriptionTexts.featureTrackAircrafts,
                  ),

                  const SizedBox(height: 20),

                  /// Subscription Options
                  SubscriptionOptionCard(
                    context: context,
                    option: SubscriptionOption.oneYear,
                    title: SubscriptionTexts.oneYearTitle,
                    subtitle: SubscriptionTexts.sevenDaysTrialSubtitle,
                    price: SubscriptionTexts.oneYearPrice,
                    isSelected: selectedOption == SubscriptionOption.oneYear,
                  ),
                  const SizedBox(height: 15),
                  SubscriptionOptionCard(
                    context: context,
                    option: SubscriptionOption.oneMonth,
                    title: SubscriptionTexts.oneMonthTitle,
                    subtitle: SubscriptionTexts.sevenDaysTrialSubtitle,
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
                          MaterialPageRoute(
                            builder: (context) => RootTabbarscreen(),
                          ),
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
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
