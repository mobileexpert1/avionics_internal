import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';
import '../../../../bloc/Subscription/iosFolder/AppleSubscriptionCubit.dart';
import '../../../../bloc/Subscription/iosFolder/AppleSubscriptionState.dart';
import '../../../Home/RootTabbar/RootTabbarScreen.dart';

class AppleSubscriptionScreen extends StatelessWidget {
  const AppleSubscriptionScreen({super.key});

  String getTrialText(String description) {
    if (description.toLowerCase().contains('7 days'))
      return "+ 7 days free trial";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppleSubscriptionCubit(),
      child: BlocConsumer<AppleSubscriptionCubit, AppleSubscriptionState>(
        listenWhen: (prev, curr) =>
            prev.error != curr.error && curr.error != null,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }

          if (state.purchased) {
            AppSnackBar.custom(
              context,
              message: "Purchase Successfully",
              svgAsset: CommonUi.setSvgImage(AssetsPath.signinIcon),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => RootTabbarscreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final selectedProduct = state.selectedProduct;
          final products = state.products;

          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: const SizedBox(),
                  title: const Text(ConstantStrings.startSubscription),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  surfaceTintColor: Colors.white,
                  shape: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.logoMain),
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 30),

                        // Features
                        _buildFeatureRow(
                          iconWidget: SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.starIcon),
                            height: 25,
                            width: 25,
                          ),
                          text: "Save your Favorites Aircrafts",
                        ),
                        const Divider(color: Color(0xFFF6F6F6), height: 3),
                        _buildFeatureRow(
                          iconWidget: SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.trackIcon),
                            height: 25,
                            width: 25,
                          ),
                          text: "Compare planes",
                        ),
                        const Divider(color: Color(0xFFF6F6F6), height: 3),
                        _buildFeatureRow(
                          iconWidget: SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.trackIcon),
                            height: 25,
                            width: 25,
                          ),
                          text: "Track the aircrafts",
                        ),
                        const SizedBox(height: 20),

                        // Subscription Cards
                        ...products.map(
                          (product) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _SubscriptionCard(
                              product: product,
                              isSelected: product == selectedProduct,
                              trialText: getTrialText(product.description),
                              onTap: () => context
                                  .read<AppleSubscriptionCubit>()
                                  .selectPlan(product),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Go Premium Button
                        CustomBottomButton(
                          backgroundColor: const Color(0xFF3F3D51),
                          textColor: Colors.white,
                          title: "Go Premium",
                          icon: const SizedBox(),
                          isEnabled: selectedProduct != null,
                          onPressed: () async {
                            if (selectedProduct != null) {
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => RootTabbarscreen(),
                              //   ),
                              //   (route) => false,
                              // );

                              context
                                  .read<AppleSubscriptionCubit>()
                                  .buySelected(context);
                            }
                          },
                        ),

                        const SizedBox(height: 20),

                        if (selectedProduct != null)
                          Text(
                            "Free for 7 days then ${selectedProduct.price}.\nCancel anytime.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF626262),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),

              if (state.loading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
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
              style: const TextStyle(color: Color(0xFF626262), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final ProductDetails product;
  final bool isSelected;
  final String trialText;
  final VoidCallback onTap;

  const _SubscriptionCard({
    required this.product,
    required this.isSelected,
    required this.trialText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (trialText.isNotEmpty)
                  Text(
                    trialText,
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                  ),
              ],
            ),

            // Right side
            Row(
              children: [
                Text(
                  product.price,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                ),
                const SizedBox(width: 10),
                if (isSelected)
                  SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.tickIcon),
                    fit: BoxFit.fill,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
