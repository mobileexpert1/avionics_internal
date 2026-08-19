import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/point_connection_style.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/JettingAroundTheWorldHelper/globe_controls_state.dart';
import '../../../../bloc/Games/SubGameSection/Calculation_Section/calculation_submit_model.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_model.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_state.dart';
import '../../MainGameScreen/ReusableGameDetailScreen.dart';
import 'JettingAroundBoardingPassesScreen.dart';
import 'JourneyRoutePopup.dart';

class JettingAroundTheWorldScreen extends StatefulWidget {
  const JettingAroundTheWorldScreen({
    super.key,
    required this.isComeFromResultScreen,
    this.responseFromResultScreenData,
  });

  final bool isComeFromResultScreen;
  final SubmitCalculationResultData? responseFromResultScreenData;

  @override
  State<JettingAroundTheWorldScreen> createState() =>
      _JettingAroundTheWorldState();
}

class _JettingAroundTheWorldState extends State<JettingAroundTheWorldScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late FlutterEarthGlobeController _controller;

  List<Point> points = [];
  bool _showLocations = false;
  int isShowCurrentAirportIndex = 0;
  List<PointConnection> connections = [];

  Widget pointLabelBuilder(
    BuildContext context,
    Point point,
    bool isHovering,
    bool visible,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        point.label ?? '',
        textAlign: TextAlign.center,
        softWrap: true,
        style: AppTextStyles.medium(12).copyWith(color: AppColors.white),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (!widget.isComeFromResultScreen) {
      Future.microtask(() {
        context.read<JettingTheWorldCubit>().loadAirports(context);
      });
    } else {
      Future.microtask(() {
        context.read<JettingTheWorldCubit>().loadAirportsFromUnlockResponse(
          context,
          widget.responseFromResultScreenData!,
        );
      });
    }

    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      minZoom: 1.0,
      maxZoom: 8,
      zoom: widget.isComeFromResultScreen ? 2.0 : 1.0,
      isRotating: false,
      atmosphereOpacity: 0.8,
      zoomToMousePosition: false,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/google_earth_map/2k_stars.jpg').image,
      surface: Image.asset(
        'assets/google_earth_map/1_2k_earth-day_light.jpg',
      ).image,
      nightSurface: Image.asset(
        'assets/google_earth_map/2k_earth-night.jpg',
      ).image,
      isDayNightCycleEnabled: false,
      dayNightBlendFactor: 0.15,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> openAddOnPacksBottomSheet(BuildContext context) async {
    final _cubit = context.read<JettingTheWorldCubit>();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: _cubit,
          child: FractionallySizedBox(
            heightFactor: 0.55,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: JourneyRoutePopup(cubit: _cubit),
            ),
          ),
        );
      },
    );
  }

  void updateGlobeFromApi(List<AirportPerItemModel> airports) {
    points.clear();
    connections.clear();

    for (int i = 0; i < airports.length; i++) {
      final airport = airports[i];
      points.add(
        buildPoint(
          id: airport.id.toString(),
          coordinates: GlobeCoordinates(airport.latitude, airport.longitude),
          label: airport.city,
          color: airport.current == true
              ? AppColors.greenColourForPlan
              : airport.unlocked == true
              ? AppColors.primaryBlue
              : AppColors.greyForTextfield,
        ),
      );
      if (airport.current) {
        isShowCurrentAirportIndex = i;
      }
    }

    if (widget.isComeFromResultScreen) {
      for (int i = 0; i < points.length - 1; i++) {
        connections.add(
          PointConnection(
            start: points[i].coordinates,
            end: points[i + 1].coordinates,
            curveScale: 0.5,
            id: i.toString(),
            isLastId: points[isShowCurrentAirportIndex].id,
            style: const PointConnectionStyle(
              color: AppColors.greenColourForPlan,
              transitionDuration: 2000,
              animateOnAdd: true,
              growthAnimationDuration: 2000,
            ),
          ),
        );
      }
    } else {
      if (points.length > 1) {
        connections.add(
          PointConnection(
            start: points[isShowCurrentAirportIndex].coordinates,
            end: points[isShowCurrentAirportIndex].coordinates,
            curveScale: 0.5,
            id: "0",
            style: const PointConnectionStyle(
              color: AppColors.greenColourForPlan,
              transitionDuration: 2000,
              animateOnAdd: true,
              growthAnimationDuration: 2000,
            ),
          ),
        );
      }
    }
    loadPointsOnGlobe();
  }

  void loadPointsOnGlobe() {
    for (var point in points) {
      _controller.addPoint(point);
      GlobeControlsState.instance.addVisiblePoint(point.id);
    }
    GlobeControlsState.instance.setZoom(_controller.zoom);
    Future.delayed(const Duration(milliseconds: 2200), () {
      startConnectionAnimation();
    });
  }

  Future<void> startConnectionAnimation() async {
    for (int i = 0; i < connections.length; i++) {
      final connection = connections[i];

      _controller.addPointConnection(connection, animateDraw: true);
      GlobeControlsState.instance.addVisibleConnection(connection.id);

      _controller.focusOnCoordinates(connection.end, animate: true);
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  Point buildPoint({
    required String id,
    required GlobeCoordinates coordinates,
    required String label,
    Color color = Colors.green,
  }) {
    return Point(
      id: id,
      coordinates: coordinates,
      label: label,
      labelBuilder: pointLabelBuilder,
      isLabelVisible: true,
      style: PointStyle(
        size: 2,
        color: color,
        altitude: 0.05,
        transitionDuration: 600,
      ),
      onTap: () {},
    );
  }

  void showPointDialog({
    required String title,
    required String level,
    required double latitude,
    required double longitude,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Level : $level'),
              const SizedBox(height: 8),
              Text('Latitude : $latitude'),
              Text('Longitude : $longitude'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    double radius = screenWidth < 500 ? ((screenWidth / 3.5) - 20) : 140;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Jetting Around The World",
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
              Navigator.pop(context);
            }
          },
        ),
      ),
      key: _scaffoldKey,
      endDrawer: isSmallScreen ? null : null,
      body: BlocBuilder<JettingTheWorldCubit, JettingTheWorldState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.airportList.isNotEmpty && points.isEmpty) {
            updateGlobeFromApi(state.airportList);
            return SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FlutterEarthGlobe(
                      controller: _controller,
                      radius: radius,
                    ),
                  ),

                  // Bottom List
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: 0,
                    right: 0,
                    bottom: _showLocations ? 70 : -300,
                    child: Material(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: points.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(points[index].label ?? ''),
                              onTap: () {
                                _controller.focusOnCoordinates(
                                  points[index].coordinates,
                                  animate: true,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  if (widget.isComeFromResultScreen) ...[
                    Positioned(
                      top: 15,
                      left: 15,
                      right: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Congratulations\n",
                                  style: AppTextStyles.bold(
                                    24,
                                  ).copyWith(color: AppColors.white),
                                ),
                                TextSpan(
                                  text: "\n",
                                  style: TextStyle(fontSize: 10),
                                ),
                                TextSpan(
                                  text:
                                      "You have Reached ${state.airportList.last.city}",
                                  style: AppTextStyles.regular(
                                    16,
                                  ).copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else
                    Positioned(
                      top: 15,
                      left: 15,
                      right: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Begin Your Adventure\n",
                                  style: AppTextStyles.bold(
                                    24,
                                  ).copyWith(color: AppColors.white),
                                ),
                                TextSpan(
                                  text: "\n",
                                  style: TextStyle(fontSize: 10),
                                ),
                                TextSpan(
                                  text:
                                      "Travel across the world, explore iconic airports, and earn Jettons as you progress.",
                                  style: AppTextStyles.regular(
                                    16,
                                  ).copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: kIsWeb ? 900 : double.infinity,
                        ),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ReusableBottomButton(
                            backgroundColor: AppColors.greenColourForPlan,
                            fontStyle: AppTextStyles.regular(
                              18,
                            ).copyWith(height: 1.0, color: AppColors.black),
                            text: widget.isComeFromResultScreen
                                ? "Journey around the world"
                                : "View Your Journey",
                            onTap: () async {
                              if (widget.isComeFromResultScreen) {
                                await SharedPrefsHelper.clearJettingGames();
                                AppNavigator.push(
                                  context,
                                  JettingAroundBoardingPassesScreen(
                                    isComeFromResultScreen: true,
                                  ),
                                  multiBlocProviders: [
                                    BlocProvider(
                                      create: (_) => JettingBoardingPassCubit(),
                                    ),
                                  ],
                                  disableSwipeBack: true,
                                );
                              } else {
                                openAddOnPacksBottomSheet(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (widget.isComeFromResultScreen) ...[
                    Positioned(
                      bottom: 60,
                      left: 15,
                      right: 15,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: kIsWeb ? 900 : double.infinity,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: statCard(
                                      value: '80',
                                      label:
                                          'Jettons earned as the\nFrequent Flyer',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: statCard(
                                      value: '1000',
                                      label: 'Total Jettons Earned',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          return Center(child: Text("No Data"));
        },
      ),
    );
  }

  Widget statCard({required String value, required String label}) {
    return Container(
      width: 160,
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: AppColors.extraDarkYellow,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              height: 20,
              width: 20,
              child: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.successJettingYellowAround),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.bold(
              24,
            ).copyWith(height: 1.0, color: AppColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.medium(
              16,
            ).copyWith(height: 1.0, color: AppColors.white),
          ),
          SizedBox(height: label.contains("Total") ? 20 : 0),
        ],
      ),
    );
  }
}
