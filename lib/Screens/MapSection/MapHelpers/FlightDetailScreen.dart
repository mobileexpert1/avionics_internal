import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Helpers/Custom_widget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_model.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_state.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/constantImages.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../bloc/MapSection/flight_map_detailModel.dart';
import '../../../bloc/MapSection/flight_map_repository.dart';

class FlightDetailScreen extends StatefulWidget {
  final String ICAOType;
  final FlightAircraftDetail? flightDetail;
  final bool fromSavedFlight;
  final String? flightNumber;
  final String? callsign;
  final String? flightId;

  const FlightDetailScreen({
    super.key,
    required this.ICAOType,
    this.flightDetail,
    this.fromSavedFlight = false,
    this.flightNumber,
    this.callsign,
    this.flightId,
  });

  @override
  State<FlightDetailScreen> createState() => _AirCraftDetailScreenState();
}

class _AirCraftDetailScreenState extends State<FlightDetailScreen> {
  bool showIdentification = true;
  bool showPowerSection = true;
  bool showDimensionSection = true;
  bool showWeightsSection = true;
  bool showPerformanceSection = true;
  bool showOperationalSection = true;
  bool showLandingSection = true;
  bool showCertificationSection = true;

  bool showIdentificationFlight = true;
  bool showFlightPlan = true;
  bool showTrackingStatus = true;

  FlightAircraftDetail? _currentFlightDetail;
  bool _isLoadingFullDetails = false;

  @override
  void initState() {
    super.initState();
    _currentFlightDetail = widget.flightDetail;

    // Always load static ICAO aircraft data
    context.read<AirCraftDetailCubit>().fetchAircraftDetailByICAOCode(
      widget.ICAOType,
      context,
    );

    // Only from Saved Flight → load full details + live refresh
    if (widget.fromSavedFlight) {
      _loadFullFlightDetailsFromSaved();
    }

    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.flightDetailScreen,
    );
  }

  Future<void> _loadFullFlightDetailsFromSaved() async {
    if (!widget.fromSavedFlight || _isLoadingFullDetails) return;

    final String? apiFlightId = widget.flightNumber ?? '';
    final String flightNumber = widget.flightId ?? '';

    if (apiFlightId == null || apiFlightId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Live data not available'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() => _isLoadingFullDetails = true);

    try {
      final now = DateTime.now().toUtc();
      final from = now.subtract(const Duration(hours: 24));
      final formattedFrom = '${from.toIso8601String().split('.').first}Z';
      final formattedTo = '${now.toIso8601String().split('.').first}Z';

      final response = await FlightRepository().getFlightDetails(
        flightId: apiFlightId,
        fromDateTime: formattedFrom,
        toDateTime: formattedTo,
        context: context,
      );

      if (response != null) {
        final fullFlightDetail =
            response['flightDetail'] as FlightAircraftDetail;

        final flightMapCubit = context.read<FlightMapCubit>();
        if (flightNumber.isNotEmpty) {
          await flightMapCubit.refreshFlightPosition(
            flightNumber: flightNumber,
            context: context,
          );
        }

        if (!mounted) return;

        final liveFlight = flightMapCubit.state.selectedFlight;
        FlightAircraftDetail mergedDetail = fullFlightDetail;

        if (liveFlight != null) {
          mergedDetail = fullFlightDetail.copyWith(
            // === LIVE POSITION ===
            latitude: liveFlight.latitude,
            longitude: liveFlight.longitude,
            altitude: liveFlight.altitude,
            groundSpeed: liveFlight.groundSpeed,
            vspeed: liveFlight.verticalSpeed,
            track: liveFlight.track,

            // === LIVE IDENTIFIERS (SAFE) ===
            callsign: liveFlight.callSign,
            squawk: liveFlight.squawk,
            source: liveFlight.source,
            hex: liveFlight.hex,

            // === LIVE TIMING ===
            firstSeen: liveFlight.firstSeen ?? fullFlightDetail.firstSeen,
            lastSeen: liveFlight.lastSeen ?? fullFlightDetail.lastSeen,
            flightEnded: liveFlight.flightEnded ?? fullFlightDetail.flightEnded,
            landingTime: liveFlight.landingTime ?? fullFlightDetail.landingTime,
            eta: liveFlight.eta ?? fullFlightDetail.eta,
            takeoffTime: liveFlight.takeoffTime ?? fullFlightDetail.takeoffTime,
            flightTime: liveFlight.flightTime ?? fullFlightDetail.flightTime,

            // === ICAO / IATA ===
            departureIcao: liveFlight.departureIcao,
            departureIata: liveFlight.departureIata,
            arrivalIcao: liveFlight.arrivalIcao,
            arrivalIata: liveFlight.arrivalIata,

            // === AIRCRAFT INFO ===
            registration: liveFlight.registration,
            type: liveFlight.type,
            paintedAs: liveFlight.paintedAs,
            operatingAs: liveFlight.operatingAs,

            // === DISTANCE / RUNWAY (API DATA) ===
            takeoffRunway: fullFlightDetail.takeoffRunway,
            landingRunway: fullFlightDetail.landingRunway,
            actualDistance: fullFlightDetail.actualDistance,
            circleDistance: fullFlightDetail.circleDistance,
          );
        }

        if (mounted) {
          setState(() {
            _currentFlightDetail = mergedDetail;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading full flight details: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Live data not available')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingFullDetails = false);
      }
    }
  }

  // /// Fetches full flight details + live position and merges them
  // Future<void> _loadFullFlightDetailsFromSaved() async {
  //   if (!widget.fromSavedFlight || _isLoadingFullDetails) return;
  //   // final flightId = widget.flightNumber ?? widget.flightId;
  //   final flightId = widget.flightNumber;
  //   final flightNumber = widget.flightId ?? '';
  //   if (flightId == null || flightId.isEmpty) return;
  //
  //   setState(() => _isLoadingFullDetails = true);
  //
  //   try {
  //     final now = DateTime.now().toUtc();
  //     final from = now.subtract(const Duration(hours: 24));
  //     final formattedFrom = from.toIso8601String().split('.').first + 'Z';
  //     final formattedTo = now.toIso8601String().split('.').first + 'Z';
  //
  //     final response = await FlightRepository().getFlightDetails(
  //       flightId: flightId,
  //       fromDateTime: formattedFrom,
  //       toDateTime: formattedTo,
  //     );
  //
  //     final fullFlightDetail = response['flightDetail'] as FlightAircraftDetail;
  //
  //     // Refresh live position
  //     final flightMapCubit = context.read<FlightMapCubit>();
  //     await flightMapCubit.refreshFlightPosition(
  //       flightNumber: flightNumber,
  //       context: context,
  //     );
  //
  //     if (!mounted) return;
  //
  //     final liveFlight = flightMapCubit.state.selectedFlight;
  //     FlightAircraftDetail mergedDetail = fullFlightDetail;
  //
  //     if (liveFlight != null) {
  //       mergedDetail = fullFlightDetail.copyWith(
  //         // === LIVE POSITION ===
  //         latitude: liveFlight.latitude,
  //         longitude: liveFlight.longitude,
  //         altitude: liveFlight.altitude,
  //         groundSpeed: liveFlight.groundSpeed,
  //         vspeed: liveFlight.verticalSpeed,
  //         track: liveFlight.track,
  //
  //         // === LIVE IDENTIFIERS ===
  //         callsign: liveFlight.callSign ?? fullFlightDetail.callsign,
  //         squawk: liveFlight.squawk ?? fullFlightDetail.squawk,
  //         source: liveFlight.source ?? fullFlightDetail.source,
  //         hex: liveFlight.hex ?? fullFlightDetail.hex,
  //
  //         // === LIVE TIMING ===
  //         firstSeen: liveFlight.firstSeen ?? fullFlightDetail.firstSeen,
  //         lastSeen: liveFlight.lastSeen ?? fullFlightDetail.lastSeen,
  //         flightEnded: liveFlight.flightEnded ?? fullFlightDetail.flightEnded,
  //         landingTime: liveFlight.landingTime ?? fullFlightDetail.landingTime,
  //         eta: liveFlight.eta ?? fullFlightDetail.eta,
  //         takeoffTime: liveFlight.takeoffTime ?? fullFlightDetail.takeoffTime,
  //         flightTime: liveFlight.flightTime ?? fullFlightDetail.flightTime,
  //
  //         // // === FULL AIRPORT OBJECTS (CRITICAL!) ===
  //         // originAirport: liveFlight.originAirport ?? fullFlightDetail.originAirport,
  //         // destinationAirport: liveFlight.destinationAirport ?? fullFlightDetail.destinationAirport,
  //
  //         // === ICAO/IATA (backup) ===
  //         departureIcao:
  //             liveFlight.departureIcao ?? fullFlightDetail.departureIcao,
  //         departureIata:
  //             liveFlight.departureIata ?? fullFlightDetail.departureIata,
  //         arrivalIcao: liveFlight.arrivalIcao ?? fullFlightDetail.arrivalIcao,
  //         arrivalIata: liveFlight.arrivalIata ?? fullFlightDetail.arrivalIata,
  //
  //         // === AIRCRAFT INFO ===
  //         registration:
  //             liveFlight.registration ?? fullFlightDetail.registration,
  //         type: liveFlight.type ?? fullFlightDetail.type,
  //         paintedAs: liveFlight.paintedAs ?? fullFlightDetail.paintedAs,
  //         operatingAs: liveFlight.operatingAs ?? fullFlightDetail.operatingAs,
  //
  //         // === RUNWAYS & DISTANCE (from full API) ===
  //         takeoffRunway: fullFlightDetail.takeoffRunway,
  //         landingRunway: fullFlightDetail.landingRunway,
  //         actualDistance: fullFlightDetail.actualDistance,
  //         circleDistance: fullFlightDetail.circleDistance,
  //       );
  //     }
  //
  //     if (mounted) {
  //       setState(() {
  //         _currentFlightDetail = mergedDetail;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Error loading full flight details: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to load full details: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoadingFullDetails = false);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AirCraftDetailCubit, AirCraftDetailState>(
      builder: (context, state) {
        // Show loading for static aircraft data
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final details = state.airCraftDetails?.results;

        return Scaffold(
          appBar: CustomAppBar(
            title: _currentFlightDetail?.callsign?.isNotEmpty ?? false
                ? _currentFlightDetail!.callsign!
                : widget.callsign?.isNotEmpty ?? false
                ? widget.callsign!
                : 'N/A',
            centerTitle: true,
            leftButton: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.backArrowButton),
                fit: BoxFit.cover,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            rightButton: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () async {
                if (widget.fromSavedFlight) {
                  await _loadFullFlightDetailsFromSaved();
                } else {
                  final flightNumber = widget.flightDetail?.flightNumber ?? '';
                  if (flightNumber.isNotEmpty) {
                    await context.read<FlightMapCubit>().refreshFlightPosition(
                      flightNumber: flightNumber,
                      context: context,
                    );
                    if (mounted) {
                      final live = context
                          .read<FlightMapCubit>()
                          .state
                          .selectedFlight;
                      if (live != null) {
                        setState(() {
                          _currentFlightDetail = _currentFlightDetail?.copyWith(
                            latitude: live.latitude,
                            longitude: live.longitude,
                            altitude: live.altitude,
                            groundSpeed: live.groundSpeed,
                            vspeed: live.verticalSpeed,
                            track: live.track,
                            callsign: live.callSign,
                            squawk: live.squawk,
                            source: live.source,
                            firstSeen: live.firstSeen,
                            lastSeen: live.lastSeen,
                            flightEnded: live.flightEnded,
                            landingTime: live.landingTime,
                            eta: live.eta,
                          );
                        });
                      }
                    }
                  }
                }
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: kIsWeb ? 1500 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeadingDetails(screenHeight),

                    _buildExpandableSection(
                      title: "IDENTIFICATION & CLASSIFICATION",
                      isExpanded: showIdentification,
                      onToggle: () => setState(
                        () => showIdentification = !showIdentification,
                      ),
                      content: _buildTechnicalData(details?.identification),
                    ),

                    _buildExpandableSection(
                      title: "POWERPLANT & PROPULSION",
                      isExpanded: showPowerSection,
                      onToggle: () =>
                          setState(() => showPowerSection = !showPowerSection),
                      content: _buildPowerPlantData(details?.powerplant),
                    ),

                    _buildExpandableSection(
                      title: "DIMENSIONS",
                      isExpanded: showDimensionSection,
                      onToggle: () => setState(
                        () => showDimensionSection = !showDimensionSection,
                      ),
                      content: _buildDimenionsData(details?.dimensions),
                    ),

                    _buildExpandableSection(
                      title: "WEIGHTS",
                      isExpanded: showWeightsSection,
                      onToggle: () => setState(
                        () => showWeightsSection = !showWeightsSection,
                      ),
                      content: _buildWeightsData(details?.weights),
                    ),

                    _buildExpandableSection(
                      title: "PERFORMANCE (ORDERED BY FLIGHT SEQUENCE)",
                      isExpanded: showPerformanceSection,
                      onToggle: () => setState(
                        () => showPerformanceSection = !showPerformanceSection,
                      ),
                      content: _builPerfomanceOrderedBYsData(
                        details?.performance,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "OPERATIONAL LIMITATIONS",
                      isExpanded: showOperationalSection,
                      onToggle: () => setState(
                        () => showOperationalSection = !showOperationalSection,
                      ),
                      content: _builOperationLimitationsData(
                        details?.operationalLimitations,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "LANDING GEAR",
                      isExpanded: showLandingSection,
                      onToggle: () => setState(
                        () => showLandingSection = !showLandingSection,
                      ),
                      content: _builLandingGearData(details?.landingGear),
                    ),

                    _buildExpandableSection(
                      title: "CERTIFICATION & ENVIRONMENTAL",
                      isExpanded: showCertificationSection,
                      onToggle: () => setState(
                        () => showCertificationSection =
                            !showCertificationSection,
                      ),
                      content: _builCertificationData(details?.certification),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCoverScroller(
    double screenHeight,
    List<AircraftImage> coverImages,
  ) {
    if (coverImages.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: screenHeight * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: coverImages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final image = coverImages[index];
          final isSingleImage = coverImages.length == 1;
          final imageWidth = isSingleImage
              ? MediaQuery.of(context).size.width - 30
              : 300.0;
          final imagePadding = isSingleImage
              ? const EdgeInsets.symmetric(horizontal: 0)
              : const EdgeInsets.only(right: 10);
          final hasCopyright = image.cc.isNotEmpty;

          return Padding(
            padding: imagePadding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Image.network(
                    image.url,
                    width: imageWidth,
                    height: screenHeight * 0.18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: imageWidth,
                      height: screenHeight * 0.18,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                  if (hasCopyright)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.tryParse(image.source);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not open URL.'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          constraints: const BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '© ${image.cc}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopHeadingDetails(double screenHeight) {
    final aircraftData = context
        .read<AirCraftDetailCubit>()
        .state
        .airCraftDetails
        ?.results;
    final hasValidImages =
        aircraftData?.images != null && aircraftData!.images!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: double.infinity,
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            if (hasValidImages && _currentFlightDetail != null)
              _buildFlightDataSection(context),
            if (hasValidImages) const SizedBox(height: 10),
            if (hasValidImages)
              _buildImageCoverScroller(screenHeight, aircraftData!.images!),
          ],
        ),
      ),
    );
  }

  final fieldColor = const Color(0xFF3E3C55);

  Widget _buildTechnicalData(IdentificationClassification? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        [
          'ICAO Type Code',
          detail?.icaoTypeCode ?? _currentFlightDetail?.type ?? 'N/A',
        ],
        ['Aircraft Manufacturer', detail?.manufacturer ?? 'N/A'],
        ['Aircraft Model', detail?.aircraftModel ?? 'N/A'],
        ['Aircraft Role', detail?.aircraftRole ?? 'N/A'],
        [
          'Aircraft Type',
          detail?.aircraftType ?? _currentFlightDetail?.type ?? 'N/A',
        ],
        ['Wake Turbulence Category', detail?.wakeTurbulenceCategory ?? 'N/A'],
        [
          'Civilian / Military / Dual Use',
          detail?.civilianMilitaryOrDualUse ?? 'N/A',
        ],
        ['Country of Origin', detail?.countryOfOrigin ?? 'N/A'],
        ['Date of Maiden Flight', detail?.dateOfMaidenFlight ?? 'N/A'],
        ['Year of Introduction', detail?.yearOfIntroduction ?? 'N/A'],
        ['Production Status', detail?.productionStatus ?? 'N/A'],
        ['Avionics System Name', detail?.avionicsSystem ?? 'N/A'],
        ['Number of Crew', detail?.numberOfCrew ?? 'N/A'],
        [
          'Number of Passengers (Typical)',
          detail?.numberOfPassengers?.typical ?? 'N/A',
        ],
        [
          'Number of Passengers (Maximum)',
          detail?.numberOfPassengers?.maximum ?? 'N/A',
        ],
      ],
      context: context,
    );
  }

  Widget _buildPowerPlantData(PowerplantPropulsion? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Number of Engines', detail?.numberOfEngines?.toString() ?? 'N/A'],
        ['Fuel Consumption', detail?.fuel?.burnRate ?? 'N/A'],
        ['Manufacturer', detail?.engine?.manufacturer ?? 'N/A'],
        ['Model', detail?.engine?.model ?? 'N/A'],
        ['Engine Type', detail?.engine?.engineType ?? 'N/A'],
        ['Thrust Per Engine (kN)', detail?.engine?.thrust ?? 'N/A'],
        ['Physical Engine Code', detail?.engine?.physicalEngineCode ?? 'N/A'],
        ['APU Type', detail?.apuType ?? 'N/A'],
        ['Fuel Type', detail?.fuel?.fuelType ?? 'N/A'],
        ['Fuel Additives', detail?.fuel?.fuelAdditives ?? 'N/A'],
        ['Fuel Capacity', detail?.fuel?.capacity ?? 'N/A'],
      ],
      context: context,
    );
  }

  Widget _buildDimenionsData(Dimensions? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Wingspan (m)', detail?.wingspanM ?? 'N/A'],
        ['Cabin Width (m)', detail?.cabinWidthM ?? 'N/A'],
        ['Length (m)', detail?.lengthM ?? 'N/A'],
        ['Wingtip Configuration', detail?.wingtipConfiguration ?? 'N/A'],
        ['Height (m)', detail?.heightM ?? 'N/A'],
        ['Wing Area (m²)', detail?.wingAreaM2 ?? 'N/A'],
        ['Door Height (m)', detail?.doorHeightM ?? 'N/A'],
      ],
      context: context,
    );
  }

  Widget _buildWeightsData(Weights? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Operating Empty Weight (kg)', detail?.emptyWeight ?? 'N/A'],
        ['Maximum Zero Fuel Weight (kg)', detail?.zeroFuelWeight ?? 'N/A'],
        ['Maximum Takeoff Weight (kg)', detail?.takeoffWeight ?? 'N/A'],
        ['Max Payload (kg)', detail?.payload ?? 'N/A'],
        ['Maximum Landing Weight (kg)', detail?.landingWeight ?? 'N/A'],
        [
          'Maximum Baggage or Cargo Volume (m³)',
          detail?.baggage?.maximum ?? 'N/A',
        ],
        [
          'Minimum Baggage or Cargo Volume (m³)',
          detail?.baggage?.minimum ?? 'N/A',
        ],
      ],
      context: context,
    );
  }

  Widget _builPerfomanceOrderedBYsData(Performance? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Takeoff Speed (kts)', detail?.takeoffSpeedKts ?? 'N/A'],
        ['Takeoff Distance (m)', detail?.takeoffDistanceM ?? 'N/A'],
        ['Initial Rate of Climb (fpm)', detail?.climbInitialFpm ?? 'N/A'],
        ['Average Rate of Climb (fpm)', detail?.climbAvgFpm ?? 'N/A'],
        ['Maximum Rate of Climb (fpm)', detail?.climbMaxFpm ?? 'N/A'],
        ['Service Ceiling (ft)', detail?.serviceCeiling ?? 'N/A'],
        ['Max Certified Altitude (ft)', detail?.maxCertifiedAltitude ?? 'N/A'],
        ['Cruise Speed (kt)', detail?.cruiseSpeedKt ?? 'N/A'],
        ['Cruise (Mach)', detail?.cruiseMach ?? 'N/A'],
        ['Maximum Speed', detail?.maxCruiseSpeed ?? 'N/A'],
        ['VMO (kts)', detail?.vmoKts ?? 'N/A'],
        ['MMO (Mach)', detail?.mmoMach ?? 'N/A'],
        [
          'Range (NM / km)',
          "${detail?.range?.normalRangeNm ?? 'N/A'} NM / ${detail?.range?.normalRangeKm ?? 'N/A'} Km",
        ],
        ['Ferry Range (if applicable)', detail?.range?.ferryRangeNm ?? 'N/A'],
        ['Initial Rate of Descent (fpm)', detail?.descentInitialFpm ?? 'N/A'],
        ['Average Rate of Descent (fpm)', detail?.descentAvgFpm ?? 'N/A'],
        ['Minimum Clean Speed (kts)', detail?.minCleanSpeed ?? 'N/A'],
        ['Approach Speed (kts)', detail?.approachSpeed ?? 'N/A'],
        ['Approach Category', detail?.approachCategory ?? 'N/A'],
        ['Landing Speed (kts)', detail?.landingSpeed ?? 'N/A'],
        ['Landing Distance (m)', detail?.landingDistance ?? 'N/A'],
        ['Runway Length Required (m)', detail?.runwayRequired ?? 'N/A'],
        ['Stall Speed (kts)', detail?.stallSpeed ?? 'N/A'],
      ],
      context: context,
    );
  }

  Widget _builOperationLimitationsData(OperationalLimitations? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Runway Slope Limit (%)', detail?.runwaySlopeLimit ?? 'N/A'],
        ['Max Crosswind Normal Law (kts)', detail?.maxCrosswindNormal ?? 'N/A'],
        [
          'Maximum Crosswind (Degraded Law)',
          detail?.maxCrosswindDegraded ?? 'N/A',
        ],
        ['Max Tailwind Landing (kts)', detail?.maxTailwindLanding ?? 'N/A'],
        ['Max Tailwind Takeoff (kts)', detail?.maxTailwindTakeoff ?? 'N/A'],
        ['Field Elevation Limit (ft)', detail?.fieldElevationLimit ?? 'N/A'],
        ['Maximum Runway Altitude (ft)', detail?.maxRunwayAltitude ?? 'N/A'],
        ['Tailwind Limit (Flaps ≤10°)', detail?.maxTailwindTakeoff ?? 'N/A'],
        [
          'Supported Categories',
          detail?.autoland?.supportedCategories ?? 'N/A',
        ],
        ['Certified Autoland Level', detail?.autoland?.certifiedLevel ?? 'N/A'],
      ],
      context: context,
    );
  }

  Widget _builLandingGearData(LandingGear? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Landing Gear Configuration', detail?.type ?? 'N/A'],
        ['Number of Wheels', detail?.numberOfWheels ?? 'N/A'],
        ['Tyre Size (inches)', detail?.tyreSize ?? 'N/A'],
        ['Tyre Pressure (psi)', detail?.tyrePressure ?? 'N/A'],
      ],
      context: context,
    );
  }

  Widget _builCertificationData(CertificationEnvironmental? detail) {
    return customFieldForTextAndValue(
      false,
      fields: [
        ['Certification Basis', detail?.certificationBasis ?? 'N/A'],
        ['Special Conditions', detail?.specialConditions ?? 'N/A'],
        ['Noise Compliance', detail?.noiseCompliance ?? 'N/A'],
        ['Emissions Category', detail?.emissionsCategory ?? 'N/A'],
        ['EASA TCDS Number', detail?.easa ?? 'N/A'],
        ['FAA TCDS Number', detail?.faa ?? 'N/A'],
      ],
      context: context,
    );
  }

  Widget _buildFlightDataSection(BuildContext context) {
    final flight = _currentFlightDetail;
    if (flight == null) return const SizedBox.shrink();

    // === Extract Data ===
    final departureCity = flight.originAirport?.city ?? 'N/A';
    final arrivalCity = flight.destinationAirport?.city ?? 'N/A';
    final departureIata = flight.departureIcao ?? 'N/A';
    final arrivalIata = flight.arrivalIcao ?? 'N/A';
    final groundSpeed = flight.groundSpeed ?? 0;
    final altitude = flight.altitude ?? 0;

    // === Progress & Time ===
    DateTime? takeoffTime = flight.takeoffTime;
    DateTime? eta = flight.eta;
    String timeSinceTakeoff = 'N/A';
    String timeToArrival = 'N/A';
    double progress = 0.0;

    String _formatDuration(Duration d) {
      final h = d.inHours;
      final m = d.inMinutes % 60;
      if (h == 0 && m == 0) return '0 min';
      if (h == 0) return '$m min';
      if (m == 0) return '${h}h';
      return '${h}h ${m}min';
    }

    if (takeoffTime != null) {
      final duration = DateTime.now().toUtc().difference(takeoffTime);
      timeSinceTakeoff = duration.isNegative
          ? 'N/A'
          : '${_formatDuration(duration)} ago';
    }

    if (eta != null) {
      final duration = eta.difference(DateTime.now().toUtc());
      timeToArrival = duration.isNegative
          ? 'Landed'
          : 'in ${_formatDuration(duration)}';
    }

    if (takeoffTime != null && eta != null) {
      final total = eta.difference(takeoffTime).inMilliseconds;
      final elapsed = DateTime.now()
          .toUtc()
          .difference(takeoffTime)
          .inMilliseconds;
      if (total > 0) progress = (elapsed / total).clamp(0.0, 1.0);
    }

    return Container(
      color: const Color(0xFF3E3C55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: "IDENTIFICATION & POSITION",
            isExpanded: showIdentificationFlight,
            onTap: () => setState(
              () => showIdentificationFlight = !showIdentificationFlight,
            ),
            showBlueDot: true,
          ),
          if (showIdentificationFlight)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            departureCity,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            departureIata,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            timeSinceTakeoff,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey.shade300,
                                color: Colors.blue,
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$groundSpeed kts',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "•",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$altitude m',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            arrivalCity,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            arrivalIata,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            timeToArrival,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  customFieldForTextAndValue(
                    true,
                    fields: [
                      ['Call Sign', flight.callsign ?? 'N/A'],
                      ['Flight Code', flight.flightNumber ?? 'N/A'],
                      ['Squawk', flight.squawk ?? 'N/A'],
                      ['ADS-B Hex', flight.hex ?? 'N/A'],
                      [
                        'Latitude',
                        flight.latitude?.toStringAsFixed(6) ?? 'N/A',
                      ],
                      [
                        'Longitude',
                        flight.longitude?.toStringAsFixed(6) ?? 'N/A',
                      ],
                      ['Registration', flight.registration ?? 'N/A'],
                      ['Data Source', flight.source ?? 'N/A'],
                    ],
                    context: context,
                  ),
                ],
              ),
            ),
          const Divider(
            height: 0,
            color: AppColors.separatorColourAppBar,
            thickness: 3,
          ),

          _buildSectionHeader(
            title: "FLIGHT PLAN",
            isExpanded: showFlightPlan,
            onTap: () => setState(() => showFlightPlan = !showFlightPlan),
            showBlueDot: true,
          ),
          if (showFlightPlan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: customFieldForTextAndValue(
                true,
                fields: [
                  ['Track (degree)', flight.track?.toString() ?? 'N/A'],
                  ['Altitude (ft)', flight.altitude?.toString() ?? 'N/A'],
                  [
                    'Ground Speed (kts)',
                    flight.groundSpeed?.toString() ?? 'N/A',
                  ],
                  [
                    'Vertical Speed (ft/min)',
                    flight.vspeed?.toString() ?? 'N/A',
                  ],
                  ['Airport of Departure', flight.originAirport?.city ?? 'N/A'],
                  [
                    'Airport of Arrival',
                    flight.destinationAirport?.city ?? 'N/A',
                  ],
                  [
                    'Take-off Time',
                    flight.takeoffTime != null
                        ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(flight.takeoffTime!.toLocal())} IST'
                        : 'N/A',
                  ],
                  [
                    'Estimated Time of Arrival',
                    flight.eta != null
                        ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(flight.eta!.toLocal())} IST'
                        : 'N/A',
                  ],
                  [
                    'Take-off Runway',
                    flight.takeoffRunway?.toString() ?? 'N/A',
                  ],
                  ['Landing Runway', flight.landingRunway?.toString() ?? 'N/A'],
                  [
                    'Actual ground distance (km)',
                    flight.actualDistance?.toString() ?? 'N/A',
                  ],
                  [
                    'Circle distance (km)',
                    flight.circleDistance?.toString() ?? 'N/A',
                  ],
                  ['Flight Duration', flight.flightTime ?? 'N/A'],
                  ['Carrier Operating', flight.operatingAs ?? 'N/A'],
                ],
                context: context,
              ),
            ),
          const Divider(
            height: 0,
            color: AppColors.separatorColourAppBar,
            thickness: 3,
          ),

          _buildSectionHeader(
            title: "TRACKING STATUS",
            isExpanded: showTrackingStatus,
            onTap: () =>
                setState(() => showTrackingStatus = !showTrackingStatus),
            showBlueDot: true,
          ),
          if (showTrackingStatus)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: customFieldForTextAndValue(
                true,
                fields: [
                  ['First seen', flight.firstSeen?.toString() ?? 'N/A'],
                  ['Last seen', flight.lastSeen?.toString() ?? 'N/A'],
                  ['Landed', flight.flightEnded == true ? "Yes (Ended)" : "No"],
                  ['Landing Time', flight.landingTime?.toString() ?? 'N/A'],
                ],
                context: context,
              ),
            ),
          const Divider(
            height: 0,
            color: AppColors.separatorColourAppBar,
            thickness: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    Color textColor = Colors.white,
    bool showBlueDot = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showBlueDot)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8, top: 4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            title.toUpperCase(),
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// RIGHT SIDE (UNCHANGED ALIGNMENT)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isExpanded ? "Show Less" : "Show More",
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 0,
          color: AppColors.separatorColourAppBar,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void showAutoDismissDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        // Future.delayed(const Duration(seconds: 3), () {
        //   if (Navigator.of(context).canPop()) {
        //     Navigator.of(context).pop();
        //   }
        // });

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18, // 👈 CUSTOM TITLE FONT SIZE
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildFieldRows(
  //   List<List<dynamic>> fields, {
  //   Color labelColor = Colors.white70,
  //   Color valueColor = Colors.white,
  //   List<int>? showInfoFields,
  // }) {
  //   return Column(
  //     children: List.generate((fields.length / 2).ceil(), (i) {
  //       final first = fields[i * 2];
  //       final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;
  //
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 15),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: customField(
  //                 label: first[0],
  //                 text: first[1],
  //                 labelColor: labelColor,
  //                 textColor: valueColor,
  //                 showInfoIcon:
  //                     (first.length > 2 && first[2] == true) ||
  //                     (showInfoFields?.contains(i * 2) ?? false),
  //                 onInfoTap: () {
  //                   showAutoDismissDialog(context, first[0], first[1]);
  //                 },
  //               ),
  //             ),
  //             const SizedBox(width: 15),
  //             Expanded(
  //               child: second != null
  //                   ? customField(
  //                       label: second[0],
  //                       text: second[1],
  //                       labelColor: labelColor,
  //                       textColor: valueColor,
  //                       showInfoIcon:
  //                           (second.length > 2 && second[2] == true) ||
  //                           (showInfoFields?.contains(i * 2 + 1) ?? false),
  //                       onInfoTap: () {
  //                         showAutoDismissDialog(context, second[0], second[1]);
  //                       },
  //                     )
  //                   : const SizedBox(),
  //             ),
  //           ],
  //         ),
  //       );
  //     }),
  //   );
  // }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
    Color headerColor = const Color(0xFF3F3D56),
  }) {
    return Column(
      children: [
        _buildSectionHeader(
          title: title,
          isExpanded: isExpanded,
          onTap: onToggle,
          textColor: headerColor,
        ),
        isExpanded
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: content,
              )
            : const SizedBox.shrink(),
        const Divider(
          height: 0,
          color: AppColors.separatorColourAppBar,
          thickness: 3,
        ),
      ],
    );
  }
}
