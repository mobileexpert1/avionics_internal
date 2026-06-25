import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/AppColors.dart';
import '../../../../../Constants/ConstantStrings.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../Helpers/AppNavigator.dart';
import '../../../../../Helpers/AppText.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../../../../bloc/Profile/DeleteProfile/delete_state.dart';
import '../../../../../bloc/Profile/MySubscription/my_subscription_cubit.dart';
import '../../../../../bloc/Profile/MySubscription/my_subscription_model.dart';
import '../../../../../bloc/Profile/MySubscription/my_subscription_state.dart';
import '../../../../Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../../InfoBottomSheet.dart';
import '../3_AddOnPacks/AddOnPacksScreen.dart';
import '../4_CreditsTokenUsage/CreditsTokenUsageScreen.dart';
import '../8_Review/FeedbackScreen.dart';
import 'EmptyPackagesView.dart';
import 'MySubscriptionDetailScreen.dart';
import 'SubscriptionPlanCard.dart';

class MySubscriptionScreen extends StatefulWidget {
  final bool? isComeForAddOnPacks;

  const MySubscriptionScreen({super.key, this.isComeForAddOnPacks});

  @override
  State<MySubscriptionScreen> createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  late MySubscriptionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MySubscriptionCubit>();
    _cubit.loadSubscriptionsHistory(context);

    if (widget.isComeForAddOnPacks == true) {
      Future.delayed(const Duration(seconds: 1), () {
        if (!context.mounted) return;
        openAddOnPacksBottomSheet();
      });
    }
  }

  Future<void> openAddOnPacksBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.70,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: const AddOnPacksScreen(packType: AddOnPackType.both),
          ),
        );
      },
    );

    if (result == true && mounted) {
      _cubit.loadSubscriptionsHistory(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: SubscriptionTexts.currentSubTitle,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
          builder: (context, state) {
            if (state.isLoading == true) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.subscriptionData != null) {}

            final current = state.subscriptionData?.data.current;

            // final getCreditModelCount = current?.addOnPacksModel
            //     .where((item) => item.credit > 0)
            //     .length;
            // final getTokenModelCount = current?.addOnPacksModel
            //     .where((item) => item.token > 0)
            //     .length;

            final isUpcomingPlan = state.subscriptionData?.data.upcoming;

            final namePlan = current?.plan.name ?? "";

            final activeBuyPlatform = current?.platform ?? "";

            var isPremiumPlan = current?.plan.name == "Premium Plan";

            String planPriceWithSymbol = "";

            if (current?.priceInPurchasedCurrency != null &&
                current!.priceInPurchasedCurrency.toString().isNotEmpty) {
              planPriceWithSymbol =
                  "${current.currencySymbol} ${current.priceInPurchasedCurrency}";
            }

            final isPlanExpired = current?.status == "expired";

            final isPlanActive =
                current?.status
                    .toUpperCase()
                    .replaceAll("_", " ")
                    .capitalize() ??
                "";

            final expiryDate = current?.expiryDateLocal ?? "";

            return state.subscriptionData != null
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: SizedBox(
                        width: kIsWeb ? 1500 : double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isUpcomingPlan?.id != "" &&
                                isUpcomingPlan?.plan != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: const Icon(
                                        Icons.add_alert_rounded,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Your plan downgrade is scheduled.\n\n',
                                              style: AppTextStyles.regular(14)
                                                  .copyWith(
                                                    height: 1.0,
                                                    color: AppColors.black,
                                                  ),
                                            ),

                                            TextSpan(
                                              text:
                                                  'Premium access ends on ${isUpcomingPlan?.expiryDateLocal}\nBasic plan starts on ${isUpcomingPlan?.expiryDateLocal}',
                                              style: AppTextStyles.regular(13)
                                                  .copyWith(
                                                    height: 1.5,
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],

                            SubscriptionPlanCard(
                              isPremiumPlan: isPremiumPlan,
                              currentPlan: current,
                              isPlanExpired: isPlanExpired,
                              namePlan: namePlan,
                              planPriceWithSymbol: planPriceWithSymbol,
                              expiryDate: expiryDate,
                              isPlanActive: isPlanActive,
                              showActions: true,
                              onModifyTap: () async {
                                if (!canManageSubscription(
                                  context,
                                  activeBuyPlatform,
                                )) {
                                  return;
                                }

                                final result = await AppNavigator.push(
                                  context,
                                  SubscriptionPlanDetailScreen(
                                    isComeFromSignup: false,
                                    isComeFromProfile: true,
                                  ),
                                  disableSwipeBack: true,
                                );

                                if (result == true) {
                                  _cubit.loadSubscriptionsHistory(context);
                                }
                              },
                              onAddOnTap: () async {
                                if (!canManageSubscription(
                                  context,
                                  activeBuyPlatform,
                                )) {
                                  return;
                                }
                                openAddOnPacksBottomSheet();
                              },
                              onViewCreditsTokensTap: () {
                                AppNavigator.push(
                                  context,
                                  CreditsTokenUsageScreen(),
                                  disableSwipeBack: true,
                                );
                              },
                              onCancelTap: () {
                                if (!canManageSubscription(
                                  context,
                                  activeBuyPlatform,
                                )) {
                                  return;
                                }

                                if (isPlanExpired) {
                                  AppNavigator.push(
                                    context,
                                    FeedbackScreen(),
                                    disableSwipeBack: true,
                                  );
                                } else {
                                  showDeleteConfirmation(context);
                                }
                              },
                            ),

                            const SizedBox(height: 25),

                            Text(
                              "Billing History",
                              style: AppTextStyles.bold(
                                16,
                              ).copyWith(height: 1.0, color: AppColors.black),
                            ),

                            const SizedBox(height: 10),

                            ListView.separated(
                              itemCount: buildFlatBillingHistory(
                                state.subscriptionData!.data.old,
                              ).length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final item = buildFlatBillingHistory(
                                  state.subscriptionData!.data.old,
                                )[index];
                                return BillingHistoryCard(
                                  item: item,
                                  currentIndex: index,
                                  isForAddOn: item.addOnItem != null,
                                  onTapGesture: () {
                                    AppNavigator.push(
                                      context,
                                      MySubscriptionDetailScreen(
                                        subscriptionItem: item.subscriptionItem,
                                        isComeFromExtraPacks:
                                            item.addOnItem != null,
                                        isAddOnPacksModelAvailable:
                                            item.addOnItem,
                                      ),
                                      disableSwipeBack: true,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : EmptyPackagesView(isLoading: state.isLoading);
          },
        ),
      ),
    );
  }

  bool canManageSubscription(BuildContext context, String activeBuyPlatform) {
    final bool isMobilePlatform =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    final bool isWebPurchase = activeBuyPlatform.toLowerCase() == "web";

    if (isWebPurchase && isMobilePlatform) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Your current plan was purchased on the website. Please log in to the website to manage it.",
          ),
        ),
      );
      return false;
    }

    if (!isWebPurchase && !isMobilePlatform) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Your current plan was purchased through the mobile app. Please use the app to manage it.",
          ),
        ),
      );
      return false;
    }

    return true;
  }

  void showDeleteConfirmation(BuildContext bottomSheetContext) {
    showModalBottomSheet(
      context: bottomSheetContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider(
          create: (_) => DeleteCubit(),
          child: BlocListener<DeleteCubit, DeleteState>(
            listener: (ctx, state) async {
              if (state.errorMessage.isNotEmpty) {
                Navigator.pop(bottomSheetContext);
                ScaffoldMessenger.of(
                  bottomSheetContext,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            child: Builder(
              builder: (innerContext) {
                return InfoBottomSheet(
                  isComeFromLogout: true,
                  isComeFromSubscription: true,
                  onYes: () {
                    _cubit.guideUserToCancelSubscription();
                  },
                  onNo: () => Navigator.pop(innerContext),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class BillingHistoryCard extends StatelessWidget {
  final VoidCallback onTapGesture;
  final BillingHistoryEntry item;
  final int currentIndex;
  final bool isForAddOn;

  const BillingHistoryCard({
    super.key,
    required this.item,
    required this.onTapGesture,
    required this.currentIndex,
    required this.isForAddOn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapGesture,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: isForAddOn
                  ? _buildAddOnContent()
                  : _buildSubscriptionContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionContent() {
    final sub = item.subscriptionItem!;

    String planPriceWithSymbol = "";
    if (sub.priceInPurchasedCurrency != null &&
        sub.priceInPurchasedCurrency.toString().isNotEmpty) {
      planPriceWithSymbol =
          "${sub.currencySymbol} ${sub.priceInPurchasedCurrency}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                currentIndex == 0
                    ? "Current Plan: ${sub.plan.name}"
                    : sub.plan.name,
                style: AppTextStyles.bold(
                  16,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
            ),
            Row(
              children: [
                Text(
                  planPriceWithSymbol,
                  style: AppTextStyles.semiBold(
                    kIsWeb ? 16 :14,
                  ).copyWith(height: 1.0, color: AppColors.black),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: Colors.grey,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "${sub.startDateLocal} - ${sub.expiryDateLocal}",
                style: AppTextStyles.regular(12).copyWith(
                  height: 1.0,
                  color: AppColors.greyForTextSubscription,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddOnContent() {
    final addOn = item.addOnItem!;

    String addOnPriceWithSymbol = "";
    if (addOn.priceInPurchasedCurrency.isNotEmpty) {
      addOnPriceWithSymbol =
          "${addOn.currencySymbol} ${addOn.priceInPurchasedCurrency}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                addOn.planName,
                style: AppTextStyles.bold(
                  16,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
            ),
            Row(
              children: [
                Text(
                  addOnPriceWithSymbol,
                  style: AppTextStyles.semiBold(
                    kIsWeb ? 16 :14,
                  ).copyWith(height: 1.0, color: AppColors.black),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: Colors.grey,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "Purchased: ${addOn.purchaseDateLocal}",
                style: AppTextStyles.regular(12).copyWith(
                  height: 1.0,
                  color: AppColors.greyForTextSubscription,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
