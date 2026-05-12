import '../Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Helpers/CardWithBadgeClipper.dart';
import '../../Home/RootTabbar/RootTabbarScreen.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanCubit.dart';
import '../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanState.dart';

String formatDate(String? dateStr) {
  if (dateStr == null) return "-";

  final utcDate = DateTime.tryParse("${dateStr.replaceFirst(" ", "T")}Z");

  if (utcDate == null) return "-";

  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return "${utcDate.day.toString().padLeft(2, '0')}-"
      "${monthNames[utcDate.month - 1]}-${utcDate.year} "
      "${utcDate.hour.toString().padLeft(2, '0')}:"
      "${utcDate.minute.toString().padLeft(2, '0')}";
}

class SubscriptionPlanDetailScreen extends StatefulWidget {
  final bool? isComeFromSignup;

  const SubscriptionPlanDetailScreen({super.key, this.isComeFromSignup});

  @override
  State<SubscriptionPlanDetailScreen> createState() =>
      _SubscriptionPlanDetailState();
}

class _SubscriptionPlanDetailState extends State<SubscriptionPlanDetailScreen> {
  late SubscriptionBuyPlanCubit _cubit;
  int currentPage = 0;
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _cubit = SubscriptionBuyPlanCubit();
    _cubit.isComeFromSignup = widget.isComeFromSignup ?? false;
    _cubit.initRevenueCat();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.subscriptionScreen,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<SubscriptionBuyPlanCubit, SubscriptionBuyPlanState>(
        listener: (context, state) {
          if (state.error != null) {
            if (state.error!.contains("unauthorized") ||
                state.error!.contains("401")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session expired. Please login again.'),
                ),
              );

              Future.delayed(const Duration(seconds: 1), () {
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              });
            } else if (state.error!.toLowerCase().contains(
              "400 Sorry, we could not find your subscription.".toLowerCase(),
            )) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "We could not find your subscription. Please buy subscription.",
                  ),
                ),
              );
            } else {
              if (state.isBlocked == true) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
                });
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          }
          if (_cubit.isComeFromSignup == true) {
            if (state.purchased &&
                state.waitingForBackendConfirmation != true) {
              Future.delayed(const Duration(seconds: 2), () {
                if (!context.mounted) return;
                AppSnackBar.custom(
                  context,
                  message: (widget.isComeFromSignup == true
                      ? "Purchase Successfully"
                      : "Restore Subscription Successfully"),
                  svgAsset: CommonUi.setSvgImage(AssetsPath.signinIcon),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => RootTabbarscreen()),
                  (route) => false,
                );
              });
            }
          }
        },
        builder: (context, state) {
          final packages = state.offerings?.current?.availablePackages ?? [];
          final isComeFromSignup = _cubit.isComeFromSignup;
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title: isComeFromSignup
                      ? ConstantStrings.startSubscription
                      : SubscriptionTexts.currentPlanTitle,
                  centerTitle: isComeFromSignup ? true : false,
                  leftButton: IconButton(
                    icon: Icon(
                      isComeFromSignup ? Icons.logout : Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isComeFromSignup) {
                        context
                            .read<SubscriptionBuyPlanCubit>()
                            .clearAllDataAndRedirectToSplashScreen(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isComeFromSignup
                                  ? 'Choose Your Plan'
                                  : 'Manage Your Plan',
                              style: AppTextStyles.bold(
                                26,
                              ).copyWith(height: 1.0, color: AppColors.black),
                            ),
                            _stepIndicator(packages.length),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: packages.length,
                          onPageChanged: (index) {
                            setState(() => currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            return _PlanCard(
                              state: state,
                              package: packages[index],
                              isLoading: state.loading,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.loading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── step indicator ───────────────────────────────────────────────────────
  Widget _stepIndicator(int total) {
    return Row(
      children: List.generate(total, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: index == currentPage
                ? const Color(0xFF3D8EFF)
                : const Color(0xFFD0D0DA),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Package package;
  final bool isLoading;
  final SubscriptionBuyPlanState state;

  const _PlanCard({
    required this.state,
    required this.package,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBasicPlan = package.storeProduct.title.toLowerCase().contains(
      "basic",
    );

    final isUpcomingPlan = state.subscription?.upcoming;

    final bool isActive =
        (state.subscription?.data?.productId ==
                package.storeProduct.identifier &&
            state.subscription?.data?.status == "active") ||
        (state.activeProductId == package.storeProduct.identifier &&
            state.purchased);

    final bool isExpired =
        state.subscription?.data?.productId ==
            package.storeProduct.identifier &&
        state.subscription?.data?.status == "expired";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ClipPath(
                    clipper: CardWithBadgeClipper(),
                    child: Container(
                      color: isBasicPlan
                          ? AppColors.grayForFeedbackAndText
                          : AppColors.primaryBlue,
                      padding: const EdgeInsets.fromLTRB(22, 25, 22, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${package.storeProduct.title} ",
                            style: AppTextStyles.semiBold(18).copyWith(
                              height: 1.0,
                              color: isBasicPlan ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            package.storeProduct.priceString,
                            style: AppTextStyles.semiBold(26).copyWith(
                              height: 1.0,
                              color: isBasicPlan ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text(
                            "per user/month",
                            style: AppTextStyles.regular(14).copyWith(
                              height: 1.0,
                              color: isBasicPlan ? Colors.grey : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),

                          Expanded(
                            child: ListView.builder(
                              itemCount: state.features.length,
                              itemBuilder: (_, i) => _FeatureRow(
                                text: state.features[i],
                                isPremium: isBasicPlan,
                              ),
                            ),
                          ),

                          if (isUpcomingPlan?.id != "" &&
                              isUpcomingPlan?.plan != null &&
                              isBasicPlan) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Your plan downgrade is scheduled.",
                              style: AppTextStyles.semiBold(12).copyWith(
                                height: 1.0,
                                color: isBasicPlan
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              "Premium access ends on ${isUpcomingPlan?.expiryDate} UTC",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.regular(12).copyWith(
                                height: 1.0,
                                color: isBasicPlan
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Basic plan starts on ${isUpcomingPlan?.expiryDate} UTC",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.regular(12).copyWith(
                                height: 1.0,
                                color: isBasicPlan
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],
                          if (isActive &&
                              state.subscription?.data?.startDate != null &&
                              state.subscription?.data?.expiryDate != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Plan Duration",
                              style: AppTextStyles.semiBold(12).copyWith(
                                height: 1.0,
                                color: isBasicPlan
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              "Start: ${formatDate(state.subscription?.data?.startDate)} UTC",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.regular(12).copyWith(
                                height: 1.0,
                                color: isBasicPlan
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "End: ${formatDate(state.subscription?.data?.expiryDate)} UTC",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.regular(12).copyWith(
                                height: 1.0,
                                color: isBasicPlan
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],

                          if (isExpired) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Previously Selected Plan is Expired",
                              style: AppTextStyles.semiBold(
                                12,
                              ).copyWith(height: 1.0, color: Colors.red),
                            ),

                            if (state.subscription?.data?.startDate != null &&
                                state.subscription?.data?.expiryDate !=
                                    null) ...[
                              const SizedBox(height: 10),
                              Text(
                                "Start: ${formatDate(state.subscription?.data?.startDate)} UTC",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.semiBold(12).copyWith(
                                  height: 1.0,
                                  color: isBasicPlan
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Expired on: ${formatDate(state.subscription?.data?.expiryDate)} UTC",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.semiBold(12).copyWith(
                                  height: 1.0,
                                  color: isBasicPlan
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 5,
                  right: isBasicPlan ? 10 : 5,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          isBasicPlan ? "Starter Plan" : "Premium",
                          style: AppTextStyles.bold(
                            14,
                          ).copyWith(height: 1.0, color: Colors.black),
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.green
                              : (isExpired ? Colors.red : Colors.grey),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 16, color: Colors.orange),
              SizedBox(width: 6),
              Text(
                'Cancel anytime · Secure payment · No hidden fees',
                style: AppTextStyles.regular(
                  14,
                ).copyWith(height: 1.0, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (state.isBlocked == false) ...[
            CustomBottomButton(
              fontStyle: AppTextStyles.semiBold(
                18,
              ).copyWith(height: 1.0, color: Colors.white),
              backgroundColor: AppColors.primaryDark,
              textColor: Colors.white,
              title: isActive == true
                  ? SubscriptionTexts.changeSubPlanTitle
                  : "Get ${isBasicPlan ? "Basic" : "Premium "} - ${package.storeProduct.priceString}/Month",
              icon: const SizedBox(),
              isEnabled: !state.loading,
              onPressed: () {
                context.read<SubscriptionBuyPlanCubit>().selectPackage(package);
                context.read<SubscriptionBuyPlanCubit>().buySelected();
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.subscriptionScreen,
                  FirebaseEvents.goPremiumSubscriptionButton,
                );
              },
            ),

            const SizedBox(height: 10),

            CustomBottomButton(
              fontStyle: AppTextStyles.semiBold(
                18,
              ).copyWith(height: 1.0, color: Colors.white),
              backgroundColor: AppColors.primaryDark,
              textColor: Colors.white,
              title: SubscriptionTexts.restoreSubTitle,
              icon: const SizedBox(),
              isEnabled: true,
              onPressed: () {
                context.read<SubscriptionBuyPlanCubit>().restorePurchases();
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.subscriptionScreen,
                  FirebaseEvents.restoreSubscriptionButton,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final bool isPremium;

  const _FeatureRow({required this.text, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.greenColourForPlan,
            child: const Icon(Icons.check, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.medium(14).copyWith(
                height: 1.0,
                color: isPremium ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
