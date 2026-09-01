import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_model.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_state.dart';
import 'JettingAroundTheBoardingPass.dart';

class JettingAroundBoardingPassesScreen extends StatefulWidget {
  final bool isComeFromResultScreen;

  const JettingAroundBoardingPassesScreen({
    super.key,
    required this.isComeFromResultScreen,
  });

  @override
  State<JettingAroundBoardingPassesScreen> createState() =>
      _JettingAroundBoardingPassesState();
}

class _JettingAroundBoardingPassesState
    extends State<JettingAroundBoardingPassesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<JettingBoardingPassCubit>().loadAirports(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.boardingPassTitle,
        isForComparison: true,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            if (widget.isComeFromResultScreen) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              Navigator.pop(context, true);
            }
          },
        ),
      ),
      body: BlocBuilder<JettingBoardingPassCubit, JettingBoardingPassState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final airports = state.airportList;

          if (airports.isEmpty) {
            return const Center(child: Text('No Boarding Pass available'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            itemCount: airports.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final airport = airports[index];
              return GestureDetector(
                onTap: () {
                  AppNavigator.push(
                    context,
                    JettingAroundTheBoardingPass(
                      isComeFromHistoryScreen: true,
                      boardingPassId: airport.id,
                      isNeedToShowOnlyBoardingPass: false,
                    ),
                    disableSwipeBack: true,
                  );
                },
                child: RouteCard(airport: airport, isFirst: index == 0),
              );
            },
          );
        },
      ),
    );
  }
}

class RouteCard extends StatelessWidget {
  final BoardingPassModel airport;
  final bool isFirst;

  const RouteCard({super.key, required this.airport, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(children: [_buildHeader(), _buildRouteContent()]),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 58,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          CommonUi.setSvgImage(AssetsPath.mainLogoTransparentColour),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildRouteContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 18),
      child: Column(
        children: [
          _buildFromToLabels(),
          const SizedBox(height: 10),
          _buildCountryRow(true),
          const SizedBox(height: 5),
          _buildRoute(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFromToLabels() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_SmallLabel('From'), _SmallLabel('To')],
    );
  }

  Widget _buildCountryRow(bool isComeFromTop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SubText(airport.fromAirport.city, isComeFromTop: isComeFromTop),
        _SubText(
          airport.toAirport.city,
          alignRight: true,
          isComeFromTop: isComeFromTop,
        ),
      ],
    );
  }

  Widget _buildRoute() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT AIRPORT
        Expanded(flex: 3, child: _buildLeftAirport()),

        // CENTER ROUTE
        Expanded(
          flex: 4,
          child: buildCustomProgressBar(
            0.5,
            airport.toAirport.colourCode != ""
                ? airport.toAirport.colourCode.toColor()
                : AppColors.textHomeColour,
            airport.toAirport.distanceNM.toString(),
          ),
        ),

        // RIGHT AIRPORT
        Expanded(flex: 3, child: _buildRightAirport()),
      ],
    );
  }

  Widget buildCustomProgressBar(double progress, Color color, String distance) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;

          const planeSize = 28.0;
          const lineHeight = 2.5;
          const horizontalPadding = 2.0;

          // Prevent invalid clamp ranges on very small devices.
          final usableWidth = (totalWidth - (horizontalPadding * 2)).clamp(
            0.0,
            double.infinity,
          );

          final planeCenterX = horizontalPadding + (usableWidth * progress);

          // Safe airplane position.
          final maxPlaneLeft = (totalWidth - planeSize - horizontalPadding);

          final planeLeft = maxPlaneLeft <= horizontalPadding
              ? horizontalPadding
              : (planeCenterX - (planeSize / 2)).clamp(
                  horizontalPadding,
                  maxPlaneLeft,
                );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // LEFT LINE
              Positioned(
                left: horizontalPadding,
                top: 13,
                width: (planeCenterX - horizontalPadding).clamp(
                  0.0,
                  usableWidth,
                ),
                child: Container(height: lineHeight, color: Colors.black),
              ),

              // RIGHT LINE
              Positioned(
                left: planeCenterX,
                right: horizontalPadding,
                top: 13,
                child: Container(
                  height: lineHeight,
                  color: Colors.grey.shade300,
                ),
              ),

              // AIRPLANE + DISTANCE
              Positioned(
                left: planeLeft,
                top: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: planeSize,
                      height: planeSize,
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(getNextCategory()),
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "$distance NM",
                      maxLines: 1,
                      softWrap: false,
                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(height: 1.0, color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeftAirport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_MainText(airport.fromAirport.flightSegment)],
    );
  }

  Widget _buildRightAirport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [_MainText(airport.toAirport.flightSegment, alignRight: true)],
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String text;

  const _SmallLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.regular(
        14,
      ).copyWith(height: 1.0, color: AppColors.grayMedium),
    );
  }
}

class _SubText extends StatelessWidget {
  final String text;
  final bool alignRight;
  final bool isComeFromTop;

  const _SubText(
    this.text, {
    this.alignRight = false,
    this.isComeFromTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: isComeFromTop
          ? AppTextStyles.regular(
              12,
            ).copyWith(height: 1.0, color: AppColors.primaryDark)
          : AppTextStyles.medium(
              16,
            ).copyWith(height: 1.0, color: AppColors.primaryDark),
    );
  }
}

class _MainText extends StatelessWidget {
  final String text;
  final bool alignRight;

  const _MainText(this.text, {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: AppTextStyles.bold(
        22,
      ).copyWith(height: 1.0, color: AppColors.primaryDark),
    );
  }
}
