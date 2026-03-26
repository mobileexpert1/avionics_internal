import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/point_connection_style.dart';
import 'package:flutter/material.dart';
import '../../../Constants/AppColors.dart';
import '../../../CustomFiles/CustomAppBar.dart';
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isHovering
              ? [AppColors.accentCyan, AppColors.accentPurple]
              : [
                  AppColors.accentCyan.withAlpha(180),
                  AppColors.accentPurple.withAlpha(180),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(isHovering ? 180 : 80),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withAlpha(isHovering ? 150 : 80),
            blurRadius: isHovering ? 20 : 12,
            spreadRadius: isHovering ? 2 : 0,
          ),
        ],
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
      rotationSpeed: 0.05,
      minZoom: -1.5,
      maxZoom: 5,
      zoom: 1.8,
      isRotating: false,
      atmosphereOpacity: 0.8,
      zoomToMousePosition: false,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/google_earth_map/2k_stars.jpg').image,
      surface: Image.asset('assets/google_earth_map/2k_earth-day.jpg').image,
      nightSurface: Image.asset(
        'assets/google_earth_map/2k_earth-night.jpg',
      ).image,
      isDayNightCycleEnabled: false,
      dayNightBlendFactor: 0.15,
    );

    points = [
      Point(
        id: '1',
        coordinates: const GlobeCoordinates(30.7333, 76.7794),
        label: 'Chandigarh Level 1',
        labelBuilder: pointLabelBuilder,
        isLabelVisible: true,
        style: const PointStyle(
          color: Colors.cyan,
          size: 6,
          altitude: 0.1,
          transitionDuration: 500,
        ),
      ),
      Point(
        id: '2',
        coordinates: const GlobeCoordinates(25.2048, 55.2708),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'Dubai Level 2',
        labelBuilder: pointLabelBuilder,
      ),
      Point(
        id: '3',
        coordinates: const GlobeCoordinates(-1.2921, 36.8219),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'Kinya Level 3',
        labelBuilder: pointLabelBuilder,
      ),
      Point(
        id: '4',
        coordinates: const GlobeCoordinates(33.5731, -7.5898),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'Marrocco Level 4',
        labelBuilder: pointLabelBuilder,
      ),
      Point(
        id: '5',
        coordinates: const GlobeCoordinates(51.5074, -0.1278),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'London Level 5',
        labelBuilder: pointLabelBuilder,
      ),
      Point(
        id: '6',
        coordinates: const GlobeCoordinates(40.7128, -74.0060),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'new York Level 6',
        labelBuilder: pointLabelBuilder,
      ),
      Point(
        id: '7',
        coordinates: const GlobeCoordinates(35.6762, 139.6503),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'Tokiyo Level 7',
        labelBuilder: pointLabelBuilder,
      ),
      Point(
        id: '8',
        coordinates: const GlobeCoordinates(19.0760, 72.8777),
        style: const PointStyle(
          color: Colors.green,
          altitude: 0.05,
          transitionDuration: 600,
        ),
        isLabelVisible: true,
        label: 'Mumbai Level 8',
        labelBuilder: pointLabelBuilder,
      ),
    ];

    connections = [
      PointConnection(
        start: points[0].coordinates,
        end: points[1].coordinates,
        curveScale: 0.5,
        id: '1',
        style: const PointConnectionStyle(
          color: Colors.red,
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
        style: const PointConnectionStyle(
          color: Colors.blue,
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
        style: const PointConnectionStyle(
          color: Colors.green,
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
        style: const PointConnectionStyle(
          color: Colors.orange,
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
        style: const PointConnectionStyle(
          color: Colors.pink,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[5].coordinates,
        end: points[6].coordinates,
        curveScale: 0.5,
        id: '6',
        style: const PointConnectionStyle(
          color: Colors.indigoAccent,
          transitionDuration: 2000,
          animateOnAdd: true,
          growthAnimationDuration: 2000,
        ),
      ),
      PointConnection(
        start: points[6].coordinates,
        end: points[7].coordinates,
        curveScale: 0.5,
        id: '7',
        style: const PointConnectionStyle(
          color: Colors.brown,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (!mounted || !_isActive) return;
        startConnectionAnimation();
      });
    });
  }

  Future<void> startConnectionAnimation() async {
    for (int i = 0; i < connections.length; i++) {
      if (!mounted || !_isActive) return;

      final connection = connections[i];

      try {
        _controller.addPointConnection(connection, animateDraw: true);
      } catch (_) {
        return;
      }

      GlobeControlsState.instance.addVisibleConnection(connection.id);

      _controller.focusOnCoordinates(connection.end, animate: true);

      await Future.delayed(const Duration(seconds: 3));

      if (!mounted || !_isActive) return;
    }
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
