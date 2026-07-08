import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/point_connection_style.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import 'coordinate_state.dart';
import 'globe_controls_state.dart';

class GoogleEarthMap extends StatefulWidget {
  const GoogleEarthMap({super.key});

  @override
  State<GoogleEarthMap> createState() => _GoogleEarthMap();
}

class _GoogleEarthMap extends State<GoogleEarthMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late FlutterEarthGlobeController _controller;

  bool _isActive = true;
  late List<Point> points;
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: isHovering
        //       ? [AppColors.accentCyan, AppColors.accentPurple]
        //       : [
        //           AppColors.accentCyan.withAlpha(180),
        //           AppColors.accentPurple.withAlpha(180),
        //         ],
        // ),
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   color: Colors.white.withAlpha(isHovering ? 180 : 80),
        //   width: 1.5,
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.accentCyan.withAlpha(isHovering ? 150 : 80),
        //     blurRadius: isHovering ? 20 : 12,
        //     spreadRadius: isHovering ? 2 : 0,
        //   ),
        // ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            point.label ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isActive = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.01,
      minZoom: -1.0,
      maxZoom: 5,
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

    points = [
      buildPoint(
        id: '1',
        coordinates: const GlobeCoordinates(9, 21),
        label: 'Sudan',
      ),
      buildPoint(
        id: '2',
        coordinates: const GlobeCoordinates(1.3521, 103.8198),
        label: 'Singapore',
      ),
      buildPoint(
        id: '3',
        coordinates: const GlobeCoordinates(-9.4333, 159.9500),
        label: 'Honiara',
      ),
      buildPoint(
        id: '4',
        coordinates: const GlobeCoordinates(9.9339, -84.0849),
        label: 'San Jose',
      ),
      buildPoint(
        id: '5',
        coordinates: const GlobeCoordinates(-3.1190, -60.0217),
        label: 'Manaus',
      ),
      buildPoint(
        id: '6',
        coordinates: const GlobeCoordinates(0.3476, 32.5825),
        label: 'Kampala',
      ),
    ];

    // Start Level 4 - > Kinya to Marrocco
    // Start Level 5 - > Marrocco to London
    // Start Level 6 - > London to new York
    // Start Level 7 - > new York to Tokiyo
    // Start Level 8 - > Tokiyo to Mumbai/ Bangalore

    connections = [
      PointConnection(
        start: points[0].coordinates,
        end: points[1].coordinates,
        curveScale: 0.5,
        id: '1',
        isLastId: "",
        style: const PointConnectionStyle(
          color: AppColors.greenColourForPlan,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[1].coordinates,
        end: points[2].coordinates,
        curveScale: 0.5,
        id: '2',
        isLastId: "",
        style: const PointConnectionStyle(
          color: AppColors.greenColourForPlan,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[2].coordinates,
        end: points[3].coordinates,
        curveScale: 0.5,
        id: '3',
        isLastId: "",
        style: const PointConnectionStyle(
          color: AppColors.greenColourForPlan,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[3].coordinates,
        end: points[4].coordinates,
        curveScale: 0.5,
        id: '4',
        isLastId: "",
        style: const PointConnectionStyle(
          color: AppColors.greenColourForPlan,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[4].coordinates,
        end: points[5].coordinates,
        curveScale: 0.5,
        id: '5',
        isLastId: "",
        style: const PointConnectionStyle(
          type: PointConnectionType.dashed,
          color: AppColors.greenColourForPlan,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[5].coordinates,
        end: points[0].coordinates,
        curveScale: 0.5,
        id: '6',
        isLastId: "6",
        style: const PointConnectionStyle(
          type: PointConnectionType.dotted,
          color: AppColors.greenColourForPlan,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
    ];

    for (var point in points) {
      _controller.addPoint(point);
      GlobeControlsState.instance.addVisiblePoint(point.id);
    }

    GlobeControlsState.instance.setZoom(_controller.zoom);
    GlobeControlsState.instance.setRotationSpeed(_controller.rotationSpeed);
    GlobeControlsState.instance.setDayNightBlendFactor(
      _controller.dayNightBlendFactor,
    );

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
        color: color,
        altitude: 1.0,
        transitionDuration: 1000,
        size: 8,
      ),
      onTap: () {
        showPointDialog(
          title: label,
          level: id,
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
        );
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    double radius = screenWidth < 500 ? ((screenWidth / 3.5) - 20) : 140;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Google Earth Map",
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            _isActive = false;
            Navigator.pop(context);
          },
        ),
      ),
      key: _scaffoldKey,
      endDrawer: isSmallScreen ? null : null,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterEarthGlobe(
                onZoomChanged: (zoom) {
                  GlobeControlsState.instance.setZoom(zoom);
                },
                onTap: (coordinates) {
                  CoordinateState.instance.updateClickCoordinates(coordinates);
                },
                onHover: (coordinates) {
                  CoordinateState.instance.updateHoverCoordinates(coordinates);
                },
                controller: _controller,
                radius: radius,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
