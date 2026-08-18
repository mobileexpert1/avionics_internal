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
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 50.0,
                        height: 6.34,
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(9.03),
                        ),
                      ),
                    ),
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

                    SizedBox(height: 15),

                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: airports.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 0),
                        itemBuilder: (context, index) {
                          final airport = airports[index];

                          final bool isCurrent = index == 0;
                          final bool isLocked = index > 0;

                          return Column(
                            children: [
                              SizedBox(height: 5),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: isCurrent
                                                  ? AppColors.greenColourForPlan
                                                  : Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: AppColors
                                                      .showColourForJourneyRoute,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              isCurrent
                                                  ? Icons.location_on
                                                  : Icons.lock_outline,
                                              color: isCurrent
                                                  ? Colors.white
                                                  : AppColors.primaryDark,
                                              size: isCurrent ? 24 : 18,
                                            ),
                                          ),

                                          const SizedBox(height: 3),

                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: isCurrent
                                                  ? AppColors.black
                                                  : AppColors.grayMedium,
                                              shape: BoxShape.circle,
                                            ),
                                          ),

                                          const SizedBox(height: 5),

                                          /// DYNAMIC HEIGHT LINE
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                8,
                                                (_) => Container(
                                                  width: 2,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: isCurrent
                                                        ? AppColors.black
                                                        : AppColors.grayMedium,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 20),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                              AppTextStyles.regular(
                                                                14,
                                                              ).copyWith(
                                                                color: AppColors
                                                                    .grayMedium,
                                                                height: 1.5,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  const SizedBox(width: 8),

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
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      border: Border.all(
                                                        color: isCurrent
                                                            ? AppColors
                                                                  .greenColourForPlan
                                                            : AppColors
                                                                  .grayLight,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        if (isLocked)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  right: 4,
                                                                ),
                                                            child: Icon(
                                                              Icons
                                                                  .lock_outline,
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

                                            /// LEFT SIDE CHEVRON
                                            Positioned(
                                              left: -12,
                                              top: 10,
                                              child: SizedBox(
                                                width: 12,
                                                height: 12,
                                                child: CustomPaint(
                                                  painter: ChevronPainter(
                                                    color: isCurrent
                                                        ? AppColors.primaryDark
                                                        : AppColors.grayLight,
                                                  ),
                                                ),
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

class ChevronPainter extends CustomPainter {
  final Color color;

  ChevronPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
