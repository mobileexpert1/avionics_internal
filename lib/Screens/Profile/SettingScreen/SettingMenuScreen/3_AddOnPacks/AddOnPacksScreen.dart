import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../Helpers/CardWithBadgeClipper.dart';
import '../../../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanCubit.dart';
import '../../../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanState.dart';
import '../../../../Onboarding/Login/LoginScreen.dart';
import '../2_MySubscription/FeatureRow.dart';
import '../2_MySubscription/StepIndicator.dart';

class AddOnPacksScreen extends StatefulWidget {
  const AddOnPacksScreen({super.key});

  @override
  State<AddOnPacksScreen> createState() => _AddOnPacksScreenState();
}

class _AddOnPacksScreenState extends State<AddOnPacksScreen> {
  late SubscriptionBuyPlanCubit _cubit;

  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _cubit = SubscriptionBuyPlanCubit();
    _cubit.initRevenueCat(true,context);

    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.subscriptionScreen,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _pageController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToLogin(BuildContext ctx) {
    Future.delayed(const Duration(seconds: 1), () {
      if (!ctx.mounted) return;
      Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    });
  }

  void _onStateChange(BuildContext ctx, SubscriptionBuyPlanState state) {
    if (state.error != null) {
      final error = state.error!;

      if (error.contains('unauthorized') || error.contains('401')) {
        _showSnackBar(ctx, 'Session expired. Please login again.');
        _navigateToLogin(ctx);
        return;
      }

      if (error.toLowerCase().contains(
        '400 sorry, we could not find your subscription.'.toLowerCase(),
      )) {
        _showSnackBar(
          ctx,
          'We could not find your subscription. Please buy a subscription.',
        );
        return;
      }

      if (state.isBlocked == true) {
        _navigateToLogin(ctx);
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          if (!ctx.mounted) return;
          Navigator.pop(ctx);
        });
      }

      _showSnackBar(ctx, error);
      return;
    }

    if (state.consumablePurchased == true && state.loading == false) {
      ctx.read<SubscriptionBuyPlanCubit>().resetConsumablePurchaseState();

      _showSnackBar(
        ctx,
        'Purchase successful. Extra data will be automatically added to your account.',
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (!ctx.mounted) return;
        Navigator.pop(ctx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<SubscriptionBuyPlanCubit, SubscriptionBuyPlanState>(
        listener: _onStateChange,
        builder: (context, state) {
          final packages = state.consumablePackages;

          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title: 'Buy Extra Credits',
                  centerTitle: false,
                  leftButton: IconButton(
                    icon: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.backArrowButton),
                      fit: BoxFit.cover,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Choose a Pack',
                              style: AppTextStyles.bold(
                                26,
                              ).copyWith(height: 1.0, color: AppColors.black),
                            ),
                            StepIndicator(
                              total: packages.length,
                              current: _currentPage,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: packages.length,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            return _ConsumablePackageCard(
                              package: packages[index],
                              isLoading: state.loading,
                              isBlocked: state.isBlocked ?? false,
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
}

class _ConsumablePackageCard extends StatelessWidget {
  final Package package;
  final bool isLoading;
  final bool isBlocked;

  const _ConsumablePackageCard({
    required this.package,
    required this.isLoading,
    required this.isBlocked,
  });

  String get _packDescription {
    final title = package.storeProduct.title.toLowerCase();
    if (title.contains('token')) return 'Extra Token 500';
    return 'Extra Credits 500';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // ── Card ─────────────────────────────────────────────────────────
          Expanded(
            child: ClipPath(
              clipper: CardWithBadgeClipper(),
              child: Container(
                color: AppColors.accentPurple,
                padding: const EdgeInsets.fromLTRB(22, 25, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.storeProduct.title,
                      style: AppTextStyles.semiBold(
                        18,
                      ).copyWith(height: 1.0, color: Colors.white),
                    ),
                    const SizedBox(height: 15),

                    // Price
                    Text(
                      package.storeProduct.priceString,
                      style: AppTextStyles.semiBold(
                        26,
                      ).copyWith(height: 1.0, color: Colors.white),
                    ),
                    const SizedBox(height: 13),

                    // Pack description
                    Text(
                      _packDescription,
                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(height: 1.0, color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    FeatureRow(text: 'One-time purchase, no subscription'),
                    FeatureRow(text: 'Credits added instantly to your account'),
                    FeatureRow(text: 'Never expire'),
                    FeatureRow(text: 'Secure payment'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Buy button ────────────────────────────────────────────────────
          if (!isBlocked)
            CustomBottomButton(
              fontStyle: AppTextStyles.semiBold(
                18,
              ).copyWith(height: 1.0, color: Colors.white),
              backgroundColor: AppColors.primaryDark,
              textColor: Colors.white,
              title: 'Buy ${package.storeProduct.title}',
              icon: const SizedBox(),
              isEnabled: !isLoading,
              onPressed: () {
                context
                    .read<SubscriptionBuyPlanCubit>()
                    .selectConsumablePackage(package);

                context.read<SubscriptionBuyPlanCubit>().buyConsumable();

                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.subscriptionScreen,
                  FirebaseEvents.goPremiumSubscriptionButton,
                );
              },
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
