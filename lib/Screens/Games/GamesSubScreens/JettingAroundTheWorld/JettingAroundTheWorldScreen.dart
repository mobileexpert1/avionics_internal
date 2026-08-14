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

import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/JettingAroundTheWorldHelper/globe_controls_state.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_model.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_state.dart';
import '../../MainGameScreen/ReusableGameDetailScreen.dart';
import 'JourneyRoutePopup.dart';

class JettingAroundTheWorldScreen extends StatefulWidget {
  const JettingAroundTheWorldScreen({super.key, required this.isComeFromResultScreen});

  final bool isComeFromResultScreen;

  @override
  State<JettingAroundTheWorldScreen> createState() =>
      _JettingAroundTheWorldState();
}

class _JettingAroundTheWorldState extends State<JettingAroundTheWorldScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late FlutterEarthGlobeController _controller;

  List<Point> points = [];
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

    Future.microtask(() {
      context.read<JettingTheWorldCubit>().loadAirports(context);
    });

    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      minZoom: 1.0,
      maxZoom: 8,
      zoom: 1.0,
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
          color: airport.unlocked == true
              ? AppColors.greenColourForPlan
              : AppColors.primaryBlue,
        ),
      );
    }

    if (points.length > 1) {
      connections.add(
        PointConnection(
          start: points[0].coordinates,
          end: points[0].coordinates,
          curveScale: 0.5,
          id: "0",
          // isLastId: "0",
          style: const PointConnectionStyle(
            color: AppColors.greenColourForPlan,
            transitionDuration: 2000,
            animateOnAdd: true,
            growthAnimationDuration: 2000,
          ),
        ),
      );
    }

    // for (int i = 0; i < points.length - 1; i++) {
    //   connections.add(
    //     PointConnection(
    //       start: points[i].coordinates,
    //
    //       end: points[i + 1].coordinates,
    //
    //       curveScale: 0.5,
    //
    //       id: i.toString(),
    //
    //       isLastId: i == points.length - 2 ? i.toString() : "",
    //
    //       style: const PointConnectionStyle(
    //         color: AppColors.greenColourForPlan,
    //
    //         transitionDuration: 2000,
    //
    //         animateOnAdd: true,
    //
    //         growthAnimationDuration: 2000,
    //       ),
    //     ),
    //   );
    // }

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

        // Border
        // borderColor: Colors.white,
        // borderWidth: 1.0,

        altitude: 0.05,
        transitionDuration: 600,
      ),
      onTap: () {
        // showPointDialog(
        //   title: label,
        //   level: id,
        //   latitude: coordinates.latitude,
        //   longitude: coordinates.longitude,
        // );
      },
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

  bool _showLocations = false;

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
            Navigator.pop(context);
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
                            text: "View Your Journey",
                            onTap: () {
                              openAddOnPacksBottomSheet(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text("No Data"));
        },
      ),
    );
  }
}
