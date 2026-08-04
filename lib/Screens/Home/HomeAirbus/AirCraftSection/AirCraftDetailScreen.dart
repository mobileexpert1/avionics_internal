import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
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

  int _currentImageIndex = 0;
  late final PageController _imagePageController = PageController();
  late final PageController _tabPageController = PageController();
  final encyclopediaTabKeys = List.generate(8, (_) => GlobalKey());
  final ScrollController _subTabScrollController = ScrollController();

  int subTab = 0;
  final sub2Tabs = [
    "Identification & Classification",
    "Powerplant & Propulsion",
    "Dimensions",
    "Weights",
    "Performance",
    "Operational Limitations",
    "Landing Gear",
    "Certification & Environmental",
  ];

  @override
  void initState() {
    super.initState();
    context.read<AirCraftDetailCubit>().fetchAircraftDetailById(
      widget.aircraftId,
      context,
    );
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.allPlanesListScreen,
    );
    context.read<AirCraftDetailCubit>().fetchAircraftParams(context, 1);
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _tabPageController.dispose();
    super.dispose();
  }

  // ── Go to sub tab (syncs header tabs + PageView + scroll) ──
  void _goToSubTab(int index) {
    setState(() => subTab = index);
    _scrollToSelectedSubTab(index);
    if (_tabPageController.hasClients) {
      _tabPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToSelectedSubTab(int index) {
    final key = encyclopediaTabKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: index == 0
            ? 1.0
            : index == sub2Tabs.length - 1
            ? 1.0
            : 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AirCraftDetailCubit, AirCraftDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final details = state.airCraftDetails?.results;
        final aircraftData = context
            .read<AirCraftDetailCubit>()
            .state
            .airCraftDetails
            ?.results;

        final hasValidImages =
            aircraftData?.images != null && aircraftData!.images!.isNotEmpty;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title:
                state.airCraftDetails?.results.identification.aircraftModel ??
                "",
            centerTitle: false,
            leftButton: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.backArrowButton),
                fit: BoxFit.cover,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 40,
                child: ListView.separated(
                  controller: _subTabScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: sub2Tabs.length,
                  //padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) {
                    return Center(
                      child: Container(
                        width: 1,
                        height: 16,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    final isSelected = subTab == index;
                    return GestureDetector(
                      onTap: () => _goToSubTab(index),
                      child: Container(
                        key: encyclopediaTabKeys[index],
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Text(
                          sub2Tabs[index],
                          style: AppTextStyles.regular(16).copyWith(
                            height: 1.0,
                            color: isSelected
                                ? AppColors.black
                                : AppColors.greyFlightDetailText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (hasValidImages)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildImageCoverScroller(
                    MediaQuery.of(context).size.height,
                    aircraftData.images,
                  ),
                ),

              Expanded(
                child: PageView.builder(
                  controller: _tabPageController,
                  itemCount: sub2Tabs.length,
                  onPageChanged: (index) {
                    setState(() => subTab = index);
                    _scrollToSelectedSubTab(index);
                  },
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          _getTabContentByIndex(index, details),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── BOTTOM NAV ARROWS + DOTS ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        if (subTab > 0) _goToSubTab(subTab - 1);
                      },
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(sub2Tabs.length, (index) {
                          final isActive = subTab == index;
                          return GestureDetector(
                            onTap: () => _goToSubTab(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        if (subTab < sub2Tabs.length - 1) {
                          _goToSubTab(subTab + 1);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final screenHeight = MediaQuery.of(context).size.height;
  //
  //   return BlocBuilder<AirCraftDetailCubit, AirCraftDetailState>(
  //     builder: (context, state) {
  //       if (state.isLoading) {
  //         return const Scaffold(
  //           backgroundColor: Colors.white,
  //           body: Center(child: CircularProgressIndicator()),
  //         );
  //       } else if (state.airCraftDetails == null) {
  //         return const Scaffold(body: Center(child: Text("No data available")));
  //       }
  //       return Scaffold(
  //         backgroundColor: Colors.white,
  //         appBar: CustomAppBar(
  //           title:
  //               state.airCraftDetails?.results.identification.aircraftModel ??
  //               "",
  //           centerTitle: false,
  //           leftButton: IconButton(
  //             icon: SvgPicture.asset(
  //               CommonUi.setSvgImage(AssetsPath.backArrowButton),
  //               fit: BoxFit.cover,
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //         ),
  //         body: SingleChildScrollView(
  //           child: Center(
  //             child: ConstrainedBox(
  //               constraints: BoxConstraints(
  //                 maxWidth: kIsWeb ? 1500 : double.infinity,
  //               ),
  //               child: Stack(
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       _buildTopHeadingDetails(screenHeight),
  //                       _buildExpandableSection(
  //                         title: "IDENTIFICATION & CLASSIFICATION",
  //                         isExpanded: showIdentification,
  //                         onToggle: () => setState(
  //                           () => showIdentification = !showIdentification,
  //                         ),
  //                         content: _buildTechnicalData(
  //                           state.airCraftDetails?.results.identification,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "POWERPLANT & PROPULSION",
  //                         isExpanded: showPowerSection,
  //                         onToggle: () => setState(
  //                           () => showPowerSection = !showPowerSection,
  //                         ),
  //                         content: _buildPowerPlantData(
  //                           state.airCraftDetails?.results.powerplant,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "DIMENSIONS",
  //                         isExpanded: showDimensionSection,
  //                         onToggle: () => setState(
  //                           () => showDimensionSection = !showDimensionSection,
  //                         ),
  //                         content: _buildDimenionsData(
  //                           state.airCraftDetails?.results.dimensions,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "WEIGHTS",
  //                         isExpanded: showWeightsSection,
  //                         onToggle: () => setState(
  //                           () => showWeightsSection = !showWeightsSection,
  //                         ),
  //                         content: _buildWeightsData(
  //                           state.airCraftDetails?.results.weights,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "PERFORMANCE (ORDERED BY FLIGHT SEQUENCE)",
  //                         isExpanded: showPerformanceSection,
  //                         onToggle: () => setState(
  //                           () => showPerformanceSection =
  //                               !showPerformanceSection,
  //                         ),
  //                         content: _builPerfomanceOrderedBYsData(
  //                           state.airCraftDetails?.results.performance,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "OPERATIONAL LIMITATIONS",
  //                         isExpanded: showOperationalSection,
  //                         onToggle: () => setState(
  //                           () => showOperationalSection =
  //                               !showOperationalSection,
  //                         ),
  //                         content: _builOperationLimitationsData(
  //                           state
  //                               .airCraftDetails
  //                               ?.results
  //                               .operationalLimitations,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "LANDING GEAR",
  //                         isExpanded: showLandingSection,
  //                         onToggle: () => setState(
  //                           () => showLandingSection = !showLandingSection,
  //                         ),
  //                         content: _builLandingGearData(
  //                           state.airCraftDetails?.results.landingGear,
  //                         ),
  //                       ),
  //                       _buildExpandableSection(
  //                         title: "CERTIFICATION & ENVIRONMENTAL",
  //                         isExpanded: showCertificationSection,
  //                         onToggle: () => setState(
  //                           () => showCertificationSection =
  //                               !showCertificationSection,
  //                         ),
  //                         content: _builCertificationData(
  //                           state.airCraftDetails?.results.certification,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 50),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildImageCoverScroller(
    double screenHeight,
    List<AircraftImage> coverImages,
  ) {
    if (coverImages.isEmpty) return const SizedBox.shrink();
    return StatefulBuilder(
      builder: (context, setState) {
        final screenWidth = MediaQuery.of(context).size.width;
        final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
        return SizedBox(
          height: screenHeight * 0.20,
          child: Stack(
            children: [
              PageView.builder(
                controller: _imagePageController,
                itemCount: coverImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final image = coverImages[index];
                  final hasCopyright = image.cc.isNotEmpty;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Center(
                      child: SizedBox(
                        width: isDesktopWeb
                            ? screenWidth * 0.2
                            : double.infinity,
                        height: screenHeight * 0.20,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CachedAnyImage(
                              useCache: true,
                              isForPlaneList: true,
                              imagePath: image.url,
                              width: double.infinity,
                              height: screenHeight * 0.20,
                              contentImage: kIsWeb
                                  ? BoxFit.cover
                                  : BoxFit.cover,
                            ),

                            if (hasCopyright)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    final uri = Uri.tryParse(image.source);

                                    if (uri != null &&
                                        await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Could not open URL.'),
                                        ),
                                      );
                                    }
                                  },

                                  child: Container(
                                    width: 320,
                                    padding: const EdgeInsets.only(
                                      left: 80,
                                      right: 10,
                                      bottom: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryDark.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: RichText(
                                      textAlign: TextAlign.right,
                                      text: TextSpan(
                                        style: AppTextStyles.medium(
                                          11,
                                        ).copyWith(color: AppColors.white),
                                        children: [
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Text(
                                              "©",
                                              style: AppTextStyles.medium(22)
                                                  .copyWith(
                                                    color: AppColors.white,
                                                  ),
                                            ),
                                          ),
                                          TextSpan(text: " ${image.cc}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              Positioned(
                left: 5,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentImageIndex > 0) {
                        _imagePageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 5,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentImageIndex < coverImages.length - 1) {
                        _imagePageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 3,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(coverImages.length, (index) {
                    final isActive = index == _currentImageIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── TAB CONTENT BY INDEX (replaces _getTabContent) ──
  Widget _getTabContentByIndex(int index, AircraftResult? detail) {
    switch (index) {
      case 0:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'ICAO Type Code',
              detail?.identification.icaoTypeCode ?? 'N/A',
              true,
              "icao_type_code",
              "Aircraft",
            ],
            [
              'Aircraft Manufacturer',
              detail?.identification.manufacturer ?? 'N/A',
              true,
              "aircraft_manufacturer",
              "Aircraft",
            ],
            [
              'Aircraft Model',
              detail?.identification.aircraftModel ?? 'N/A',
              true,
              "aircraft_model",
              "Aircraft",
            ],
            [
              'Aircraft Role',
              detail?.identification.aircraftRole ?? 'N/A',
              true,
              "aircraft_role",
              "Aircraft",
            ],
            [
              'Aircraft Type',
              detail?.identification.aircraftType ?? 'N/A',
              true,
              "aircraft_type",
              "Aircraft",
            ],
            [
              'Wake Turbulence Category',
              detail?.identification.wakeTurbulenceCategory ?? 'N/A',
              true,
              "wake_turbulence_category",
              "Aircraft",
            ],
            [
              'Civilian / Military / Dual Use',
              detail?.identification.civilianMilitaryOrDualUse ?? 'N/A',
              true,
              "civilian_military_dual_use",
              "Aircraft",
            ],
            [
              'Country of Origin',
              detail?.identification.countryOfOrigin ?? 'N/A',
              true,
              "country_of_origin",
              "Aircraft",
            ],
            [
              'Date of Maiden Flight',
              detail?.identification.dateOfMaidenFlight ?? 'N/A',
              true,
              "date_of_maiden_flight",
              "Aircraft",
            ],
            [
              'Year of Introduction',
              detail?.identification.yearOfIntroduction ?? 'N/A',
              true,
              "year_of_introduction",
              "Aircraft",
            ],
            [
              'Production Status',
              detail?.identification.productionStatus ?? 'N/A',
              true,
              "production_status",
              "Aircraft",
            ],
            [
              'Avionics System Name',
              detail?.identification.avionicsSystem ?? 'N/A',
              true,
              "avionics_system_name",
              "Aircraft",
            ],
            [
              'Number of Crew',
              detail?.identification.numberOfCrew ?? 'N/A',
              true,
              "number_of_crew",
              "Aircraft",
            ],
            [
              'Number of Passengers (Maximum)',
              detail?.identification.numberOfPassengers.maximum ?? 'N/A',
              true,
              "number_of_passengers_maximum",
              "Aircraft",
            ],
            [
              'Number of Passengers (Typical)',
              detail?.identification.numberOfPassengers.typical ?? 'N/A',
              true,
              "number_of_passengers_typical",
              "Aircraft",
            ],
          ],
          context: context,
        );

      case 1:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Number of Engines',
              detail?.powerplant.numberOfEngines.toString() ?? 'N/A',
              true,
              "number_of_engines",
              "Aircraft",
            ],
            [
              'Fuel Consumption (kg/h)',
              detail?.powerplant.fuel.burnRate ?? 'N/A',
              true,
              "fuel_consumption",
              "Aircraft",
            ],
            [
              'Manufacturer',
              detail?.powerplant.engine.manufacturer ?? 'N/A',
              true,
              "manufacturer",
              "Aircraft",
            ],
            [
              'Model',
              detail?.powerplant.engine.model ?? 'N/A',
              true,
              "model",
              "Aircraft",
            ],
            [
              'Engine Type',
              detail?.powerplant.engine.engineType ?? 'N/A',
              true,
              "engine_type",
              "Aircraft",
            ],
            [
              'Thrust Per Engine (kN)',
              detail?.powerplant.engine.thrust ?? 'N/A',
              true,
              "thrust_per_engine",
              "Aircraft",
            ],
            [
              'Physical Engine Code',
              detail?.powerplant.engine.physicalEngineCode ?? 'N/A',
              true,
              "physical_engine_code",
              "Aircraft",
            ],
            [
              'APU Type',
              detail?.powerplant.apuType ?? 'N/A',
              true,
              "apu_type",
              "Aircraft",
            ],
            [
              'Fuel Type',
              detail?.powerplant.fuel.fuelType ?? 'N/A',
              true,
              "fuel_type",
              "Aircraft",
            ],
            [
              'Fuel Additives',
              detail?.powerplant.fuel.fuelAdditives ?? 'N/A',
              true,
              "fuel_additives",
              "Aircraft",
            ],
            [
              'Fuel Capacity (L)',
              detail?.powerplant.fuel.capacity ?? 'N/A',
              true,
              "fuel_capacity",
              "Aircraft",
            ],
          ],
          context: context,
        );
      case 2:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Wingspan (m)',
              detail?.dimensions.wingspanM ?? 'N/A',
              true,
              "wingspan",
              "Aircraft",
            ],
            [
              'Cabin Width (m)',
              detail?.dimensions.cabinWidthM ?? 'N/A',
              true,
              "cabin_width",
              "Aircraft",
            ],
            [
              'Length (m)',
              detail?.dimensions.lengthM ?? 'N/A',
              true,
              "length",
              "Aircraft",
            ],
            [
              'Wingtip Configuration',
              detail?.dimensions.wingtipConfiguration ?? 'N/A',
              true,
              "wingtip_configuration",
              "Aircraft",
            ],
            [
              'Height (m)',
              detail?.dimensions.heightM ?? 'N/A',
              true,
              "height",
              "Aircraft",
            ],
            [
              'Wing Area (m²)',
              detail?.dimensions.wingAreaM2 ?? 'N/A',
              true,
              "wing_area",
              "Aircraft",
            ],
            [
              'Door Height (m)',
              detail?.dimensions.doorHeightM ?? 'N/A',
              true,
              "door_height",
              "Aircraft",
            ],
          ],
          context: context,
        );
      case 3:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Operating Empty Weight(OEW, kg)',
              detail?.weights.emptyWeight ?? 'N/A',
              true,
              "operating_empty_weight",
              "Aircraft",
            ],
            [
              'Maximum Zero Fuel Weight (MZFW, kg)',
              detail?.weights.zeroFuelWeight ?? 'N/A',
              true,
              "maximum_zero_fuel_weight",
              "Aircraft",
            ],
            [
              'Maximum Takeoff Weight(MTOW, kg)',
              detail?.weights.takeoffWeight ?? 'N/A',
              true,
              "maximum_take_off_weight",
              "Aircraft",
            ],
            [
              'Maximum Payload (kg)',
              detail?.weights.payload ?? 'N/A',
              true,
              "maximum_payload",
              "Aircraft",
            ],
            [
              'Maximum Landing Weight(MLW, kg)',
              detail?.weights.landingWeight ?? 'N/A',
              true,
              "maximum_landing_weight",
              "Aircraft",
            ],
            [
              'Maximum Baggage or Cargo Volume (m³)',
              detail?.weights.baggage.maximum ?? 'N/A',
              true,
              "maximum_baggage_or_cargo_volume",
              "Aircraft",
            ],
            [
              'Minimum Baggage or Cargo Volume (m³)',
              detail?.weights.baggage.minimum ?? 'N/A',
              true,
              "minimum_baggage_or_cargo_volume",
              "Aircraft",
            ],
          ],
          context: context,
        );
      case 4:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Takeoff Speed (kts)',
              detail?.performance.takeoffSpeedKts ?? 'N/A',
              true,
              "take_off_speed",
              "Aircraft",
            ],
            [
              'Takeoff Distance (m)',
              detail?.performance.takeoffDistanceM ?? 'N/A',
              true,
              "take_off_distance",
              "Aircraft",
            ],
            [
              'Initial Rate of Climb (fpm)',
              detail?.performance.climbInitialFpm ?? 'N/A',
              true,
              "initial_rate_of_climb",
              "Aircraft",
            ],
            [
              'Average Rate of Climb (fpm)',
              detail?.performance.climbAvgFpm ?? 'N/A',
              true,
              "average_rate_of_climb",
              "Aircraft",
            ],
            [
              'Maximum Rate of Climb(fpm)',
              detail?.performance.climbMaxFpm ?? 'N/A',
              true,
              "maximum_rate_of_climb",
              "Aircraft",
            ],
            [
              'Service Ceiling (ft)',
              detail?.performance.serviceCeiling ?? 'N/A',
              true,
              "service_ceiling",
              "Aircraft",
            ],
            [
              'Max Certified Altitude (ft)',
              detail?.performance.maxCertifiedAltitude ?? 'N/A',
              true,
              "max_certified_altitude",
              "Aircraft",
            ],
            [
              'Cruise Speed (kt/Mach)',
              detail?.performance.cruiseSpeedKt ?? 'N/A',
              true,
              "cruise_speed",
              "Aircraft",
            ],
            [
              'Maximum Speed (VMO/MMO, kts/Mach)',
              detail?.performance.maxCruiseSpeed ?? 'N/A',
              true,
              "maximum_speed",
              "Aircraft",
            ],
            [
              'Range (NM /km)',
              "${detail?.performance.range.normalRangeNm ?? 'N/A'} NM / ${detail?.performance.range.normalRangeKm ?? 'N/A'} Km",
              true,
              "range",
              "Aircraft",
            ],
            [
              'Ferry Range (NM/km)',
              (detail?.performance.range.ferryRangeNm ?? 'N/A'),
              true,
              "ferry_range",
              "Aircraft",
            ],
            [
              'Initial Rate of Descent (fpm)',
              detail?.performance.descentInitialFpm ?? 'N/A',
              true,
              "initial_rate_of_descent",
              "Aircraft",
            ],
            [
              'Average Rate of Descent(fpm)',
              detail?.performance.descentAvgFpm ?? 'N/A',
              true,
              "average_rate_of_descent",
              "Aircraft",
            ],
            [
              'Minimum Clean Speed (kts)',
              detail?.performance.minCleanSpeed ?? 'N/A',
              true,
              "minimum_clean_speed",
              "Aircraft",
            ],
            [
              'Approach Category',
              detail?.performance.approachCategory ?? 'N/A',
              true,
              "approach_category",
              "Aircraft",
            ],

            [
              'Approach Speed (kts)',
              detail?.performance.approachSpeed ?? 'N/A',
              true,
              "approach_speed",
              "Aircraft",
            ],
            [
              'Landing Distance (m)',
              detail?.performance.landingDistance ?? 'N/A',
              true,
              "landing_distance",
              "Aircraft",
            ],

            [
              'Landing Speed (kts)',
              detail?.performance.landingSpeed ?? 'N/A',
              true,
              "landing_speed",
              "Aircraft",
            ],

            [
              'Stall Speed (kts)',
              detail?.performance.stallSpeed ?? 'N/A',
              true,
              "stall_speed",
              "Aircraft",
            ],
            [
              'Runway Length Required (m)',
              detail?.performance.runwayRequired ?? 'N/A',
              true,
              "runway_length_required",
              "Aircraft",
            ],
          ],
          context: context,
        );
      case 5:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Runway Slope Limit (%)',
              detail?.operationalLimitations.runwaySlopeLimit ?? 'N/A',
              true,
              "runway_slope_limit",
              "Aircraft",
            ],
            [
              'Max Crosswind (Normal Law, kts)',
              detail?.operationalLimitations.maxCrosswindNormal ?? 'N/A',
              true,
              "max_crosswind_normal_law",
              "Aircraft",
            ],
            [
              'Maximum Crosswind (Degraded Law, kts)',
              detail?.operationalLimitations.maxCrosswindDegraded ?? 'N/A',
              true,
              "maximum_crosswind_degraded_law",
              "Aircraft",
            ],
            [
              'Max Tailwind (Landing, kts)',
              detail?.operationalLimitations.maxTailwindLanding ?? 'N/A',
              true,
              "max_tailwind_landing",
              "Aircraft",
            ],
            [
              'Max Tailwind Takeoff (kts)',
              detail?.operationalLimitations.maxTailwindTakeoff ?? 'N/A',
              true,
              "max_tailwind_take_off",
              "Aircraft",
            ],
            [
              'Field Elevation Limit (ft)',
              detail?.operationalLimitations.fieldElevationLimit ?? 'N/A',
              true,
              "field_elevation_limit",
              "Aircraft",
            ],
            [
              'Maximum Runway Altitude (ft)',
              detail?.operationalLimitations.maxRunwayAltitude ?? 'N/A',
              true,
              "maximum_runway_altitude",
              "Aircraft",
            ],
            [
              'Tailwind Limit (Flaps ≤10°)',
              detail?.operationalLimitations.maxTailwindTakeoff ?? 'N/A',
              true,
              "tailwind_limit",
              "Aircraft",
            ],
            [
              'Supported Categories',
              detail?.operationalLimitations.autoland.supportedCategories ??
                  'N/A',
              true,
              "supported_categories",
              "Aircraft",
            ],
            [
              'Certified Autoland Level',
              detail?.operationalLimitations.autoland.certifiedLevel ?? 'N/A',
              true,
              "certified_autoland_level",
              "Aircraft",
            ],
          ],
          context: context,
        );
      case 6:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Landing Gear Configuration',
              detail?.landingGear.type ?? 'N/A',
              true,
              "landing_gear_configuration",
              "Aircraft",
            ],
            [
              'Number of Wheels',
              detail?.landingGear.numberOfWheels ?? 'N/A',
              true,
              "number_of_wheels",
              "Aircraft",
            ],
            [
              'Tyre Size (inches)',
              detail?.landingGear.tyreSize ?? 'N/A',
              true,
              "tyre_size",
              "Aircraft",
            ],
            [
              'Tyre Pressure (psi or bar)',
              detail?.landingGear.tyrePressure ?? 'N/A',
              true,
              "tyre_pressure",
              "Aircraft",
            ],
          ],
          context: context,
        );
      case 7:
        return customFieldForTextAndValue(
          false,
          fields: [
            [
              'Certification Basis',
              detail?.certification.certificationBasis ?? 'N/A',
              true,
              "certification_basis",
              "Aircraft",
            ],
            [
              'Special Conditions',
              detail?.certification.specialConditions ?? 'N/A',
              true,
              "special_conditions",
              "Aircraft",
            ],
            [
              'Noise Compliance',
              detail?.certification.noiseCompliance ?? 'N/A',
              true,
              "noise_compliance",
              "Aircraft",
            ],
            [
              'Emissions Category',
              detail?.certification.emissionsCategory ?? 'N/A',
              true,
              "emissions_category",
              "Aircraft",
            ],
            [
              'EASA TCDS Number',
              detail?.certification.easa ?? 'N/A',
              true,
              "easa_tcds_number",
              "Aircraft",
            ],
            [
              'FAA TCDS Number',
              detail?.certification.faa ?? 'N/A',
              true,
              "faa_tcds_number",
              "Aircraft",
            ],
          ],
          context: context,
        );
    }
    return Container();
  }

  // Widget _buildImageCoverScroller(
  //   double screenHeight,
  //   List<AircraftImage> coverImages,
  // ) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
  //   if (coverImages.isEmpty) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   if (isDesktopWeb) {
  //     final isSingleImage = coverImages.length == 1;
  //
  //     return SizedBox(
  //       height: screenHeight * 0.22,
  //       child: CarouselSlider.builder(
  //         itemCount: coverImages.length,
  //         options: CarouselOptions(
  //           height: screenHeight * 0.22,
  //           viewportFraction: isSingleImage ? 1.0 : 0.25,
  //           enlargeCenterPage: !isSingleImage,
  //           enlargeFactor: 0.25,
  //           enableInfiniteScroll: !isSingleImage,
  //         ),
  //         itemBuilder: (context, index, realIndex) {
  //           final image = coverImages[index];
  //
  //           return GestureDetector(
  //             behavior: HitTestBehavior.translucent,
  //             onTap: image.cc.isNotEmpty
  //                 ? () => _openImageSource(context, image)
  //                 : null,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: isSingleImage ? 0 : 6,
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(8),
  //                 child: Stack(
  //                   fit: StackFit.expand,
  //                   children: [
  //                     _buildAircraftImage(image, screenHeight * 0.22),
  //                     _buildCopyright(image),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }
  //   return SizedBox(
  //     height: screenHeight * 0.18,
  //     child: ScrollConfiguration(
  //       behavior: const ScrollBehavior().copyWith(
  //         scrollbars: true,
  //         dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
  //       ),
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: coverImages.length,
  //         itemBuilder: (context, index) {
  //           final image = coverImages[index];
  //
  //           final isSingleImage = coverImages.length == 1;
  //
  //           final imageWidth = isSingleImage
  //               ? MediaQuery.of(context).size.width
  //               : 300.0;
  //
  //           return Padding(
  //             padding: isSingleImage
  //                 ? EdgeInsets.zero
  //                 : const EdgeInsets.only(right: 10),
  //             child: GestureDetector(
  //               behavior: HitTestBehavior.translucent,
  //               onTap: image.cc.isNotEmpty
  //                   ? () => _openImageSource(context, image)
  //                   : null,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(6),
  //                 child: Stack(
  //                   children: [
  //                     SizedBox(
  //                       width: imageWidth,
  //                       height: screenHeight * 0.18,
  //                       child: _buildAircraftImage(image, screenHeight * 0.18),
  //                     ),
  //                     _buildCopyright(image),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAircraftImage(AircraftImage image, double height) {
  //   return CachedAnyImage(
  //     imagePath: image.url,
  //     contentImage: BoxFit.cover,
  //     width: double.infinity,
  //     height: height,
  //     isForManufacturer: true,
  //   );
  // }

  // Widget _buildCopyright(AircraftImage image) {
  //   if (image.cc.isEmpty) {
  //     return const SizedBox.shrink();
  //   }
  //
  //   return Positioned(
  //     left: 8,
  //     bottom: 8,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //       decoration: BoxDecoration(
  //         color: Colors.black.withValues(alpha: 0.6),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Text(
  //         '© ${image.cc}',
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 8,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Future<void> _openImageSource(
  //   BuildContext context,
  //   AircraftImage image,
  // ) async {
  //   final uri = Uri.tryParse(image.source);
  //
  //   if (uri != null && await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('Could not open URL.')));
  //     }
  //   }
  // }

  // Widget _buildTopHeadingDetails(double screenHeight) {
  //   final aircraftData = context
  //       .read<AirCraftDetailCubit>()
  //       .state
  //       .airCraftDetails
  //       ?.results;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 0),
  //     child: Container(
  //       width: double.infinity,
  //       color: Colors.grey.shade100,
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 15,
  //         vertical: 15,
  //       ), // Internal padding
  //       child: Column(
  //         children: [
  //           _buildImageCoverScroller(screenHeight, aircraftData?.images ?? []),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // final fieldColor = const Color(0xFF3E3C55);
  //
  // Widget _buildTechnicalData(IdentificationClassification? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final identification = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['ICAO Type Code', identification.icaoTypeCode],
  //       ['Aircraft Manufacturer', identification.manufacturer],
  //       ['Aircraft Model', identification.aircraftModel],
  //       ['Aircraft Role', identification.aircraftRole],
  //       ['Aircraft Type', identification.aircraftType],
  //       ['Wake Turbulence Category', identification.wakeTurbulenceCategory],
  //       [
  //         'Civilian / Military / Dual Use',
  //         identification.civilianMilitaryOrDualUse,
  //       ],
  //       ['Country of Origin', identification.countryOfOrigin],
  //       ['Date of Maiden Flight', identification.dateOfMaidenFlight],
  //       ['Year of Introduction', identification.yearOfIntroduction],
  //       ['Production Status', identification.productionStatus],
  //       ['Avionics System Name', identification.avionicsSystem],
  //       ['Number of Crew', identification.numberOfCrew],
  //       [
  //         'Number of Passengers (Typical)',
  //         identification.numberOfPassengers.typical,
  //       ],
  //       [
  //         'Number of Passengers (Maximum)',
  //         identification.numberOfPassengers.maximum,
  //       ],
  //     ],
  //     context: context,
  //   );
  // }
  //
  // Widget _buildPowerPlantData(PowerplantPropulsion? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final powerPlantDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Number of Engines', powerPlantDetails.numberOfEngines.toString()],
  //       ['Fuel Consumption', powerPlantDetails.fuel.burnRate],
  //       ['Manufacturer', powerPlantDetails.engine.manufacturer],
  //       ['Model', powerPlantDetails.engine.model],
  //       ['Engine Type', powerPlantDetails.engine.engineType],
  //       ['Thrust Per Engine (kN)', powerPlantDetails.engine.thrust],
  //       ['Physical Engine Code', powerPlantDetails.engine.physicalEngineCode],
  //       ['APU Type', powerPlantDetails.apuType],
  //       ['Fuel Type', powerPlantDetails.fuel.fuelType],
  //       ['Fuel Additives', powerPlantDetails.fuel.fuelAdditives],
  //       ['Fuel Capacity', powerPlantDetails.fuel.capacity],
  //     ],
  //     context: context,
  //   );
  // }
  //
  // Widget _buildDimenionsData(Dimensions? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final dimensionDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Wingspan (m)', dimensionDetails.wingspanM],
  //       ['Cabin Width (m)', dimensionDetails.cabinWidthM],
  //       ['Length (m)', dimensionDetails.lengthM],
  //       ['Wingtip Configuration', dimensionDetails.wingtipConfiguration],
  //       ['Height (m)', dimensionDetails.heightM],
  //       ['Wing Area (m2)', dimensionDetails.wingAreaM2],
  //       ['Door Height (m)', dimensionDetails.doorHeightM],
  //     ],
  //     context: context,
  //   );
  // }
  //
  // Widget _buildWeightsData(Weights? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final weightsDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Operating Empty Weight (kg)', weightsDetails.emptyWeight],
  //       ['Maximum Zero Fuel Weight (kg)', weightsDetails.zeroFuelWeight],
  //       ['Maximum Takeoff Weight (kg)', weightsDetails.takeoffWeight],
  //       ['Max Payload (kg)', weightsDetails.payload],
  //       ['Maximum Landing Weight (kg)', weightsDetails.landingWeight],
  //       [
  //         'Maximum Baggage or Cargo Volume (m3)',
  //         weightsDetails.baggage.maximum,
  //       ],
  //       [
  //         'Minimum Baggage or Cargo Volume (m3)',
  //         weightsDetails.baggage.minimum,
  //       ],
  //     ],
  //     context: context,
  //   );
  // }

  // Widget _builPerfomanceOrderedBYsData(Performance? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final performanceDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Takeoff Speed (kts)', performanceDetails.takeoffSpeedKts],
  //       ['Takeoff Distance (m)', performanceDetails.takeoffDistanceM],
  //       ['Initial Rate of Climb (fpm)', performanceDetails.climbInitialFpm],
  //       ['Average Rate of Climb (fpm)', performanceDetails.climbAvgFpm],
  //       ['Maximum Rate of Climb (fpm)', performanceDetails.climbMaxFpm],
  //       ['Service Ceiling (ft)', performanceDetails.serviceCeiling],
  //       [
  //         'Max Certified Altitude (ft)',
  //         performanceDetails.maxCertifiedAltitude,
  //       ],
  //       ['Cruise Speed (kt)', performanceDetails.cruiseSpeedKt],
  //       ['Cruise(Mach)', performanceDetails.cruiseMach],
  //       ['Maximum Speed', performanceDetails.maxCruiseSpeed],
  //       ['VMO (kts)', performanceDetails.vmoKts],
  //       ['MMO (Mach)', performanceDetails.mmoMach],
  //
  //       [
  //         'Range (NM / km)',
  //         "${performanceDetails.range.normalRangeNm} NM / ${performanceDetails.range.normalRangeKm} Km",
  //       ],
  //       ['Ferry Range (if applicable)', performanceDetails.range.ferryRangeNm],
  //       ['Initial Rate of Descent (fpm)', performanceDetails.descentInitialFpm],
  //       ['Average Rate of Descent (fpm)', performanceDetails.descentAvgFpm],
  //       [
  //         'Minimum Clean Speed (kts)',
  //         performanceDetails.minCleanSpeed.toString(),
  //       ],
  //       ['Approach Speed (kts)', performanceDetails.approachSpeed],
  //       ['Approach Category', performanceDetails.approachCategory],
  //       ['Landing Speed (kts)', performanceDetails.landingSpeed],
  //       ['Landing Distance (m)', performanceDetails.landingDistance],
  //       ['Runway Length Required (m)', performanceDetails.runwayRequired],
  //       ['Stall Speed (kts)', performanceDetails.stallSpeed],
  //     ],
  //     context: context,
  //   );
  // }
  //
  // Widget _builOperationLimitationsData(OperationalLimitations? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final operationalDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Runway Slope Limit percent', operationalDetails.runwaySlopeLimit],
  //       [
  //         'Max Crosswind Normal Law (kts)',
  //         operationalDetails.maxCrosswindNormal,
  //       ],
  //       [
  //         'Maximum Crosswind (Degraded Law)',
  //         operationalDetails.maxCrosswindDegraded,
  //       ],
  //       ['Max Tailwind Landing (kts)', operationalDetails.maxTailwindLanding],
  //       ['Max Tailwind Takeoff (kts)', operationalDetails.maxTailwindTakeoff],
  //       ['Field Elevation Limit (ft)', operationalDetails.fieldElevationLimit],
  //       ['Maximum Runway Altitude (ft)', operationalDetails.maxRunwayAltitude],
  //       ['Tailwind Limit (Flaps ≤10°)', operationalDetails.maxTailwindTakeoff],
  //       [
  //         'Supported Categories',
  //         operationalDetails.autoland.supportedCategories,
  //       ],
  //       [
  //         'Certified Autoland Level',
  //         operationalDetails.autoland.certifiedLevel,
  //       ],
  //     ],
  //     context: context,
  //   );
  // }
  //
  // Widget _builLandingGearData(LandingGear? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final landingDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Landing Gear Configuration', landingDetails.type],
  //       ['Number of Wheels', landingDetails.numberOfWheels],
  //       ['Tyre Size (inches)', landingDetails.tyreSize],
  //       ['Tyre Pressure (psi)', landingDetails.tyrePressure],
  //     ],
  //     context: context,
  //   );
  // }
  //
  // Widget _builCertificationData(CertificationEnvironmental? detail) {
  //   if (detail == null) return const Text('No data available');
  //   final certificationDetails = detail;
  //   return customFieldForTextAndValue(
  //     false,
  //     fields: [
  //       ['Certification Basis', certificationDetails.certificationBasis],
  //       ['Special Conditions', certificationDetails.specialConditions],
  //       ['Noise Compliance', certificationDetails.noiseCompliance],
  //       ['Emissions Category', certificationDetails.emissionsCategory],
  //       ['EASA TCDS Number', certificationDetails.easa],
  //       ['FAA TCDS Number', certificationDetails.faa],
  //     ],
  //     context: context,
  //   );
  // }

  // Widget _buildSectionHeader({
  //   required String title,
  //   required bool isExpanded,
  //   required VoidCallback onTap,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 15),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: GestureDetector(
  //           onTap: onTap,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 8),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Flexible(
  //                   child: Text(
  //                     title.toUpperCase(),
  //                     style: AppTextStyles.bold(16).copyWith(
  //                       height: 1.0,
  //                       color: AppColors.primaryValueColour,
  //                     ),
  //
  //                     // style: const TextStyle(
  //                     //   fontWeight: FontWeight.bold,
  //                     //   fontSize: 12,
  //                     //   color: Color(0xFF3F3D56),
  //                     // ),
  //                   ),
  //                 ),
  //
  //                 Row(
  //                   children: [
  //                     // Text(
  //                     //   isExpanded ? "Show Less" : "Show More",
  //                     //   style: const TextStyle(fontSize: 13),
  //                     // ),
  //                     Icon(
  //                       isExpanded
  //                           ? Icons.keyboard_arrow_up
  //                           : Icons.keyboard_arrow_down,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //
  //       Divider(
  //         height: 0,
  //         color: AppColors.separatorColourAppBar,
  //         thickness: 2,
  //         indent: 20,
  //         endIndent: 20,
  //       ),
  //       if (isExpanded) const SizedBox(height: 20),
  //     ],
  //   );
  // }
  //
  // Widget _buildExpandableSection({
  //   required String title,
  //   required bool isExpanded,
  //   required VoidCallback onToggle,
  //   required Widget content,
  // }) {
  //   return Column(
  //     children: [
  //       _buildSectionHeader(
  //         title: title,
  //         isExpanded: isExpanded,
  //         onTap: onToggle,
  //       ),
  //       isExpanded
  //           ? Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20),
  //               child: content,
  //             )
  //           : const SizedBox.shrink(),
  //       if (isExpanded)
  //         const Divider(
  //           height: 0,
  //           color: AppColors.separatorColourAppBar,
  //           thickness: 3,
  //         ),
  //     ],
  //   );
  // }
}
