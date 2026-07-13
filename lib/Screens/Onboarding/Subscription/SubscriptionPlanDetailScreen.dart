import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CardWithBadgeClipper.dart';
import '../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanCubit.dart';
import '../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanState.dart';
import '../../Home/RootTabbar/RootTabbarScreen.dart';
import '../../Profile/SettingScreen/SettingMenuScreen/2_MySubscription/FeatureRow.dart';
import '../../Profile/SettingScreen/SettingMenuScreen/2_MySubscription/StepIndicator.dart';
import '../Login/LoginScreen.dart';

class SubscriptionPlanDetailScreen extends StatefulWidget {
  final bool? isComeFromSignup;
  final bool? isComeFromProfile;

  const SubscriptionPlanDetailScreen({
    super.key,
    this.isComeFromSignup,
    this.isComeFromProfile,
  });

  @override
  State<SubscriptionPlanDetailScreen> createState() =>
      _SubscriptionPlanDetailState();
}

class _SubscriptionPlanDetailState extends State<SubscriptionPlanDetailScreen> {
  late SubscriptionBuyPlanCubit _cubit;
  bool _hasNavigated = false;

  int currentPage = 0;
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _cubit = SubscriptionBuyPlanCubit();
    _cubit.isComeFromSignup = widget.isComeFromSignup ?? false;
    _cubit.initRevenueCat(widget.isComeFromProfile ?? false, context);
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.subscriptionScreen,
    );

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SubscriptionBuyPlanCubit>().handleWebRedirectionIfNeeded(
          context,
        );
      });
    }
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
              } else if (state.isComeFromProfile == true) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                });
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          }

          if (state.consumablePurchased == true && state.loading == false) {
            context
                .read<SubscriptionBuyPlanCubit>()
                .resetConsumablePurchaseState();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Purchase successful. Extra data will be automatically added to your account.',
                ),
              ),
            );

            Future.delayed(const Duration(seconds: 2), () {
              if (!context.mounted) return;
              Navigator.pop(context);
            });
          }

          if (_cubit.isComeFromSignup == true) {
            if (state.purchased &&
                state.waitingForBackendConfirmation != true &&
                !_hasNavigated) {
              Future.delayed(const Duration(seconds: 2), () {
                if (!context.mounted) return;
                _hasNavigated = true;

                AppSnackBar.custom(
                  context,
                  message: (widget.isComeFromSignup == true
                      ? "Purchase Successfully"
                      : "Restore Subscription Successfully"),
                  svgAsset: CommonUi.setSvgImage(AssetsPath.signInIconForAlert),
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
          final subscriptionPackages = state.subscriptionPackages;

          final isComeFromSignup = _cubit.isComeFromSignup;
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: kIsWeb
                    ? null
                    : CustomAppBar(
                        title: isComeFromSignup
                            ? ConstantStrings.startSubscription
                            : SubscriptionTexts.currentPlanTitle,
                        centerTitle: isComeFromSignup ? true : false,
                        leftButton: IconButton(
                          icon: Icon(
                            isComeFromSignup
                                ? Icons.logout
                                : Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            if (isComeFromSignup) {
                              context
                                  .read<SubscriptionBuyPlanCubit>()
                                  .clearAllDataAndRedirectToSplashScreen(
                                    context,
                                  );
                            } else {
                              Navigator.pop(context, true);
                            }
                          },
                        ),
                      ),
                body: SafeArea(
                  child: Center(
                    child: SizedBox(
                      width: kIsWeb ? 1500 : double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!kIsWeb) ...[
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isComeFromSignup
                                        ? 'Choose Your Plan'
                                        : 'Manage Your Plan',
                                    style: AppTextStyles.bold(26).copyWith(
                                      height: 1.0,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  StepIndicator(
                                    total: subscriptionPackages.length,
                                    current: currentPage,
                                  ),
                                ],
                              ),
                            ),
                          ],

                          SizedBox(height: 10),

                          Expanded(
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: subscriptionPackages.length,
                              onPageChanged: (index) {
                                setState(() => currentPage = index);
                              },
                              itemBuilder: (context, index) {
                                final package = subscriptionPackages[index];
                                return _PlanCard(
                                  state: state,
                                  package: package,
                                  isLoading: state.loading,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.loading) ...[
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            ],
          );
        },
      ),
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
                            "${package.storeProduct.title.replaceAll("(avioflai)", "")} ",
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
                              itemBuilder: (_, i) => FeatureRow(
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
                              "Premium access ends on ${(isUpcomingPlan?.expiryDateLocal)}",
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
                              "Basic plan starts on ${(isUpcomingPlan?.expiryDateLocal)}",
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
                              "Start: ${(state.subscription?.data?.startDateLocal)}",
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
                              "End: ${(state.subscription?.data?.expiryDateLocal)}",
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
                                "Start: ${(state.subscription?.data?.startDateLocal)}",
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
                                "Expired on: ${(state.subscription?.data?.expiryDateLocal)}",
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
                          isBasicPlan ? "Starter" : "Premium",
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
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
