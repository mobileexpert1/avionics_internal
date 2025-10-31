import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Helpers/Custom_widget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_model.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_state.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../bloc/MapSection/flight_map_detailModel.dart';

class FlightDetailScreen extends StatefulWidget {
  final String ICAOType;
  final FlightAircraftDetail? flightDetail;

  const FlightDetailScreen({
    super.key,
    required this.ICAOType,
    this.flightDetail,
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

  @override
  void initState() {
    super.initState();
    _currentFlightDetail = widget.flightDetail;
    context.read<AirCraftDetailCubit>().fetchAircraftDetailByICAOCode(
      widget.ICAOType,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AirCraftDetailCubit, AirCraftDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final details = state.airCraftDetails?.results;
        return Scaffold(
          appBar: CustomAppBar(
            title: widget.flightDetail?.callsign ?? 'N/A',
            // " , ${widget.flightDetail?.aircraftModel ?? 'N/A'}",
            centerTitle: true,
            leftButton: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            rightButton: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () async {
                final flight = widget.flightDetail;
                if (flight == null) return;

                final flightMapCubit = context.read<FlightMapCubit>();

                await flightMapCubit.refreshFlightPosition(
                  flightNumber: flight.flightNumber ?? '',
                  context: context,
                );

                if (!mounted) return;

                final updatedFlightModel = flightMapCubit.state.selectedFlight;
                if (updatedFlightModel != null) {
                  setState(() {
                    _currentFlightDetail = FlightAircraftDetail(
                      flightNumber: updatedFlightModel.flightNumber,
                      latitude: updatedFlightModel.latitude,
                      longitude: updatedFlightModel.longitude,
                      altitude: updatedFlightModel.altitude,
                      groundSpeed: updatedFlightModel.groundSpeed,
                      vspeed: updatedFlightModel.verticalSpeed,
                      id: updatedFlightModel.id,

                      firstSeen: updatedFlightModel.firstSeen,
                      lastSeen: updatedFlightModel.lastSeen,
                      flightEnded: updatedFlightModel.flightEnded,
                      landingTime: updatedFlightModel.landingTime,
                    );
                  });
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
                child: Stack(

                  children: [
                    Column(

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
                          onToggle: () => setState(
                            () => showPowerSection = !showPowerSection,
                          ),
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
                            () => showPerformanceSection =
                                !showPerformanceSection,
                          ),
                          content: _builPerfomanceOrderedBYsData(
                            details?.performance,
                          ),
                        ),

                        _buildExpandableSection(
                          title: "OPERATIONAL LIMITATIONS",
                          isExpanded: showOperationalSection,
                          onToggle: () => setState(
                            () => showOperationalSection =
                                !showOperationalSection,
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
                          content: _builCertificationData(
                            details?.certification,
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
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
    if (coverImages.isEmpty) {
      return const SizedBox.shrink();
    }
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

          final hasCopyright = (image.cc).isNotEmpty;

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
            if (hasValidImages)
            _buildFlightDataSection(context),
            if (hasValidImages) const SizedBox(height: 10),
              _buildImageCoverScroller(screenHeight, aircraftData!.images!),
          ],
        ),
      ),
    );
  }

  final fieldColor = const Color(0xFF3E3C55);

  Widget _buildTechnicalData(IdentificationClassification? detail) {
    final flight = widget.flightDetail;
    return _buildFieldRows(
      [
        ['ICAO Type Code', detail?.icaoTypeCode ?? flight?.type ?? 'N/A'],
        ['Aircraft Manufacturer', detail?.manufacturer ?? 'N/A'],
        ['Aircraft Model', detail?.aircraftModel ?? 'N/A'],
        ['Aircraft Role', detail?.aircraftRole ?? 'N/A'],
        ['Aircraft Type', detail?.aircraftType ?? flight?.type ?? 'N/A'],
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
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildPowerPlantData(PowerplantPropulsion? detail) {
    return _buildFieldRows(
      [
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
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildDimenionsData(Dimensions? detail) {
    return _buildFieldRows(
      [
        ['Wingspan (m)', detail?.wingspanM ?? 'N/A'],
        ['Cabin Width (m)', detail?.cabinWidthM ?? 'N/A'],
        ['Length (m)', detail?.lengthM ?? 'N/A'],
        ['Wingtip Configuration', detail?.wingtipConfiguration ?? 'N/A'],
        ['Height (m)', detail?.heightM ?? 'N/A'],
        ['Wing Area (m²)', detail?.wingAreaM2 ?? 'N/A'],
        ['Door Height (m)', detail?.doorHeightM ?? 'N/A'],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildWeightsData(Weights? detail) {
    return _buildFieldRows(
      [
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
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builPerfomanceOrderedBYsData(Performance? detail) {
    return _buildFieldRows(
      [
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
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builOperationLimitationsData(OperationalLimitations? detail) {
    return _buildFieldRows(
      [
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
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builLandingGearData(LandingGear? detail) {
    return _buildFieldRows(
      [
        ['Landing Gear Configuration', detail?.type ?? 'N/A'],
        ['Number of Wheels', detail?.numberOfWheels ?? 'N/A'],
        ['Tyre Size (inches)', detail?.tyreSize ?? 'N/A'],
        ['Tyre Pressure (psi)', detail?.tyrePressure ?? 'N/A'],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builCertificationData(CertificationEnvironmental? detail) {
    return _buildFieldRows(
      [
        ['Certification Basis', detail?.certificationBasis ?? 'N/A'],
        ['Special Conditions', detail?.specialConditions ?? 'N/A'],
        ['Noise Compliance', detail?.noiseCompliance ?? 'N/A'],
        ['Emissions Category', detail?.emissionsCategory ?? 'N/A'],
        ['EASA TCDS Number', detail?.easa ?? 'N/A'],
        ['FAA TCDS Number', detail?.faa ?? 'N/A'],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildFlightDataSection(BuildContext context) {
    final flight = widget.flightDetail;
    final flight1 = _currentFlightDetail;
    if (flight == null) return const SizedBox.shrink();
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
              child: Builder(
                builder: (_) {
                  final detail = widget.flightDetail;
                  final detail1 = _currentFlightDetail;

                  DateTime? takeoffTime = detail?.takeoffTime;
                  DateTime? eta = detail?.eta;
                  String timeSinceTakeoff = 'N/A';
                  String timeToArrival = 'N/A';
                  double progress = 0.0;

                  String _formatDuration(Duration duration) {
                    final hours = duration.inHours;
                    final minutes = duration.inMinutes.remainder(60);
                    if (hours == 0 && minutes == 0) return '0 min';
                    if (hours == 0) return '$minutes min';
                    if (minutes == 0) return '${hours}h';
                    return '${hours}h ${minutes}min';
                  }

                  if (takeoffTime != null) {
                    final duration = DateTime.now().toUtc().difference(
                      takeoffTime,
                    );
                    timeSinceTakeoff = '${_formatDuration(duration)} ago';
                  }

                  if (eta != null) {
                    final duration = eta.difference(DateTime.now().toUtc());
                    timeToArrival = duration.isNegative
                        ? 'Landed'
                        : 'in ${_formatDuration(duration)}';
                  }

                  if (takeoffTime != null && eta != null) {
                    final takeoffMillis = takeoffTime.millisecondsSinceEpoch;
                    final etaMillis = eta.millisecondsSinceEpoch;
                    final nowMillis = DateTime.now()
                        .toUtc()
                        .millisecondsSinceEpoch;
                    final totalDuration = etaMillis - takeoffMillis;
                    final elapsed = nowMillis - takeoffMillis;
                    if (totalDuration > 0) {
                      progress = (elapsed / totalDuration).clamp(0.0, 1.0);
                    }
                  }

                  final departureCity = detail?.originAirport?.city ?? 'N/A';
                  final arrivalCity = detail?.destinationAirport?.city ?? 'N/A';
                  final departureIata = detail?.departureIcao ?? 'N/A';
                  final arrivalIata = detail?.arrivalIcao ?? 'N/A';
                  final groundSpeed = detail1?.groundSpeed ?? 0;
                  final altitude = detail1?.altitude ?? 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      groundSpeed == 0
                                          ? 'N/A'
                                          : '$groundSpeed km/h',
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
                                      altitude == 0 ? 'N/A' : '$altitude m',
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

                      _buildFieldRows([
                        ['Call Sign', detail?.callsign ?? 'N/A'],
                        ['Flight Code', detail?.flightNumber ?? 'N/A'],
                        ['Squawk', detail?.squawk ?? 'N/A', true],
                        ['ADS-B Hex', detail?.hex ?? 'N/A', true],
                        [
                          'Latitude',
                          detail1?.latitude.toString() ?? 'N/A',
                          true,
                        ],
                        [
                          'Longitude',
                          detail1?.longitude.toString() ?? 'N/A',
                          true,
                        ],
                        ['Registration', detail?.registration ?? 'N/A', true],
                        ['Data Source', detail?.source ?? 'N/A', true],
                      ]),
                    ],
                  );
                },
              ),
            ),
          const Divider(
            height: 0,
            color: AppColors.sepratorColourAppBar,
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
              child: _buildFieldRows([
                ['Track (degree)', flight.track?.toString() ?? 'N/A'],
                ['Altitude (ft)', flight1?.altitude?.toString() ?? 'N/A'],
                [
                  'Ground Speed (km/h)',
                  flight1?.groundSpeed?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Vertical Speed (ft/min)',
                  flight1?.vspeed?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Airport of Departure',
                  flight.originAirport?.city ?? 'N/A',
                  true,
                ],
                [
                  'Airport of Arrival',
                  flight.destinationAirport?.city ?? 'N/A',
                  true,
                ],
                [
                  'Take-off Time',
                  flight.takeoffTime != null
                      ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(flight.takeoffTime!.toLocal())} IST'
                      : 'N/A',
                  true,
                ],
                [
                  'Estimated Time of Arrival',
                  flight.eta != null
                      ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(flight.eta!.toLocal())} IST'
                      : 'N/A',
                  true,
                ],
                [
                  'Take-off Runway',
                  flight.takeoffRunway?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Landing Runway',
                  flight.landingRunway?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Actual ground distance (km)',
                  flight.actualDistance?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Circle distance (km)',
                  flight.circleDistance?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Flight Duration',
                  (flight.flightTime?.isNotEmpty ?? false)
                      ? flight.flightTime!
                      : 'N/A',
                  true,
                ],
                // ['Time Zone', 'InterGlobe Aviation Ltd',true],
                [
                  'Carrier Operating',
                  flight.operatingAs?.toString() ?? 'N/A',
                  true,
                ],
              ]),
            ),
          const Divider(
            height: 0,
            color: AppColors.sepratorColourAppBar,
            thickness: 3,
          ),

          // Tracking Status Section
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
              child: _buildFieldRows([
                ['First seen', flight.firstSeen?.toString() ?? 'N/A'],
                ['Last seen', flight.lastSeen?.toString() ?? 'N/A'],
                ['Landed', flight.flightEnded == true ? "Yes (Ended)" : "No"],
                ['Landing Time', flight.landingTime?.toString() ?? 'N/A'],
              ]),
            ),
          const Divider(
            height: 0,
            color: AppColors.sepratorColourAppBar,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (showBlueDot)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        isExpanded ? "Show Less" : "Show More",
                        style: TextStyle(fontSize: 13, color: textColor),
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
          color: AppColors.sepratorColourAppBar,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFieldRows(
    List<List<dynamic>> fields, {
    Color labelColor = Colors.white70,
    Color valueColor = Colors.white,
    List<int>? showInfoFields,
  }) {
    return Column(
      children: List.generate((fields.length / 2).ceil(), (i) {
        final first = fields[i * 2];
        final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: customField(
                  label: first[0],
                  text: first[1],
                  labelColor: labelColor,
                  textColor: valueColor,
                  showInfoIcon:
                      (first.length > 2 && first[2] == true) ||
                      (showInfoFields?.contains(i * 2) ?? false),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: second != null
                    ? customField(
                        label: second[0],
                        text: second[1],
                        labelColor: labelColor,
                        textColor: valueColor,
                        showInfoIcon:
                            (second.length > 2 && second[2] == true) ||
                            (showInfoFields?.contains(i * 2 + 1) ?? false),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }

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
          color: AppColors.sepratorColourAppBar,
          thickness: 3,
        ),
      ],
    );
  }
}
