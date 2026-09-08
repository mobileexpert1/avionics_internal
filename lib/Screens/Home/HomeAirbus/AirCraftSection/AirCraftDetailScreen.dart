import 'dart:ui';
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
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
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
                                      top: 3,
                                      bottom: 3,
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
                                        style: AppTextStyles.regular(
                                          10,
                                        ).copyWith(color: AppColors.white),
                                        children: [
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Text(
                                              "©",
                                              style: AppTextStyles.regular(15)
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
              'Number of Passengers (Typical)',
              detail?.identification.numberOfPassengers.typical ?? 'N/A',
              true,
              "number_of_passengers_typical",
              "Aircraft",
            ],
            [
              'Number of Passengers (Max)',
              detail?.identification.numberOfPassengers.maximum ?? 'N/A',
              true,
              "number_of_passengers_maximum",
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
            [
              'Fuel Consumption (kg/h)',
              detail?.powerplant.fuel.burnRate ?? 'N/A',
              true,
              "fuel_consumption",
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
              'Length (m)',
              detail?.dimensions.lengthM ?? 'N/A',
              true,
              "length",
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
              'Cabin Width (m)',
              detail?.dimensions.cabinWidthM ?? 'N/A',
              true,
              "cabin_width",
              "Aircraft",
            ],
            [
              'Door Height (m)',
              detail?.dimensions.doorHeightM ?? 'N/A',
              true,
              "door_height",
              "Aircraft",
            ],
            [
              'Wingtip Configuration',
              detail?.dimensions.wingtipConfiguration ?? 'N/A',
              true,
              "wingtip_configuration",
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
              'Max Zero Fuel Weight (MZFW, kg)',
              detail?.weights.zeroFuelWeight ?? 'N/A',
              true,
              "maximum_zero_fuel_weight",
              "Aircraft",
            ],
            [
              'Max Take-off Weight(MTOW, kg)',
              detail?.weights.takeoffWeight ?? 'N/A',
              true,
              "maximum_take_off_weight",
              "Aircraft",
            ],
            [
              'Max Payload (kg)',
              detail?.weights.payload ?? 'N/A',
              true,
              "maximum_payload",
              "Aircraft",
            ],
            [
              'Max Landing Weight(MLW, kg)',
              detail?.weights.landingWeight ?? 'N/A',
              true,
              "maximum_landing_weight",
              "Aircraft",
            ],
            [
              'Baggage or Cargo Volume (m³)',
              detail?.weights.baggage.maximum ?? 'N/A',
              true,
              "maximum_baggage_or_cargo_volume",
              "Aircraft",
            ],
            // [
            //   'Minimum Baggage or Cargo Volume (m³)',
            //   detail?.weights.baggage.minimum ?? 'N/A',
            //   true,
            //   "minimum_baggage_or_cargo_volume",
            //   "Aircraft",
            // ],
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
              'Max Rate of Climb(fpm)',
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
              'Max Speed (VMO/MMO, kts/Mach)',
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
              'Min Clean Speed (kts)',
              detail?.performance.minCleanSpeed ?? 'N/A',
              true,
              "minimum_clean_speed",
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
              'Approach Category',
              detail?.performance.approachCategory ?? 'N/A',
              true,
              "approach_category",
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
              'Landing Distance (m)',
              detail?.performance.landingDistance ?? 'N/A',
              true,
              "landing_distance",
              "Aircraft",
            ],

            [
              'Runway Length Required (m)',
              detail?.performance.runwayRequired ?? 'N/A',
              true,
              "runway_length_required",
              "Aircraft",
            ],
            [
              'Stall Speed (kts)',
              detail?.performance.stallSpeed ?? 'N/A',
              true,
              "stall_speed",
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
              'Max Crosswind (Degraded Law, kts)',
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
              'Tailwind Limit (Flaps ≤10°)',
              detail?.operationalLimitations.maxTailwindTakeoff ?? 'N/A',
              true,
              "tailwind_limit",
              "Aircraft",
            ],
            // [
            //   'Max Tailwind Takeoff (kts)',
            //   detail?.operationalLimitations.maxTailwindTakeoff ?? 'N/A',
            //   true,
            //   "max_tailwind_take_off",
            //   "Aircraft",
            // ],
            [
              'Field Elevation Limit (ft)',
              detail?.operationalLimitations.fieldElevationLimit ?? 'N/A',
              true,
              "field_elevation_limit",
              "Aircraft",
            ],
            [
              'Max Runway Altitude (ft)',
              detail?.operationalLimitations.maxRunwayAltitude ?? 'N/A',
              true,
              "maximum_runway_altitude",
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
              'Certified Autoland',
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
          ],
          context: context,
        );
    }
    return Container();
  }
}
