import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanCubit.dart';
import '../../../../../bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanState.dart';
import '../../../../MapSection/MapHelpers/FlightDetailScreenForMapSection.dart';
import '../../../../Onboarding/Login/LoginScreen.dart';

enum AddOnPackType { both, creditsOnly, tokensOnly }

class AddOnPacksScreen extends StatefulWidget {
  final AddOnPackType packType;

  const AddOnPacksScreen({super.key, this.packType = AddOnPackType.both});

  @override
  State<AddOnPacksScreen> createState() => _AddOnPacksScreenState();
}

class _AddOnPacksScreenState extends State<AddOnPacksScreen> {
  late SubscriptionBuyPlanCubit _cubit;

  int selectedIndex = -1;
  int selectedTab = 0;

  List<String> get mainTabs {
    switch (widget.packType) {
      case AddOnPackType.creditsOnly:
        return ['Credits (Tracker)'];

      case AddOnPackType.tokensOnly:
        return ['Tokens (AI)'];

      case AddOnPackType.both:
        return ['Credits (Tracker)', 'Tokens (AI)'];
    }
  }

  int mainTab = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.packType == AddOnPackType.tokensOnly) {
      selectedTab = 1;
    } else {
      selectedTab = 0;
    }

    _cubit = SubscriptionBuyPlanCubit();
    _cubit.initRevenueCat(true, context);

    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.subscriptionScreen,
    );

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<SubscriptionBuyPlanCubit>()
            .handleWebRedirectionIfNeededForAddOnPacks(context);
      });
    }
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
        Navigator.pop(ctx, true);
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
          final allPackages = state.consumablePackages;

          final packages = allPackages.where((package) {
            final id = package.identifier.toLowerCase();

            switch (widget.packType) {
              case AddOnPackType.creditsOnly:
                return id.contains('credit');

              case AddOnPackType.tokensOnly:
                return id.contains('token');

              case AddOnPackType.both:
                return selectedTab == 0
                    ? id.contains('credit')
                    : id.contains('token');
            }
          }).toList();
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.primaryDark,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primaryDark,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        'Buy Add-ons',
                                        style: AppTextStyles.bold(
                                          22,
                                        ).copyWith(color: Colors.white),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 15.0,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context, true);
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

                                  if (widget.packType == AddOnPackType.both)
                                    Container(
                                      height: 45,
                                      color: AppColors.primaryDark,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final tabWidth =
                                              constraints.maxWidth /
                                              mainTabs.length;

                                          return Stack(
                                            children: [
                                              AnimatedPositioned(
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                curve: Curves.easeInOut,
                                                left: tabWidth * selectedTab,
                                                width: tabWidth,
                                                top: 5,
                                                bottom: 0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                      ),
                                                  child: CustomPaint(
                                                    painter: BrowserTabPainter(
                                                      tabColor: AppColors
                                                          .extraDarkYellow,
                                                      topRadius: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Row(
                                                children: List.generate(
                                                  mainTabs.length,
                                                  (index) => Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedTab = index;
                                                          selectedIndex = -1;
                                                        });
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          mainTabs[index],
                                                          style:
                                                              AppTextStyles.regular(
                                                                16,
                                                              ).copyWith(
                                                                color:
                                                                    selectedTab ==
                                                                        index
                                                                    ? Colors
                                                                          .black
                                                                    : Colors
                                                                          .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   height: 5,
                                              //   color: AppColors.extraDarkYellow,
                                              // ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      child: Text(
                                        mainTabs.first,
                                        style: AppTextStyles.medium(
                                          14,
                                        ).copyWith(color: Colors.white),
                                      ),
                                    ),
                                  Container(
                                    height: 5,
                                    color: AppColors.extraDarkYellow,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.packType == AddOnPackType.creditsOnly
                                ? "Choose a Credit Pack"
                                : widget.packType == AddOnPackType.tokensOnly
                                ? "Choose a Token Pack"
                                : selectedTab == 0
                                ? "Choose a Credit Pack"
                                : "Choose a Token Pack",
                          ),
                        ),
                      ),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: packages.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final package = packages[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
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
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: selectedIndex == index
                                              ? AppColors.primaryBlue
                                              : AppColors.grayMedium,
                                          width: 1,
                                        ),
                                      ),
                                      child: selectedIndex == index
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

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                //returnPackageName(
                                                package.storeProduct.title,
                                                //),
                                                style: AppTextStyles.semiBold(
                                                  16,
                                                ),
                                              ),

                                              Text(
                                                package
                                                    .storeProduct
                                                    .priceString,
                                                style: AppTextStyles.bold(16),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            package.storeProduct.description,
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

                      if (!state.loading && packages.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: CustomBottomButton(
                            fontStyle: AppTextStyles.semiBold(
                              18,
                            ).copyWith(color: Colors.white),
                            backgroundColor: AppColors.primaryDark,
                            textColor: Colors.white,
                            title: 'Continue',
                            icon: const SizedBox(),
                            onPressed: () {
                              if (packages.isEmpty) return;

                              final selectedPackage = packages[selectedIndex];

                              context
                                  .read<SubscriptionBuyPlanCubit>()
                                  .selectConsumablePackage(selectedPackage);

                              context
                                  .read<SubscriptionBuyPlanCubit>()
                                  .buyConsumable(context);

                              AnalyticsService.instance.buttonPressed(
                                FirebaseEvents.subscriptionScreen,
                                FirebaseEvents.goPremiumSubscriptionButton,
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

// String returnPackageName(String inputName) {
//   final name = inputName.toLowerCase();
//   if (name.contains("credit")) {
//     return "10,000 Credits";
//   } else {
//     return "100,000 Tokens";
//   }
// }

// class _ConsumablePackageCard extends StatelessWidget {
//   final Package package;
//   final bool isLoading;
//   final bool isBlocked;
//
//   const _ConsumablePackageCard({
//     required this.package,
//     required this.isLoading,
//     required this.isBlocked,
//   });
//
//   String get _packDescription {
//     final title = package.storeProduct.title.toLowerCase();
//     if (title.contains('token')) return 'Extra Token 500';
//     return 'Extra Credits 500';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           // ── Card ─────────────────────────────────────────────────────────
//           Expanded(
//             child: ClipPath(
//               clipper: CardWithBadgeClipper(),
//               child: Container(
//                 color: AppColors.accentPurple,
//                 padding: const EdgeInsets.fromLTRB(22, 25, 22, 22),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       package.storeProduct.title,
//                       style: AppTextStyles.semiBold(
//                         18,
//                       ).copyWith(height: 1.0, color: Colors.white),
//                     ),
//                     const SizedBox(height: 15),
//
//                     // Price
//                     Text(
//                       package.storeProduct.priceString,
//                       style: AppTextStyles.semiBold(
//                         26,
//                       ).copyWith(height: 1.0, color: Colors.white),
//                     ),
//                     const SizedBox(height: 13),
//
//                     // Pack description
//                     Text(
//                       _packDescription,
//                       style: AppTextStyles.regular(
//                         14,
//                       ).copyWith(height: 1.0, color: Colors.white),
//                     ),
//                     const SizedBox(height: 20),
//
//                     FeatureRow(text: 'One-time purchase, no subscription'),
//                     FeatureRow(text: 'Credits added instantly to your account'),
//                     FeatureRow(text: 'Never expire'),
//                     FeatureRow(text: 'Secure payment'),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // ── Buy button ────────────────────────────────────────────────────
//           if (!isBlocked)
//             CustomBottomButton(
//               fontStyle: AppTextStyles.semiBold(
//                 18,
//               ).copyWith(height: 1.0, color: Colors.white),
//               backgroundColor: AppColors.primaryDark,
//               textColor: Colors.white,
//               title: 'Buy ${package.storeProduct.title}',
//               icon: const SizedBox(),
//               isEnabled: !isLoading,
//               onPressed: () {
//                 context
//                     .read<SubscriptionBuyPlanCubit>()
//                     .selectConsumablePackage(package);
//
//                 context.read<SubscriptionBuyPlanCubit>().buyConsumable();
//
//                 AnalyticsService.instance.buttonPressed(
//                   FirebaseEvents.subscriptionScreen,
//                   FirebaseEvents.goPremiumSubscriptionButton,
//                 );
//               },
//             ),
//
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
