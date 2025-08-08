import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Helpers/Custom_widget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_model.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_state.dart';

class AirCraftDetailScreen extends StatefulWidget {
  final String aircraftId;

  const AirCraftDetailScreen({super.key, required this.aircraftId});

  @override
  State<AirCraftDetailScreen> createState() => _AirCraftDetailScreenState();
}

class _AirCraftDetailScreenState extends State<AirCraftDetailScreen> {
  bool showIdentification = true;
  bool showPowerSection = true;
  bool showDimensionSection = true;

  bool showWeightsSection = true;
  bool showPerformanceSection = true;
  bool showOperationalSection = true;
  bool showLandingSection = true;
  bool showCertificationSection = true;

  @override
  void initState() {
    super.initState();
    context.read<AirCraftDetailCubit>().fetchAircraftDetailById(
      widget.aircraftId,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AirCraftDetailCubit, AirCraftDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: CustomAppBar(
            title:
                state.airCraftDetails?.results.identification.aircraftModel ??
                "",
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

                    //------------------------------------------------------------------------------------------------------------------------
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

                    //------------------------------------------------------------------------------------------------------------------------
                    _buildExpandableSection(
                      title: "POWERPLANT & PROPULSION",
                      isExpanded: showPowerSection,
                      onToggle: () =>
                          setState(() => showPowerSection = !showPowerSection),
                      content: _buildPowerPlantData(
                        state.airCraftDetails?.results.powerplant,
                      ),
                    ),

                    //------------------------------------------------------------------------------------------------------------------------
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

                    //------------------------------------------------------------------------------------------------------------------------
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

                    //------------------------------------------------------------------------------------------------------------------------
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

                    //------------------------------------------------------------------------------------------------------------------------
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

                    //------------------------------------------------------------------------------------------------------------------------
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

                    //------------------------------------------------------------------------------------------------------------------------
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
                    // ------------------------------------------------------------------------------------------------------------------------
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
          final imageUrl = coverImages[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl.url,
                    width: 300,
                    height: screenHeight * 0.18,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 300,
                      height: screenHeight * 0.18,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),

                  if (imageUrl.cc != "")
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final uri = Uri.tryParse(imageUrl.source);
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
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            imageUrl.cc,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
            //const SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(
            //       child: customField(
            //         label: 'ICAO type /APC',
            //         text: aircraftData?.identification.icaoTypeCode ?? "",
            //         isDarkDivider: true,
            //       ),
            //     ),
            //     const SizedBox(width: 15),
            //     Expanded(
            //       child: customField(
            //         label: 'Manufacturer',
            //         text: aircraftData?.identification.manufacturer ?? "",
            //         isDarkDivider: true,
            //       ),
            //     ),
            //     const SizedBox(width: 15),
            //     Expanded(
            //       child: customField(
            //         label: 'WTC',
            //         text:
            //             aircraftData?.identification.wakeTurbulenceCategory ??
            //             "",
            //         isDarkDivider: true,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 15),
            _buildImageCoverScroller(screenHeight, aircraftData?.images ?? []),
            const SizedBox(height: 15),
            //Text(aircraftData?.identification.avionicsSystem ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalData(IdentificationClassification? detail) {
    if (detail == null) return const Text('No data available');
    final identification = detail;
    return _buildFieldRows([
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
    ]);
  }

  Widget _buildPowerPlantData(PowerplantPropulsion? detail) {
    if (detail == null) return const Text('No data available');
    final powerPlantDetails = detail;
    return _buildFieldRows([
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
    ]);
  }

  Widget _buildDimenionsData(Dimensions? detail) {
    if (detail == null) return const Text('No data available');
    final dimensionDetails = detail;
    return _buildFieldRows([
      ['Wingspan (m)', dimensionDetails.wingspanM],
      ['Cabin Width (m)', dimensionDetails.cabinWidthM],
      ['Length (m)', dimensionDetails.lengthM],
      ['Wingtip Configuration', dimensionDetails.wingtipConfiguration],
      ['Height (m)', dimensionDetails.heightM],
      ['Wing Area (m2)', dimensionDetails.wingAreaM2],
      ['Door Height (m)', dimensionDetails.doorHeightM],
    ]);
  }

  Widget _buildWeightsData(Weights? detail) {
    if (detail == null) return const Text('No data available');
    final weightsDetails = detail;
    return _buildFieldRows([
      ['Operating Empty Weight (kg)', weightsDetails.emptyWeight],
      ['Maximum Zero Fuel Weight (kg)', weightsDetails.zeroFuelWeight],
      ['Maximum Takeoff Weight (kg)', weightsDetails.takeoffWeight],
      ['Max Payload (kg)', weightsDetails.payload],
      ['Maximum Landing Weight (kg)', weightsDetails.landingWeight],
      ['Maximum Baggage or Cargo Volume (m3)', weightsDetails.baggage.maximum],
      ['Minimum Baggage or Cargo Volume (m3)', weightsDetails.baggage.minimum],
    ]);
  }

  Widget _builPerfomanceOrderedBYsData(Performance? detail) {
    if (detail == null) return const Text('No data available');
    final performanceDetails = detail;
    return _buildFieldRows([
      ['Takeoff Speed (kts)', performanceDetails.takeoffSpeedKts],
      ['Takeoff Distance (m)', performanceDetails.takeoffDistanceM],
      ['Initial Rate of Climb (fpm)', performanceDetails.climbInitialFpm],
      ['Average Rate of Climb (fpm)', performanceDetails.climbAvgFpm],
      ['Maximum Rate of Climb (fpm)', performanceDetails.climbMaxFpm],
      ['Service Ceiling (ft)', performanceDetails.serviceCeiling],
      ['Max Certified Altitude (ft)', performanceDetails.maxCertifiedAltitude],
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
      ['Minimum Clean Speed (kts)', performanceDetails.minCleanSpeed.toString()],
      ['Approach Speed (kts)', performanceDetails.approachSpeed],
      ['Approach Category', performanceDetails.approachCategory],
      ['Landing Speed (kts)', performanceDetails.landingSpeed],
      ['Landing Distance (m)', performanceDetails.landingDistance],
      ['Runway Length Required (m)', performanceDetails.runwayRequired],
      ['Stall Speed (kts)', performanceDetails.stallSpeed],
    ]);
  }

  Widget _builOperationLimitationsData(OperationalLimitations? detail) {
    if (detail == null) return const Text('No data available');
    final operationalDetails = detail;
    return _buildFieldRows([
      ['Runway Slope Limit percent', operationalDetails.runwaySlopeLimit],
      ['Max Crosswind Normal Law (kts)', operationalDetails.maxCrosswindNormal],
      [
        'Maximum Crosswind (Degraded Law)',
        operationalDetails.maxCrosswindDegraded,
      ],
      ['Max Tailwind Landing (kts)', operationalDetails.maxTailwindLanding],
      ['Max Tailwind Takeoff (kts)', operationalDetails.maxTailwindTakeoff],
      ['Field Elevation Limit (ft)', operationalDetails.fieldElevationLimit],
      ['Maximum Runway Altitude (ft)', operationalDetails.maxRunwayAltitude],
      ['Tailwind Limit (Flaps ≤10°)', operationalDetails.maxTailwindTakeoff],
      ['Supported Categories', operationalDetails.autoland.supportedCategories],
      ['Certified Autoland Level', operationalDetails.autoland.certifiedLevel],
    ]);
  }

  Widget _builLandingGearData(LandingGear? detail) {
    if (detail == null) return const Text('No data available');
    final landingDetails = detail;
    return _buildFieldRows([
      ['Landing Gear Configuration', landingDetails.type],
      ['Number of Wheels', landingDetails.numberOfWheels],
      ['Tyre Size (inches)', landingDetails.tyreSize],
      ['Tyre Pressure (psi)', landingDetails.tyrePressure],
    ]);
  }

  Widget _builCertificationData(CertificationEnvironmental? detail) {
    if (detail == null) return const Text('No data available');
    final certificationDetails = detail;
    return _buildFieldRows([
      ['Certification Basis', certificationDetails.certificationBasis],
      ['Special Conditions', certificationDetails.specialConditions],
      ['Noise Compliance', certificationDetails.noiseCompliance],
      ['Emissions Category', certificationDetails.emissionsCategory],
      ['EASA TCDS Number', certificationDetails.easa],
      ['FAA TCDS Number', certificationDetails.faa],
    ]);
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
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
                  Flexible(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF3F3D56),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        isExpanded ? "Show Less" : "Show More",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
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

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Column(
      children: [
        _buildSectionHeader(
          title: title,
          isExpanded: isExpanded,
          onTap: onToggle,
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

  Widget _buildFieldRows(List<List<String>> fields) {
    return Column(
      children: List.generate((fields.length / 2).ceil(), (i) {
        final first = fields[i * 2];
        final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: customField(label: first[0], text: first[1]),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: second != null
                    ? customField(label: second[0], text: second[1])
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
