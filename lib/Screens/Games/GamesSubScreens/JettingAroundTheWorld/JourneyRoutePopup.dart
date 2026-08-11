import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_state.dart';
import 'JettingAroundTheBoardingPass.dart';

class JourneyRoutePopup extends StatefulWidget {
  const JourneyRoutePopup({super.key, required JettingTheWorldCubit cubit})
      : _cubit = cubit;

  final JettingTheWorldCubit _cubit;

  @override
  State<JourneyRoutePopup> createState() => _JourneyRoutePopupState();
}

class _JourneyRoutePopupState extends State<JourneyRoutePopup> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.subscriptionScreen,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showSnackBar(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToLogin(BuildContext ctx) {
    Future.delayed(const Duration(seconds: 1), () {
      if (!ctx.mounted) return;
    });
  }

  void _onStateChange(BuildContext ctx, JettingTheWorldState state) {
    if (state.errorMessage != null) {
      final error = state.errorMessage!;

      if (error.contains('unauthorized') || error.contains('401')) {
        _showSnackBar(ctx, 'Session expired. Please login again.');
        _navigateToLogin(ctx);
        return;
      }
      _showSnackBar(ctx, error);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JettingTheWorldCubit, JettingTheWorldState>(
      listener: _onStateChange,
      builder: (context, state) {
        final airports = widget._cubit.state.airportList;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Journey Route',
                            style: AppTextStyles.bold(
                              22,
                            ).copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: airports.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 0),
                        itemBuilder: (context, index) {
                          final airport = airports[index];

                          final bool isCurrent = index == 0;
                          final bool isLocked = index > 0;

                          return Column(
                            children: [
                              SizedBox(height: 10),

                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: isCurrent
                                                      ? Colors.transparent
                                                      : Colors.grey.shade400,
                                                  width: 1.2,
                                                ),
                                              ),
                                              color: isCurrent
                                                  ? AppColors.greenColourForPlan
                                                  : AppColors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isCurrent
                                                  ? Icons.location_on
                                                  : Icons.lock_outline,
                                              color: isCurrent
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 18,
                                            ),
                                          ),

                                          if (index != airports.length - 1)
                                            Expanded(
                                              child: Container(
                                                width: 2,
                                                margin:
                                                const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                      color:
                                                      Colors.grey.shade400,
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors
                                                  .showColourForJourneyRoute,
                                              blurRadius: 5,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${airport.city} (${airport.iata})",
                                                    style:
                                                    AppTextStyles.bold(
                                                      16,
                                                    ).copyWith(
                                                      color: AppColors
                                                          .primaryDark,
                                                      height: 2.0,
                                                    ),
                                                  ),

                                                  Text(
                                                    airport.country,
                                                    style:
                                                    AppTextStyles.bold(
                                                      16,
                                                    ).copyWith(
                                                      color: AppColors
                                                          .grayMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isCurrent
                                                    ? AppColors
                                                    .greenColourForPlan
                                                    .withValues(
                                                  alpha: 0.2,
                                                )
                                                    : AppColors.grayLight
                                                    .withValues(
                                                  alpha: 0.2,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: isCurrent
                                                      ? AppColors
                                                      .greenColourForPlan
                                                      : AppColors.grayLight,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (isLocked)
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        right: 4,
                                                      ),
                                                      child: Icon(
                                                        Icons.lock_outline,
                                                        size: 14,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                      ),
                                                    ),

                                                  Text(
                                                    isCurrent
                                                        ? "Current Airport"
                                                        : "Locked",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: isCurrent
                                                          ? AppColors
                                                          .greenColourForPlan
                                                          : AppColors
                                                          .grayMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    if (!state.isLoading && airports.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: CustomBottomButton(
                          fontStyle: AppTextStyles.semiBold(
                            18,
                          ).copyWith(color: Colors.white),
                          backgroundColor: AppColors.primaryDark,
                          textColor: Colors.white,
                          title: 'Board Your Journey',
                          isEnabled: true,
                          icon: const SizedBox(),
                          onPressed: () {
                            AnalyticsService.instance.buttonPressed(
                              FirebaseEvents.subscriptionScreen,
                              FirebaseEvents.goPremiumSubscriptionButton,
                            );
                            if (!mounted) return;

                            AppNavigator.push(
                              context,
                              JettingAroundTheBoardingPass(),
                              disableSwipeBack: true,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (state.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
