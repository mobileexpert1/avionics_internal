import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/Custom_widget.dart';
import '../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../bloc/Home/AirCraftDetail/airCraftDetail_model.dart';
import '../../../bloc/Home/AirCraftDetail/airCraftDetail_state.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../bloc/MapSection/flight_map_detailModel.dart';
import '../../../bloc/MapSection/flight_map_repository.dart';

class FlightDetailScreenForMapSection extends StatefulWidget {
  final String ICAOType;
  final FlightAircraftDetail? flightDetail;
  final bool fromSavedFlight;
  final String? flightNumber;
  final String? callsign;
  final String? flightId;

  const FlightDetailScreenForMapSection({
    super.key,
    required this.ICAOType,
    this.flightDetail,
    this.fromSavedFlight = false,
    this.flightNumber,
    this.callsign,
    this.flightId,
  });

  @override
  State<FlightDetailScreenForMapSection> createState() =>
      _FlightDetailScreenForMapSectionState();
}

class _FlightDetailScreenForMapSectionState
    extends State<FlightDetailScreenForMapSection> {
  int mainTab = 0;
  int subTab = 0;

  final mainTabs = ["Live Information", "Encyclopedic Information"];

  final subTabs = [
    "Identification & Position",
    "Flight Plan",
    "Tracking Status",
  ];

  final sub2Tabs = [
    "IDENTIFICATION & CLASSIFICATION",
    "POWERPLANT & PROPULSION",
    "DIMENSIONS",
    "WEIGHTS",
    "PERFORMANCE",
    "OPERATIONAL LIMITATIONS",
    "LANDING GEAR",
    "CERTIFICATION",
  ];

  double progress = 0.6;

  List<String> get activeTabs {
    return mainTab == 0 ? subTabs : sub2Tabs;
  }

  FlightAircraftDetail? _currentFlightDetail;
  bool _isLoadingFullDetails = false;

  @override
  void initState() {
    super.initState();
    _currentFlightDetail = widget.flightDetail;

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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            isForComparison: true,
            title: _currentFlightDetail?.callsign?.isNotEmpty ?? false
                ? _currentFlightDetail!.callsign!
                : widget.callsign?.isNotEmpty ?? false
                ? widget.callsign!
                : 'N/A',
            centerTitle: false,
            leftButton: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
          body: Column(
            children: [
              Container(
                height: 40,
                color: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth = constraints.maxWidth / mainTabs.length;
                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          left: tabWidth * mainTab,
                          width: tabWidth,
                          top: 5,
                          bottom: 0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: const BoxDecoration(
                              color: AppColors.extraDarkYellow,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          children: List.generate(mainTabs.length, (index) {
                            final isSelected = mainTab == index;

                            return SizedBox(
                              width: tabWidth,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mainTab = index;
                                    subTab = 0;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      mainTabs[index],
                                      style: AppTextStyles.regular(15).copyWith(
                                        height: 1.0,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Container(height: 5, color: AppColors.extraDarkYellow),

              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: activeTabs.length,
                  padding: EdgeInsets.zero,
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
                      onTap: () => setState(() => subTab = index),
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Text(
                          activeTabs[index],
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

              if (mainTab == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.liveTrackImage),
                        fit: BoxFit.fill,
                        height: 20,
                        width: 25,
                      ),
                      SizedBox(width: 6),
                    ],
                  ),
                ),

              if (mainTab == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildFlightDataSection(context),
                ),

              if (_currentFlightDetail != null) ...[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _getTabContent(_currentFlightDetail!, details),
                  ),
                ),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        if (subTab > 0) {
                          setState(() => subTab--);
                        }
                      },
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: List.generate(activeTabs.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: subTab == index
                                  ? Colors.white
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        if (subTab < activeTabs.length - 1) {
                          setState(() => subTab++);
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

  Widget _cityColumn(
    String city,
    String code,
    String time, {
    bool isRight = false,
  }) {
    return Column(
      crossAxisAlignment: isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: AppTextStyles.regular(
            16,
          ).copyWith(height: 1.0, color: AppColors.black),
        ),
        SizedBox(height: 8),
        Text(
          code,
          style: AppTextStyles.bold(
            24,
          ).copyWith(height: 1.0, color: AppColors.black),
        ),
        SizedBox(height: 8),
        Text(
          time,
          style: AppTextStyles.regular(
            14,
          ).copyWith(height: 1.0, color: AppColors.grayMedium),
        ),
      ],
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

    // === Time & Progress Logic ===
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

      if (total > 0) {
        progress = (elapsed / total).clamp(0.0, 1.0);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cityColumn(departureCity, departureIata, timeSinceTakeoff),
              SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey,
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
                          '$groundSpeed km/h',
                          style: AppTextStyles.regular(
                            14,
                          ).copyWith(height: 1.0, color: AppColors.primaryBlue),
                        ),
                        const SizedBox(width: 10),
                        const Text("•", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text(
                          '$altitude m',
                          style: AppTextStyles.regular(
                            14,
                          ).copyWith(height: 1.0, color: AppColors.primaryBlue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10),
              _cityColumn(
                arrivalCity,
                arrivalIata,
                timeToArrival,
                isRight: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Divider(
          height: 0,
          thickness: 1,
          color: AppColors.dividerLineColour,
        ),

        const SizedBox(height: 15),
      ],
    );
  }

  Widget _getTabContent(FlightAircraftDetail flight, AircraftResult? detail) {
    final screenHeight = MediaQuery.of(context).size.height;
    final aircraftData = context
        .read<AirCraftDetailCubit>()
        .state
        .airCraftDetails
        ?.results;
    final hasValidImages =
        aircraftData?.images != null && aircraftData!.images.isNotEmpty;
    if (mainTab == 0) {
      switch (subTab) {
        case 0:
          return _buildFieldRows([
            ['Call Sign', flight.callsign ?? 'N/A'],
            ['Flight Code', flight.flightNumber ?? 'N/A'],
            ['Squawk', flight.squawk ?? 'N/A', true],
            ['ADS-B Hex', flight.hex ?? 'N/A', true],
            ['Latitude', flight.latitude.toStringAsFixed(6) ?? 'N/A', true],
            ['Longitude', flight.longitude.toStringAsFixed(6) ?? 'N/A', true],
            ['Registration', flight.registration ?? 'N/A', true],
            ['Data Source', flight.source ?? 'N/A', true],
          ]);
        case 1:
          return _buildFieldRows([
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
            ['Airport of Departure', flight.originAirport?.city ?? 'N/A', true],
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
            ['Landing Runway', flight.landingRunway?.toString() ?? 'N/A', true],
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
            ['Carrier Operating', flight.operatingAs ?? 'N/A', true],
          ]);
        case 2:
          return _buildFieldRows([
            ['First seen', flight.firstSeen?.toString() ?? 'N/A'],
            ['Last seen', flight.lastSeen?.toString() ?? 'N/A'],
            ['Landed', flight.flightEnded == true ? "Yes (Ended)" : "No"],
            ['Landing Time', flight.landingTime?.toString() ?? 'N/A'],
          ]);
      }
    } else {
      switch (subTab) {
        case 0:
          return Column(
            children: [
              if (hasValidImages) const SizedBox(height: 10),
              _buildImageCoverScroller(screenHeight, aircraftData!.images!),
              if (hasValidImages) const SizedBox(height: 30),
              _buildFieldRows([
                [
                  'ICAO Type Code',
                  detail?.identification.icaoTypeCode ??
                      _currentFlightDetail?.type ??
                      'N/A',
                ],
                [
                  'Aircraft Manufacturer',
                  detail?.identification.manufacturer ?? 'N/A',
                ],
                [
                  'Aircraft Model',
                  detail?.identification.aircraftModel ?? 'N/A',
                ],
                ['Aircraft Role', detail?.identification.aircraftRole ?? 'N/A'],
                [
                  'Aircraft Type',
                  detail?.identification.aircraftType ??
                      _currentFlightDetail?.type ??
                      'N/A',
                ],
                [
                  'Wake Turbulence Category',
                  detail?.identification.wakeTurbulenceCategory ?? 'N/A',
                ],
                [
                  'Civilian / Military / Dual Use',
                  detail?.identification.civilianMilitaryOrDualUse ?? 'N/A',
                ],
                [
                  'Country of Origin',
                  detail?.identification.countryOfOrigin ?? 'N/A',
                ],
                [
                  'Date of Maiden Flight',
                  detail?.identification.dateOfMaidenFlight ?? 'N/A',
                ],
                [
                  'Year of Introduction',
                  detail?.identification.yearOfIntroduction ?? 'N/A',
                ],
                [
                  'Production Status',
                  detail?.identification.productionStatus ?? 'N/A',
                ],
                [
                  'Avionics System Name',
                  detail?.identification.avionicsSystem ?? 'N/A',
                ],
                [
                  'Number of Crew',
                  detail?.identification.numberOfCrew ?? 'N/A',
                ],
                [
                  'Number of Passengers (Typical)',
                  detail?.identification.numberOfPassengers.typical ?? 'N/A',
                ],
                [
                  'Number of Passengers (Maximum)',
                  detail?.identification.numberOfPassengers.maximum ?? 'N/A',
                ],
              ]),
            ],
          );

        case 1:
          return _buildFieldRows([
            [
              'Number of Engines',
              detail?.powerplant.numberOfEngines.toString() ?? 'N/A',
            ],
            ['Fuel Consumption', detail?.powerplant.fuel.burnRate ?? 'N/A'],
            ['Manufacturer', detail?.powerplant.engine.manufacturer ?? 'N/A'],
            ['Model', detail?.powerplant.engine.model ?? 'N/A'],
            ['Engine Type', detail?.powerplant.engine.engineType ?? 'N/A'],
            [
              'Thrust Per Engine (kN)',
              detail?.powerplant.engine.thrust ?? 'N/A',
            ],
            [
              'Physical Engine Code',
              detail?.powerplant.engine.physicalEngineCode ?? 'N/A',
            ],
            ['APU Type', detail?.powerplant.apuType ?? 'N/A'],
            ['Fuel Type', detail?.powerplant.fuel.fuelType ?? 'N/A'],
            ['Fuel Additives', detail?.powerplant.fuel.fuelAdditives ?? 'N/A'],
            ['Fuel Capacity', detail?.powerplant.fuel.capacity ?? 'N/A'],
          ]);
        case 2:
          return _buildFieldRows([
            ['Wingspan (m)', detail?.dimensions.wingspanM ?? 'N/A'],
            ['Cabin Width (m)', detail?.dimensions.cabinWidthM ?? 'N/A'],
            ['Length (m)', detail?.dimensions.lengthM ?? 'N/A'],
            [
              'Wingtip Configuration',
              detail?.dimensions.wingtipConfiguration ?? 'N/A',
            ],
            ['Height (m)', detail?.dimensions.heightM ?? 'N/A'],
            ['Wing Area (m²)', detail?.dimensions.wingAreaM2 ?? 'N/A'],
            ['Door Height (m)', detail?.dimensions.doorHeightM ?? 'N/A'],
          ]);
        case 3:
          return _buildFieldRows([
            [
              'Operating Empty Weight (kg)',
              detail?.weights.emptyWeight ?? 'N/A',
            ],
            [
              'Maximum Zero Fuel Weight (kg)',
              detail?.weights.zeroFuelWeight ?? 'N/A',
            ],
            [
              'Maximum Takeoff Weight (kg)',
              detail?.weights.takeoffWeight ?? 'N/A',
            ],
            ['Max Payload (kg)', detail?.weights.payload ?? 'N/A'],
            [
              'Maximum Landing Weight (kg)',
              detail?.weights.landingWeight ?? 'N/A',
            ],
            [
              'Maximum Baggage or Cargo Volume (m³)',
              detail?.weights.baggage.maximum ?? 'N/A',
            ],
            [
              'Minimum Baggage or Cargo Volume (m³)',
              detail?.weights.baggage.minimum ?? 'N/A',
            ],
          ]);
        case 4:
          return _buildFieldRows([
            [
              'Takeoff Speed (kts)',
              detail?.performance.takeoffSpeedKts ?? 'N/A',
            ],
            [
              'Takeoff Distance (m)',
              detail?.performance.takeoffDistanceM ?? 'N/A',
            ],
            [
              'Initial Rate of Climb (fpm)',
              detail?.performance.climbInitialFpm ?? 'N/A',
            ],
            [
              'Average Rate of Climb (fpm)',
              detail?.performance.climbAvgFpm ?? 'N/A',
            ],
            [
              'Maximum Rate of Climb (fpm)',
              detail?.performance.climbMaxFpm ?? 'N/A',
            ],
            [
              'Service Ceiling (ft)',
              detail?.performance.serviceCeiling ?? 'N/A',
            ],
            [
              'Max Certified Altitude (ft)',
              detail?.performance.maxCertifiedAltitude ?? 'N/A',
            ],
            ['Cruise Speed (kt)', detail?.performance.cruiseSpeedKt ?? 'N/A'],
            ['Cruise (Mach)', detail?.performance.cruiseMach ?? 'N/A'],
            ['Maximum Speed', detail?.performance.maxCruiseSpeed ?? 'N/A'],
            ['VMO (kts)', detail?.performance.vmoKts ?? 'N/A'],
            ['MMO (Mach)', detail?.performance.mmoMach ?? 'N/A'],
            [
              'Range (NM / km)',
              "${detail?.performance.range.normalRangeNm ?? 'N/A'} NM / ${detail?.performance.range.normalRangeKm ?? 'N/A'} Km",
            ],
            [
              'Ferry Range (if applicable)',
              detail?.performance.range.ferryRangeNm ?? 'N/A',
            ],
            [
              'Initial Rate of Descent (fpm)',
              detail?.performance.descentInitialFpm ?? 'N/A',
            ],
            [
              'Average Rate of Descent (fpm)',
              detail?.performance.descentAvgFpm ?? 'N/A',
            ],
            [
              'Minimum Clean Speed (kts)',
              detail?.performance.minCleanSpeed ?? 'N/A',
            ],
            [
              'Approach Speed (kts)',
              detail?.performance.approachSpeed ?? 'N/A',
            ],
            [
              'Approach Category',
              detail?.performance.approachCategory ?? 'N/A',
            ],
            ['Landing Speed (kts)', detail?.performance.landingSpeed ?? 'N/A'],
            [
              'Landing Distance (m)',
              detail?.performance.landingDistance ?? 'N/A',
            ],
            [
              'Runway Length Required (m)',
              detail?.performance.runwayRequired ?? 'N/A',
            ],
            ['Stall Speed (kts)', detail?.performance.stallSpeed ?? 'N/A'],
          ]);
        case 5:
          return _buildFieldRows([
            [
              'Runway Slope Limit (%)',
              detail?.operationalLimitations.runwaySlopeLimit ?? 'N/A',
            ],
            [
              'Max Crosswind Normal Law (kts)',
              detail?.operationalLimitations.maxCrosswindNormal ?? 'N/A',
            ],
            [
              'Maximum Crosswind (Degraded Law)',
              detail?.operationalLimitations.maxCrosswindDegraded ?? 'N/A',
            ],
            [
              'Max Tailwind Landing (kts)',
              detail?.operationalLimitations.maxTailwindLanding ?? 'N/A',
            ],
            [
              'Max Tailwind Takeoff (kts)',
              detail?.operationalLimitations.maxTailwindTakeoff ?? 'N/A',
            ],
            [
              'Field Elevation Limit (ft)',
              detail?.operationalLimitations.fieldElevationLimit ?? 'N/A',
            ],
            [
              'Maximum Runway Altitude (ft)',
              detail?.operationalLimitations.maxRunwayAltitude ?? 'N/A',
            ],
            [
              'Tailwind Limit (Flaps ≤10°)',
              detail?.operationalLimitations.maxTailwindTakeoff ?? 'N/A',
            ],
            [
              'Supported Categories',
              detail?.operationalLimitations.autoland.supportedCategories ??
                  'N/A',
            ],
            [
              'Certified Autoland Level',
              detail?.operationalLimitations.autoland.certifiedLevel ?? 'N/A',
            ],
          ]);
        case 6:
          return _buildFieldRows([
            ['Landing Gear Configuration', detail?.landingGear.type ?? 'N/A'],
            ['Number of Wheels', detail?.landingGear.numberOfWheels ?? 'N/A'],
            ['Tyre Size (inches)', detail?.landingGear.tyreSize ?? 'N/A'],
            ['Tyre Pressure (psi)', detail?.landingGear.tyrePressure ?? 'N/A'],
          ]);
        case 7:
          return _buildFieldRows([
            [
              'Certification Basis',
              detail?.certification.certificationBasis ?? 'N/A',
            ],
            [
              'Special Conditions',
              detail?.certification.specialConditions ?? 'N/A',
            ],
            [
              'Noise Compliance',
              detail?.certification.noiseCompliance ?? 'N/A',
            ],
            [
              'Emissions Category',
              detail?.certification.emissionsCategory ?? 'N/A',
            ],
            ['EASA TCDS Number', detail?.certification.easa ?? 'N/A'],
            ['FAA TCDS Number', detail?.certification.faa ?? 'N/A'],
          ]);
      }
    }
    return Container();
  }

  Widget _buildFieldRows(List<List<dynamic>> fields) {
    return Column(
      children: List.generate((fields.length / 2).ceil(), (i) {
        final first = fields[i * 2];
        final second = i * 2 + 1 < fields.length ? fields[i * 2 + 1] : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            children: [
              Expanded(
                child: customFieldWithNewModifications(
                  fontStyleLabel: AppTextStyles.regular(14).copyWith(
                    height: 1.0,
                    color: AppColors.grayMedium,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1.2,
                  ),
                  label: first[0],
                  text: first[1],
                  labelColor: AppColors.grayMedium,
                  textColor: AppColors.primaryValueColour,
                  showInfoIcon: true,
                  onInfoTap: () {
                    showAutoDismissDialog(context, first[0], first[1]);
                  },
                  fontStyleText: AppTextStyles.bold(
                    16,
                  ).copyWith(height: 1.0, color: AppColors.primaryValueColour),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: second != null
                    ? customFieldWithNewModifications(
                        fontStyleText: AppTextStyles.bold(16).copyWith(
                          height: 1.0,
                          color: AppColors.primaryValueColour,
                        ),
                        label: second[0],
                        text: second[1],
                        labelColor: AppColors.grayMedium,
                        textColor: AppColors.primaryValueColour,
                        showInfoIcon: true,
                        onInfoTap: () {
                          showAutoDismissDialog(context, second[0], second[1]);
                        },
                        fontStyleLabel: AppTextStyles.regular(14).copyWith(
                          height: 1.0,
                          color: AppColors.grayMedium,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.2,
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
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
      barrierColor: Colors.black54,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F4B),
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        title,
                        style: AppTextStyles.regular(15).copyWith(
                          height: 1.0,
                          color: AppColors.greyFlightDetailText,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(height: 1, color: Colors.white24),

                    const SizedBox(height: 20),

                    Text(
                      content,
                      style: AppTextStyles.regular(
                        15,
                      ).copyWith(height: 1.0, color: AppColors.white),
                    ),
                  ],
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white54),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
