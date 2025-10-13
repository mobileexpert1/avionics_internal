import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Helpers/Custom_widget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_model.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_state.dart';
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

  @override
  void initState() {
    super.initState();
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
        } else if (state.airCraftDetails == null) {
          return const Scaffold(body: Center(child: Text("No data available")));
        }
        return Scaffold(
          appBar: CustomAppBar(
            title:
                "${state.airCraftDetails?.results.identification.icaoTypeCode ?? ''}"
                " , "
                "${state.airCraftDetails?.results.identification.aircraftModel ?? ''}",

            centerTitle: false,
            leftButton: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
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
                      content: _buildTechnicalData(
                        state.airCraftDetails?.results.identification,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "POWERPLANT & PROPULSION",
                      isExpanded: showPowerSection,
                      onToggle: () =>
                          setState(() => showPowerSection = !showPowerSection),
                      content: _buildPowerPlantData(
                        state.airCraftDetails?.results.powerplant,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "DIMENSIONS",
                      isExpanded: showDimensionSection,
                      onToggle: () => setState(
                        () => showDimensionSection = !showDimensionSection,
                      ),
                      content: _buildDimenionsData(
                        state.airCraftDetails?.results.dimensions,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "WEIGHTS",
                      isExpanded: showWeightsSection,
                      onToggle: () => setState(
                        () => showWeightsSection = !showWeightsSection,
                      ),
                      content: _buildWeightsData(
                        state.airCraftDetails?.results.weights,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "PERFORMANCE (ORDERED BY FLIGHT SEQUENCE)",
                      isExpanded: showPerformanceSection,
                      onToggle: () => setState(
                        () => showPerformanceSection = !showPerformanceSection,
                      ),
                      content: _builPerfomanceOrderedBYsData(
                        state.airCraftDetails?.results.performance,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "OPERATIONAL LIMITATIONS",
                      isExpanded: showOperationalSection,
                      onToggle: () => setState(
                        () => showOperationalSection = !showOperationalSection,
                      ),
                      content: _builOperationLimitationsData(
                        state.airCraftDetails?.results.operationalLimitations,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "LANDING GEAR",
                      isExpanded: showLandingSection,
                      onToggle: () => setState(
                        () => showLandingSection = !showLandingSection,
                      ),
                      content: _builLandingGearData(
                        state.airCraftDetails?.results.landingGear,
                      ),
                    ),

                    _buildExpandableSection(
                      title: "CERTIFICATION & ENVIRONMENTAL",
                      isExpanded: showCertificationSection,
                      onToggle: () => setState(
                        () => showCertificationSection =
                            !showCertificationSection,
                      ),
                      content: _builCertificationData(
                        state.airCraftDetails?.results.certification,
                      ),
                    ),

                    SizedBox(height: 50),
                  ],
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: double.infinity,
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ), // Internal padding
        child: Column(
          children: [
            _buildImageCoverScroller(screenHeight, aircraftData?.images ?? []),
            //Text(aircraftData?.identification.avionicsSystem ?? ""),
            const SizedBox(height: 10),
            _buildFlightDataSection(context),
          ],
        ),
      ),
    );
  }

  final fieldColor = const Color(0xFF3E3C55);
  Widget _buildTechnicalData(IdentificationClassification? detail) {
    if (detail == null) return const Text('No data available');
    final identification = detail;
    return _buildFieldRows(
      [
        ['ICAO Type Code', identification.icaoTypeCode],
        ['Aircraft Manufacturer', identification.manufacturer],
        ['Aircraft Model', identification.aircraftModel],
        ['Aircraft Role', identification.aircraftRole],
        ['Aircraft Type', identification.aircraftType],
        ['Wake Turbulence Category', identification.wakeTurbulenceCategory],
        [
          'Civilian / Military / Dual Use',
          identification.civilianMilitaryOrDualUse,
        ],
        ['Country of Origin', identification.countryOfOrigin],
        ['Date of Maiden Flight', identification.dateOfMaidenFlight],
        ['Year of Introduction', identification.yearOfIntroduction],
        ['Production Status', identification.productionStatus],
        ['Avionics System Name', identification.avionicsSystem],
        ['Number of Crew', identification.numberOfCrew],
        [
          'Number of Passengers (Typical)',
          identification.numberOfPassengers.typical,
        ],
        [
          'Number of Passengers (Maximum)',
          identification.numberOfPassengers.maximum,
        ],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildPowerPlantData(PowerplantPropulsion? detail) {
    if (detail == null) return const Text('No data available');
    final powerPlantDetails = detail;
    return _buildFieldRows(
      [
        ['Number of Engines', powerPlantDetails.numberOfEngines.toString()],
        ['Fuel Consumption', powerPlantDetails.fuel.burnRate],
        ['Manufacturer', powerPlantDetails.engine.manufacturer],
        ['Model', powerPlantDetails.engine.model],
        ['Engine Type', powerPlantDetails.engine.engineType],
        ['Thrust Per Engine (kN)', powerPlantDetails.engine.thrust],
        ['Physical Engine Code', powerPlantDetails.engine.physicalEngineCode],
        ['APU Type', powerPlantDetails.apuType],
        ['Fuel Type', powerPlantDetails.fuel.fuelType],
        ['Fuel Additives', powerPlantDetails.fuel.fuelAdditives],
        ['Fuel Capacity', powerPlantDetails.fuel.capacity],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildDimenionsData(Dimensions? detail) {
    if (detail == null) return const Text('No data available');
    final dimensionDetails = detail;
    return _buildFieldRows(
      [
        ['Wingspan (m)', dimensionDetails.wingspanM],
        ['Cabin Width (m)', dimensionDetails.cabinWidthM],
        ['Length (m)', dimensionDetails.lengthM],
        ['Wingtip Configuration', dimensionDetails.wingtipConfiguration],
        ['Height (m)', dimensionDetails.heightM],
        ['Wing Area (m2)', dimensionDetails.wingAreaM2],
        ['Door Height (m)', dimensionDetails.doorHeightM],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildWeightsData(Weights? detail) {
    if (detail == null) return const Text('No data available');
    final weightsDetails = detail;
    return _buildFieldRows(
      [
        ['Operating Empty Weight (kg)', weightsDetails.emptyWeight],
        ['Maximum Zero Fuel Weight (kg)', weightsDetails.zeroFuelWeight],
        ['Maximum Takeoff Weight (kg)', weightsDetails.takeoffWeight],
        ['Max Payload (kg)', weightsDetails.payload],
        ['Maximum Landing Weight (kg)', weightsDetails.landingWeight],
        [
          'Maximum Baggage or Cargo Volume (m3)',
          weightsDetails.baggage.maximum,
        ],
        [
          'Minimum Baggage or Cargo Volume (m3)',
          weightsDetails.baggage.minimum,
        ],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builPerfomanceOrderedBYsData(Performance? detail) {
    if (detail == null) return const Text('No data available');
    final performanceDetails = detail;
    return _buildFieldRows(
      [
        ['Takeoff Speed (kts)', performanceDetails.takeoffSpeedKts],
        ['Takeoff Distance (m)', performanceDetails.takeoffDistanceM],
        ['Initial Rate of Climb (fpm)', performanceDetails.climbInitialFpm],
        ['Average Rate of Climb (fpm)', performanceDetails.climbAvgFpm],
        ['Maximum Rate of Climb (fpm)', performanceDetails.climbMaxFpm],
        ['Service Ceiling (ft)', performanceDetails.serviceCeiling],
        [
          'Max Certified Altitude (ft)',
          performanceDetails.maxCertifiedAltitude,
        ],
        ['Cruise Speed (kt)', performanceDetails.cruiseSpeedKt],
        ['Cruise(Mach)', performanceDetails.cruiseMach],
        ['Maximum Speed', performanceDetails.maxCruiseSpeed],
        ['VMO (kts)', performanceDetails.vmoKts],
        ['MMO (Mach)', performanceDetails.mmoMach],

        [
          'Range (NM / km)',
          "${performanceDetails.range.normalRangeNm} NM / ${performanceDetails.range.normalRangeKm} Km",
        ],
        ['Ferry Range (if applicable)', performanceDetails.range.ferryRangeNm],
        ['Initial Rate of Descent (fpm)', performanceDetails.descentInitialFpm],
        ['Average Rate of Descent (fpm)', performanceDetails.descentAvgFpm],
        [
          'Minimum Clean Speed (kts)',
          performanceDetails.minCleanSpeed.toString(),
        ],
        ['Approach Speed (kts)', performanceDetails.approachSpeed],
        ['Approach Category', performanceDetails.approachCategory],
        ['Landing Speed (kts)', performanceDetails.landingSpeed],
        ['Landing Distance (m)', performanceDetails.landingDistance],
        ['Runway Length Required (m)', performanceDetails.runwayRequired],
        ['Stall Speed (kts)', performanceDetails.stallSpeed],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builOperationLimitationsData(OperationalLimitations? detail) {
    if (detail == null) return const Text('No data available');
    final operationalDetails = detail;
    return _buildFieldRows(
      [
        ['Runway Slope Limit percent', operationalDetails.runwaySlopeLimit],
        [
          'Max Crosswind Normal Law (kts)',
          operationalDetails.maxCrosswindNormal,
        ],
        [
          'Maximum Crosswind (Degraded Law)',
          operationalDetails.maxCrosswindDegraded,
        ],
        ['Max Tailwind Landing (kts)', operationalDetails.maxTailwindLanding],
        ['Max Tailwind Takeoff (kts)', operationalDetails.maxTailwindTakeoff],
        ['Field Elevation Limit (ft)', operationalDetails.fieldElevationLimit],
        ['Maximum Runway Altitude (ft)', operationalDetails.maxRunwayAltitude],
        ['Tailwind Limit (Flaps ≤10°)', operationalDetails.maxTailwindTakeoff],
        [
          'Supported Categories',
          operationalDetails.autoland.supportedCategories,
        ],
        [
          'Certified Autoland Level',
          operationalDetails.autoland.certifiedLevel,
        ],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builLandingGearData(LandingGear? detail) {
    if (detail == null) return const Text('No data available');
    final landingDetails = detail;
    return _buildFieldRows(
      [
        ['Landing Gear Configuration', landingDetails.type],
        ['Number of Wheels', landingDetails.numberOfWheels],
        ['Tyre Size (inches)', landingDetails.tyreSize],
        ['Tyre Pressure (psi)', landingDetails.tyrePressure],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _builCertificationData(CertificationEnvironmental? detail) {
    if (detail == null) return const Text('No data available');
    final certificationDetails = detail;
    return _buildFieldRows(
      [
        ['Certification Basis', certificationDetails.certificationBasis],
        ['Special Conditions', certificationDetails.specialConditions],
        ['Noise Compliance', certificationDetails.noiseCompliance],
        ['Emissions Category', certificationDetails.emissionsCategory],
        ['EASA TCDS Number', certificationDetails.easa],
        ['FAA TCDS Number', certificationDetails.faa],
      ],
      labelColor: fieldColor,
      valueColor: fieldColor,
    );
  }

  Widget _buildFlightDataSection(BuildContext context) {
    final flight = widget.flightDetail;
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
                  final groundSpeed = detail?.groundSpeed ?? 0;
                  final altitude = detail?.altitude ?? 0;

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

                      // 🧭 Flight Info
                      _buildFieldRows([
                        ['Call Sign', detail?.callsign ?? 'N/A'],
                        ['Flight Code', detail?.flightNumber ?? 'N/A'],
                        ['Squawk', detail?.squawk ?? 'N/A', true],
                        ['ADS-B Hex', detail?.hex ?? 'N/A', true],
                        [
                          'Latitude',
                          detail?.latitude.toString() ?? 'N/A',
                          true,
                        ],
                        [
                          'Longitude',
                          detail?.longitude.toString() ?? 'N/A',
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
                ['Altitude (ft)', flight.altitude?.toString() ?? 'N/A'],
                [
                  'Ground Speed (km/h)',
                  flight.groundSpeed?.toString() ?? 'N/A',
                  true,
                ],
                [
                  'Vertical Speed (ft/min)',
                  flight.vspeed?.toString() ?? 'N/A',
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
                ['Flight Duration', flight.flightTime ?? 'N/A', true],
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
