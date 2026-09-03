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
import '../../../../Helpers/WebAndMobileBrowser/web_iframe_widget.dart';
import '../../../../bloc/Games/SubGameSection/Calculation_Section/calculation_submit_model.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_model.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_state.dart';
import '../../MainGameScreen/ReusableGameDetailScreen.dart';
import 'JettingAroundBoardingPassesScreen.dart';
import 'JourneyRoutePopup.dart';

class JettingAroundTheWorldScreen extends StatelessWidget {
  const JettingAroundTheWorldScreen({
    super.key,
    required this.isComeFromResultScreen,
    this.responseFromResultScreenData,
  });

  final bool isComeFromResultScreen;
  final SubmitCalculationResultData? responseFromResultScreenData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JettingTheWorldCubit(),
      child: _JettingAroundTheWorldView(
        isComeFromResultScreen: isComeFromResultScreen,
        responseFromResultScreenData: responseFromResultScreenData,
      ),
    );
  }
}

class _JettingAroundTheWorldView extends StatefulWidget {
  const _JettingAroundTheWorldView({
    required this.isComeFromResultScreen,
    this.responseFromResultScreenData,
  });

  final bool isComeFromResultScreen;
  final SubmitCalculationResultData? responseFromResultScreenData;

  @override
  State<_JettingAroundTheWorldView> createState() =>
      _JettingAroundTheWorldViewState();
}

class _JettingAroundTheWorldViewState
    extends State<_JettingAroundTheWorldView> {
  String _webUrl = '';
  final List<Point> points = [];
  int isShowCurrentAirportIndex = 0;
  bool ignorePointer = false;
  final List<PointConnection> connections = [];
  late FlutterEarthGlobeController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      minZoom: 1.0,
      maxZoom: 8.0,
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

    Future.microtask(() {
      if (!mounted) return;

      final cubit = context.read<JettingTheWorldCubit>();

      if (!widget.isComeFromResultScreen) {
        cubit.loadAirports(context);
      } else {
        final result = widget.responseFromResultScreenData;

        if (result != null) {
          cubit.loadAirportsFromUnlockResponse(context, result);
        }
      }
    });
  }

  @override
  void dispose() {
    points.clear();
    connections.clear();

    super.dispose();
  }

  Future<void> openAddOnPacksBottomSheet(BuildContext context) async {
    setState(() => ignorePointer = true);

    final cubit = context.read<JettingTheWorldCubit>();

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: FractionallySizedBox(
            heightFactor: 0.55,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: JourneyRoutePopup(
                cubit: cubit,
                onClickButton: () {
                  setState(() => ignorePointer = false);
                },
              ),
            ),
          ),
        );
      },
    );

    if (mounted) {
      setState(() => ignorePointer = false);
    }
  }

  void updateGlobeFromApi(List<AirportPerItemModel> airports) {
    points.clear();
    connections.clear();

    isShowCurrentAirportIndex = 0;

    for (int i = 0; i < airports.length; i++) {
      final airport = airports[i];

      final point = buildPoint(
        id: airport.id.toString(),
        coordinates: GlobeCoordinates(airport.latitude, airport.longitude),
        label: airport.city,
        color: airport.current == true
            ? AppColors.greenColourForPlan
            : airport.unlocked == true
            ? AppColors.primaryBlue
            : AppColors.greyForTextfield,
      );

      points.add(point);

      if (airport.current == true) {
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
            isLastId: i == points.length - 2 ? points.last.id : '',
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
      if (points.length > 1 && isShowCurrentAirportIndex < points.length) {
        connections.add(
          PointConnection(
            start: points[isShowCurrentAirportIndex].coordinates,
            end: points[isShowCurrentAirportIndex].coordinates,
            curveScale: 0.5,
            id: '0',
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

    if (!kIsWeb) {
      loadPointsOnGlobe();
    }
  }

  String _buildWebUrl() {
    return widget.isComeFromResultScreen
        ? 'https://avionica.csdevhub.com/globe/'
        : 'https://avionica.csdevhub.com/globe/multi.html';
  }

  Future<void> _handleWebMessage(BuildContext context, dynamic data) async {
    final String message = data?.toString() ?? '';

    debugPrint('[JettingAroundTheWorld] Web message: $message');

    if (message == 'ViewYourJourney') {
      if (!mounted) return;
      openAddOnPacksBottomSheet(context);
    } else if (message == 'journeyAroundTheWorld') {
      await SharedPrefsHelper.clearJettingGames();
      if (!mounted) return;
      AppNavigator.push(
        context,
        JettingAroundBoardingPassesScreen(isComeFromResultScreen: true),
        multiBlocProviders: [
          BlocProvider(create: (_) => JettingBoardingPassCubit()),
        ],
        disableSwipeBack: true,
      );
    }
  }

  void loadPointsOnGlobe() {
    for (final point in points) {
      _controller.addPoint(point);

      GlobeControlsState.instance.addVisiblePoint(point.id);
    }

    GlobeControlsState.instance.setZoom(_controller.zoom);

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;

      startConnectionAnimation();
    });
  }

  Future<void> startConnectionAnimation() async {
    for (int i = 0; i < connections.length; i++) {
      if (!mounted) return;

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isSmallScreen = screenWidth < 800;

    final double radius = screenWidth < 500 ? ((screenWidth / 3.5) - 20) : 140;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Jetting Around The World',
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
      endDrawer: isSmallScreen ? null : null,
      body: BlocConsumer<JettingTheWorldCubit, JettingTheWorldState>(
        listenWhen: (previous, current) {
          return current.airportList.isNotEmpty && points.isEmpty;
        },
        listener: (context, state) {
          updateGlobeFromApi(state.airportList);

          if (kIsWeb) {
            if (!mounted) return;

            setState(() {
              _webUrl = _buildWebUrl();
            });
          } else {
            if (!mounted) return;

            setState(() {});
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (points.isEmpty) {
            return const Center(child: Text('No Data'));
          }

          return SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: kIsWeb
                      ? _buildWebGlobe()
                      : FlutterEarthGlobe(
                          controller: _controller,
                          radius: radius,
                        ),
                ),

                if (!kIsWeb) ...[_buildMobileOverlay(state)],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWebGlobe() {
    if (_webUrl.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebIframeWidget(
      url: _webUrl,
      ignorePointer: ignorePointer,
      onMessageReceived: (data) {
        _handleWebMessage(context, data);
      },
    );
  }

  Widget _buildMobileOverlay(JettingTheWorldState state) {
    return Stack(
      children: [
        Positioned(
          top: 15,
          left: 15,
          right: 15,
          child: Column(
            crossAxisAlignment: widget.isComeFromResultScreen
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: widget.isComeFromResultScreen
                    ? TextAlign.center
                    : TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.isComeFromResultScreen
                          ? 'Congratulations\n'
                          : 'Begin Your Adventure\n',
                      style: AppTextStyles.bold(
                        24,
                      ).copyWith(color: AppColors.white),
                    ),
                    const TextSpan(text: '\n', style: TextStyle(fontSize: 10)),
                    TextSpan(
                      text: widget.isComeFromResultScreen
                          ? 'You have Reached ${state.airportList.last.city}'
                          : 'Travel across the world, explore iconic airports, and earn Jettons as you progress.',
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
              constraints: const BoxConstraints(maxWidth: 900),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ReusableBottomButton(
                  backgroundColor: AppColors.greenColourForPlan,
                  fontStyle: AppTextStyles.regular(
                    18,
                  ).copyWith(height: 1.0, color: AppColors.black),
                  text: widget.isComeFromResultScreen
                      ? 'Journey around the world'
                      : 'View Your Journey',
                  onTap: () async {
                    if (widget.isComeFromResultScreen) {
                      await SharedPrefsHelper.clearJettingGames();

                      if (!mounted) return;

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
                      await openAddOnPacksBottomSheet(context);
                    }
                  },
                ),
              ),
            ),
          ),
        ),

        if (widget.isComeFromResultScreen)
          Positioned(
            bottom: 60,
            left: 15,
            right: 15,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: statCard(
                            value: '80',
                            label: 'Jettons earned as the\nFrequent Flyer',
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
    );
  }

  Widget statCard({required String value, required String label}) {
    return Container(
      width: 160,
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 20),
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
            child: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.successJettingYellowAround),
              height: 20,
              width: 20,
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
          SizedBox(height: label.contains('Total') ? 20 : 0),
        ],
      ),
    );
  }
}
