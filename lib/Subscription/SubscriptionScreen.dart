import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../Constants/OnboardingTexts.dart';
import '../Constants/constantImages.dart';
import '../bloc/Subscription/subscription_cubit.dart';
import '../bloc/Subscription/subscription_state.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SubscriptionOption? selectedOption;
          if (state is SubscriptionInitial) {
            selectedOption = state.selectedOption;
          }

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
                _buildFeatureRow(
                  icon: Icons.star,
                  text: 'Save your Favorites Aircrafts',
                ),
                const Divider(color: Colors.white30, height: 1), // Adjust color and thickness as needed
                const SizedBox(height: 8),
                _buildFeatureRow(
                  icon: Icons.compare_arrows,
                  text: 'Compare planes',
                ),
                const Divider(color: Colors.white30, height: 1), // Adjust color and thickness as needed
                const SizedBox(height: 8),
                _buildFeatureRow(
                  icon: Icons.track_changes,
                  // Changed from refresh as it looks more like tracking
                  text: 'Track the aircrafts',
                ),
                const Divider(color: Colors.white30, height: 1), // Adjust color and thickness as needed
                const SizedBox(height: 8),
                const SizedBox(height: 30),
                _buildSubscriptionOption(
                  context: context,
                  option: SubscriptionOption.oneYear,
                  title: '1 Year',
                  subtitle: '+ 7 days free trial',
                  price: '80 EURO',
                  isSelected: selectedOption == SubscriptionOption.oneYear,
                ),
                const SizedBox(height: 15),
                _buildSubscriptionOption(
                  context: context,
                  option: SubscriptionOption.oneMonth,
                  title: '1 month',
                  subtitle: '+ 7 days free trial',
                  price: '10 EURO',
                  isSelected: selectedOption == SubscriptionOption.oneMonth,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle "Go Premium" button press
                      // You can access the selected option via context.read<SubscriptionCubit>().state
                      if (state is SubscriptionInitial) {
                        final selected = state.selectedOption;
                        print('Go Premium clicked with option: $selected');
                        // Implement your payment/subscription logic here
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A0DAD),
                      // A purple-like color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Go Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Free for 7 days then 80 EURO per year.\nCancel anytime.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color.fromRGBO(98, 98, 98, 1.0), fontSize: 18),
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
      onTap: () {
        context.read<SubscriptionCubit>().selectOption(option);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C42), // Darker background for options
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: 2,
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
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
