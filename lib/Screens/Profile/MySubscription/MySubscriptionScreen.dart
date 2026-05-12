import 'package:flutter/material.dart';
import '../../../Constants/AppColors.dart';
import '../../../Helpers/AppText.dart';
import '../../Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../Feedback/FeedbackScreen.dart';
import '../SettingScreen/InfoBottomSheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../../bloc/Profile/DeleteProfile/delete_state.dart';
import '../../../bloc/Profile/MySubscription/my_subscription_cubit.dart';
import '../../../bloc/Profile/MySubscription/my_subscription_model.dart';
import '../../../bloc/Profile/MySubscription/my_subscription_state.dart';
import 'package:avionics_internal/Screens/Profile/MySubscription/MySubscriptionDetailScreen.dart';

import 'SubscriptionPlanCard.dart';

class MySubscriptionScreen extends StatefulWidget {
  const MySubscriptionScreen({super.key});

  @override
  State<MySubscriptionScreen> createState() => _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends State<MySubscriptionScreen> {
  late MySubscriptionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<MySubscriptionCubit>();
    _cubit.loadSubscriptionsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: SubscriptionTexts.currentSubTitle,
        centerTitle: false,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
          builder: (context, state) {
            if (state.isLoading == true) {
              return const Center(child: CircularProgressIndicator());
            }

            final current = state.subscriptionData?.data.current;

            final isUpcomingPlan = state.subscriptionData?.data.upcoming;

            final namePlan = current?.plan.name ?? "";

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

            final expiryDate = "${current?.expiryDate ?? ""} UTC";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
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
                            color: Colors.black.withOpacity(0.3),
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
                                    style: AppTextStyles.regular(14).copyWith(
                                      height: 1.0,
                                      color: AppColors.black,
                                    ),
                                  ),

                                  TextSpan(
                                    text:
                                        'Premium access ends on ${isUpcomingPlan?.expiryDate} UTC\nBasic plan starts on ${isUpcomingPlan?.expiryDate} UTC',
                                    style: AppTextStyles.regular(13).copyWith(
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

                  const SizedBox(height: 10),

                  SubscriptionPlanCard(
                    isPremiumPlan: isPremiumPlan,
                    isPlanExpired: isPlanExpired,
                    namePlan: namePlan,
                    planPriceWithSymbol: planPriceWithSymbol,
                    expiryDate: expiryDate,
                    isPlanActive: isPlanActive,
                    showActions: true,
                    onModifyTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SubscriptionPlanDetailScreen(
                            isComeFromSignup: false,
                          ),
                        ),
                      );
                    },

                    onCancelTap: () {
                      if (isPlanExpired) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FeedbackScreen()),
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
                    itemCount: state.subscriptionData!.data.old.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = state.subscriptionData!.data.old[index];
                      return BillingHistoryCard(
                        item: item,
                        onTapGesture: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MySubscriptionDetailScreen(
                                subscriptionItem: item,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
  final MySubscriptionItem item;

  const BillingHistoryCard({
    super.key,
    required this.item,
    required this.onTapGesture,
  });

  @override
  Widget build(BuildContext context) {
    String planPriceWithSymbol = "";

    if (item.priceInPurchasedCurrency != null &&
        item.priceInPurchasedCurrency.toString().isNotEmpty) {
      planPriceWithSymbol =
          "${item.currencySymbol} ${item.priceInPurchasedCurrency}";
    }

    return GestureDetector(
      onTap: onTapGesture,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.plan.name,
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
                              14,
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
                      Text(
                        "${item.startDate} - ${item.expiryDate} UTC",
                        style: AppTextStyles.regular(12).copyWith(
                          height: 1.0,
                          color: AppColors.greyForTextSubscription,
                        ),
                      ),
                    ],
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
