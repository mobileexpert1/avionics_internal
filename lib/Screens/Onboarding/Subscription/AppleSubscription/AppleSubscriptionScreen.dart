import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Onboarding/Subscription/iosFolder/AppleSubscriptionCubit.dart';
import '../../../../bloc/Onboarding/Subscription/iosFolder/AppleSubscriptionState.dart';
import '../../../Home/RootTabbar/RootTabbarScreen.dart';
import '../../Login/LoginScreen.dart';

class AppleSubscriptionScreen extends StatefulWidget {
  final bool? isComeFromSignup;
  final bool? isComeFromSocialLogin;

  const AppleSubscriptionScreen({
    super.key,
    this.isComeFromSignup,
    this.isComeFromSocialLogin,
  });

  @override
  _AppleSubscriptionScreenState createState() =>
      _AppleSubscriptionScreenState();
}

class _AppleSubscriptionScreenState extends State<AppleSubscriptionScreen> {
  late AppleSubscriptionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AppleSubscriptionCubit(autoRestore: true);

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppleSubscriptionCubit>().handleWebRedirectionIfNeeded();
      });
    }
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.subscriptionScreen,
    );
  }

  @override
  void dispose() {
    _cubit.globalWebRedirectDone = false;
    _cubit.close();
    super.dispose();
  }

  String _cleanProductTitle(ProductDetails product) {
    final title = product.title;
    if (title.contains("(")) {
      return title.substring(0, title.indexOf("(")).trim().toLowerCase();
    }
    return title.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<AppleSubscriptionCubit, AppleSubscriptionState>(
        listenWhen: (prev, curr) =>
            (prev.error != curr.error && curr.error != null) ||
            (prev.purchased != curr.purchased && curr.purchased),
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              });
            }
            if (state.error!.toLowerCase().contains(
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          }

          if (state.purchased) {
            AppSnackBar.custom(
              context,
              message: (widget.isComeFromSignup == true
                  ? "Purchase Successfully"
                  : "Restore Subscription Successfully"),
              svgAsset: CommonUi.setSvgImage(AssetsPath.signinIcon),
            );

            if (widget.isComeFromSignup == true) {
              //_navigated = true;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => RootTabbarscreen()),
                (route) => false,
              );
            }
          }
        },
        builder: (context, state) {
          final products = [...state.products]
            ..sort(
              (a, b) => _cleanProductTitle(a).compareTo(_cleanProductTitle(b)),
            );

          ProductDetails? selected;
          if (state.selectedProduct != null) {
            selected = state.selectedProduct;
          } else {
            final activePlans = state.products.where(
              (p) =>
                  p.id == state.subscription?.productId &&
                  state.subscription?.status == "active",
            );
            selected = activePlans.isNotEmpty ? activePlans.first : null;
          }

          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title:
                      (widget.isComeFromSignup == false ||
                          widget.isComeFromSignup == null)
                      ? SubscriptionTexts.currentSubTitle
                      : ConstantStrings.startSubscription,
                  centerTitle:
                      (widget.isComeFromSignup == false ||
                          widget.isComeFromSignup == null)
                      ? false
                      : true,
                  leftButton:
                      (widget.isComeFromSignup == false ||
                          widget.isComeFromSignup == null)
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      : Wrap(),
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
                          text: "Save your Favorites Aircraft",
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
                          text: "Track the aircraft",
                        ),
                        const SizedBox(height: 20),

                        // Subscription Plans
                        ...products.map((product) {
                          final bool isActive =
                              state.subscription?.productId == product.id &&
                              state.subscription?.status == "active";

                          final bool isExpired =
                              state.subscription?.productId == product.id &&
                              state.subscription?.status == "expired";

                          final bool isSelected = selected?.id == product.id;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _SubscriptionCard(
                              product: product,
                              isSelected: isSelected,
                              isActive: isActive,
                              isExpired: isExpired,
                              startDate: state.subscription?.startDate,
                              endDate: state.subscription?.expiryDate,
                              onTap: () {
                                context
                                    .read<AppleSubscriptionCubit>()
                                    .selectPlan(product);
                              },
                            ),
                          );
                        }),

                        const SizedBox(height: 20),
                        CustomBottomButton(
                          fontStyle: AppTextStyles.regular(
                            21.46,
                          ).copyWith(height: 1.0, color: Colors.white),
                          backgroundColor: const Color.fromRGBO(
                            30,
                            128,
                            242,
                            1.0,
                          ),
                          textColor: Colors.white,
                          title: SubscriptionTexts.restoreSubTitle,
                          icon: const SizedBox(),
                          isEnabled: true,
                          onPressed: () {
                            context
                                .read<AppleSubscriptionCubit>()
                                .restorePurchases();
                            AnalyticsService.instance.buttonPressed(
                              FirebaseEvents.subscriptionScreen,
                              FirebaseEvents.restoreSubscriptionButton,
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // Bottom Buttons
                        if (widget.isComeFromSignup == false ||
                            widget.isComeFromSignup == null) ...[
                          CustomBottomButton(
                            fontStyle: AppTextStyles.regular(21.46).copyWith(
                              height: 1.0,
                              color: selected != null && !state.loading
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
                            isEnabled: selected != null && !state.loading,
                            onPressed: () {
                              if (selected != null) {
                                context
                                    .read<AppleSubscriptionCubit>()
                                    .buySelected();
                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.subscriptionScreen,
                                  FirebaseEvents.goPremiumSubscriptionButton,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomBottomButton(
                            fontStyle: AppTextStyles.regular(
                              21.46,
                            ).copyWith(height: 1.0, color: Colors.white),
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            title: SubscriptionTexts.cancelTitle,
                            icon: const SizedBox(),
                            isEnabled: true,
                            onPressed: () {
                              context
                                  .read<AppleSubscriptionCubit>()
                                  .guideUserToCancelSubscription();
                              AnalyticsService.instance.buttonPressed(
                                FirebaseEvents.subscriptionScreen,
                                FirebaseEvents.cancelSubscriptionButton,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ] else ...[
                          CustomBottomButton(
                            fontStyle: AppTextStyles.regular(21.46).copyWith(
                              height: 1.0,
                              color: selected != null
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                            backgroundColor: const Color(0xFF3F3D51),
                            textColor: Colors.white,
                            title: "Go Premium",
                            icon: const SizedBox(),
                            isEnabled: selected != null,
                            onPressed: () async {
                              if (selected != null) {
                                context
                                    .read<AppleSubscriptionCubit>()
                                    .buySelected();
                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.subscriptionScreen,
                                  FirebaseEvents.goPremiumSubscriptionButton,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],

                        // if (selected != null)
                        //   Text(
                        //     "Free for 7 days then ${selected.price}\nCancel anytime.",
                        //     textAlign: TextAlign.center,
                        //     style: const TextStyle(
                        //       color: Color(0xFF626262),
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
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
  final bool isSelected; // tapped by user
  final bool isActive; // actually active subscription
  final bool isExpired;
  final VoidCallback onTap;
  final String? startDate;
  final String? endDate;

  const _SubscriptionCard({
    required this.product,
    required this.isSelected,
    required this.isActive,
    required this.isExpired,
    required this.onTap,
    this.startDate,
    this.endDate,
  });

  String cleanTitle(String title) {
    if (title.contains("(")) {
      title = title.substring(0, title.indexOf("(")).trim();
    }
    final lower = title.toLowerCase();
    if (lower.contains("monthly")) {
      return "Basic";
    } else if (lower.contains("yearly")) {
      return "Premium";
    }
    return title;
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return "-";

    final date = DateTime.tryParse("${isoDate}Z")?.toLocal();
    if (date == null) return "-";

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

    int hour = date.hour % 12;
    if (hour == 0) hour = 12;

    final amPm = date.hour >= 12 ? "PM" : "AM";

    return "${date.day.toString().padLeft(2, '0')}-"
        "${monthNames[date.month - 1]}-${date.year} "
        "${hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')} $amPm";
  }

  @override
  Widget build(BuildContext context) {
    final showActiveDates = isActive && isSelected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.blue.shade50
              : isExpired
              ? Colors.red.shade50
              : Colors.white,
          border: Border.all(
            color: isActive
                ? Colors.blue
                : isExpired
                ? Colors.red
                : (isSelected ? Colors.black : Colors.grey.shade300),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // LEFT SIDE (takes remaining space)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleanTitle(product.title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (showActiveDates &&
                      startDate != null &&
                      endDate != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      "Start: ${formatDate(startDate)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      "End: ${formatDate(endDate)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],

                  if (isExpired) ...[
                    const SizedBox(height: 6),
                    const Text(
                      "Previously Selected Plan",
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ],

                  if (isExpired && startDate != null && endDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Start: ${formatDate(startDate)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Expired on: ${formatDate(endDate)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            Container(
              constraints: const BoxConstraints(minWidth: 90, maxWidth: 100),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      product.price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isSelected)
                    SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.tickIcon),
                      height: 16,
                      width: 16,
                      color: Colors.black,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
