import 'package:flutter/foundation.dart';
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
import '../../../Helpers/CacheManger/CachedImageFile.dart';
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
  final bool isShowImageContent;
  final String? flightNumber;
  final String? callsign;
  final String? flightId;

  const FlightDetailScreenForMapSection({
    super.key,
    required this.ICAOType,
    this.flightDetail,
    this.fromSavedFlight = false,
    this.isShowImageContent = false,
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
  double progress = 0.6;
  bool _isLoadingProgress = false;

  // ── Separate controllers for image carousel and tab swipe ──
  int _currentImageIndex = 0;
  late final PageController _imagePageController = PageController();
  late final PageController _tabPageController = PageController();

  bool _isLoadingFullDetails = false;
  FlightAircraftDetail? _currentFlightDetail;

  final ScrollController _subTabScrollController = ScrollController();

  final mainTabs = ["Live", "Encyclopedia"];
  final subTabs = [
    "Identification & Position",
    "Flight Plan",
    "Tracking Status",
  ];

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

  List<String> get activeTabs {
    return mainTab == 0 ? subTabs : sub2Tabs;
  }

  final liveTabKeys = List.generate(3, (_) => GlobalKey());
  final encyclopediaTabKeys = List.generate(8, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _currentFlightDetail = widget.flightDetail;

    context.read<AirCraftDetailCubit>().fetchAircraftDetailByICAOCode(
      widget.ICAOType,
      context,
    );

    if (widget.fromSavedFlight) {
      _loadFullFlightDetailsFromSaved();
    }

    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.flightDetailScreen,
    );

    context.read<AirCraftDetailCubit>().fetchAircraftParams(context, 1);
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _tabPageController.dispose();
    _subTabScrollController.dispose();
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
            latitude: liveFlight.latitude,
            longitude: liveFlight.longitude,
            altitude: liveFlight.altitude,
            groundSpeed: liveFlight.groundSpeed,
            vspeed: liveFlight.verticalSpeed,
            track: liveFlight.track,
            callsign: liveFlight.callSign,
            squawk: liveFlight.squawk,
            source: liveFlight.source,
            hex: liveFlight.hex,
            firstSeen: liveFlight.firstSeen ?? fullFlightDetail.firstSeen,
            lastSeen: liveFlight.lastSeen ?? fullFlightDetail.lastSeen,
            flightEnded: liveFlight.flightEnded ?? fullFlightDetail.flightEnded,
            landingTime: liveFlight.landingTime ?? fullFlightDetail.landingTime,
            eta: liveFlight.eta ?? fullFlightDetail.eta,
            takeoffTime: liveFlight.takeoffTime ?? fullFlightDetail.takeoffTime,
            flightTime: liveFlight.flightTime ?? fullFlightDetail.flightTime,
            departureIcao: liveFlight.departureIcao,
            departureIata: liveFlight.departureIata,
            arrivalIcao: liveFlight.arrivalIcao,
            arrivalIata: liveFlight.arrivalIata,
            registration: liveFlight.registration,
            type: liveFlight.type,
            paintedAs: liveFlight.paintedAs,
            operatingAs: liveFlight.operatingAs,
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

  void _scrollToSelectedSubTab(int index) {
    final key = mainTab == 0 ? liveTabKeys[index] : encyclopediaTabKeys[index];

    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,

        alignment: index == 0
            ? 1.0
            : index == activeTabs.length - 1
            ? 1.0
            : 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AirCraftDetailCubit, AirCraftDetailState>(
      builder: (context, state) {
        if (state.isLoading || _isLoadingProgress == true) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final details = state.airCraftDetails?.results;

        final hasValidImages =
            details?.images != null && details!.images!.isNotEmpty;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            isForComparison: true,
            title: mainTab == 0
                ? _currentFlightDetail?.callsign?.isNotEmpty ?? false
                      ? _currentFlightDetail!.callsign!
                      : widget.callsign?.isNotEmpty ?? false
                      ? widget.callsign!
                      : 'N/A'
                : _currentFlightDetail?.aircraftModel?.isNotEmpty ?? false
                ? _currentFlightDetail!.aircraftModel!
                : widget.callsign?.isNotEmpty ?? false
                ? widget.callsign!
                : 'N/A',
            centerTitle: false,
            leftButton: IconButton(
              icon: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.backArrowButton),
                fit: BoxFit.cover,
              ),
              onPressed: () {
                context
                    .read<AirCraftDetailCubit>()
                    .resetAllTheDataBeforeEnter();
                Navigator.pop(context);
              },
            ),
            rightButton: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () async {
                setState(() {
                  _isLoadingProgress = true;
                });
                await Future.delayed(const Duration(seconds: 1));

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
                setState(() {
                  _isLoadingProgress = false;
                });
              },
            ),
          ),
          body: Column(
            children: [
              // ── MAIN TABS (Live / Encyclopedia) ──
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: CustomPaint(
                              painter: BrowserTabPainter(
                                tabColor: AppColors.extraDarkYellow,
                                topRadius: 16.0,
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
                                  // Reset tab PageView to first page
                                  if (_tabPageController.hasClients) {
                                    _tabPageController.jumpToPage(0);
                                  }
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
                                            : Colors.white,
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

              // ── SUB TABS (scrollable header) ──
              SizedBox(
                height: 40,
                child: ListView.separated(
                  controller: _subTabScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: activeTabs.length,
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
                        key: mainTab == 0
                            ? liveTabKeys[index]
                            : encyclopediaTabKeys[index],
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

              // ── LIVE BADGE ──
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

              // ── FLIGHT PROGRESS BAR ──
              if (mainTab == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildFlightDataSection(context),
                ),

              // ── TAB CONTENT (swipeable PageView) ──
              if (_currentFlightDetail != null) ...[
                if (widget.isShowImageContent == true)
                  if (mainTab == 1 && hasValidImages)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildImageCoverScroller(
                        MediaQuery.of(context).size.height,
                        details.images!,
                      ),
                    ),

                Expanded(
                  child: PageView.builder(
                    controller: _tabPageController,
                    itemCount: activeTabs.length,
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
                            _getTabContentByIndex(
                              index,
                              _currentFlightDetail!,
                              details,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

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
                        children: List.generate(activeTabs.length, (index) {
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
                        if (subTab < activeTabs.length - 1) {
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

  // ── IMAGE CAROUSEL (uses _imagePageController) ──
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
                                left: 8,
                                bottom: 8,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
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
                bottom: 6,
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

    final departureCity = flight.originAirport?.city ?? 'N/A';
    final arrivalCity = flight.destinationAirport?.city ?? 'N/A';
    final departureIata = flight.departureIcao ?? 'N/A';
    final arrivalIata = flight.arrivalIcao ?? 'N/A';
    final groundSpeed = flight.groundSpeed ?? 0;
    final altitude = flight.altitude ?? 0;

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
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cityColumn(departureCity, departureIata, timeSinceTakeoff),
              SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    buildCustomProgressBar(progress, groundSpeed, altitude),
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

  // ── TAB CONTENT BY INDEX (replaces _getTabContent) ──
  Widget _getTabContentByIndex(
    int index,
    FlightAircraftDetail flight,
    AircraftResult? detail,
  ) {
    if (mainTab == 0) {
      switch (index) {
        case 0:
          return customFieldForTextAndValue(
            false,
            fields: [
              [
                'Call Sign',
                flight.callsign ?? 'N/A',
                true,
                "callsign_icao",
                "Live",
              ],
              [
                'Flight Code',
                flight.flightNumber ?? 'N/A',
                true,
                "flight_code",
                "Live",
              ],
              ['Squawk', flight.squawk ?? 'N/A', true, "squawk", "Live"],
              ['ADS-B Hex', flight.hex ?? 'N/A', true, "ads_b_hex", "Live"],
              [
                'Latitude',
                flight.latitude.toStringAsFixed(6),
                true,
                "latitude",
                "Live",
              ],
              [
                'Longitude',
                flight.longitude.toStringAsFixed(6),
                true,
                "longitude",
                "Live",
              ],
              [
                'Registration',
                flight.registration ?? 'N/A',
                true,
                "registration",
                "Live",
              ],
              [
                'Data Source',
                flight.source ?? 'N/A',
                true,
                "data_source",
                "Live",
              ],
            ],
            context: context,
          );
        case 1:
          return customFieldForTextAndValue(
            false,
            fields: [
              [
                'Track (°)',
                flight.track?.toString() ?? 'N/A',
                true,
                "track_degrees",
                "Live",
              ],
              [
                'Altitude (ft)',
                flight.altitude?.toString() ?? 'N/A',
                true,
                "altitude_ft",
                "Live",
              ],
              [
                'Ground Speed (kts)',
                flight.groundSpeed?.toString() ?? 'N/A',
                true,
                "ground_speed_kts",
                "Live",
              ],
              [
                'Vertical Speed (ft/min)',
                flight.vspeed?.toString() ?? 'N/A',
                true,
                "vertical_speed",
                "Live",
              ],
              [
                'Airport of Departure',
                flight.originAirport?.city ?? 'N/A',
                true,
                "airport_of_departure",
                "Live",
              ],
              [
                'Airport of Arrival',
                flight.destinationAirport?.city ?? 'N/A',
                true,
                "airport_of_destination_arrival",
                "Live",
              ],
              [
                'Take-off Time',
                flight.takeoffTime != null
                    ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(flight.takeoffTime!.toLocal())} IST'
                    : 'N/A',
                true,
                "take_off_time",
                "Live",
              ],
              [
                'Estimated Time of Arrival',
                flight.eta != null
                    ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(flight.eta!.toLocal())} IST'
                    : 'N/A',
                true,
                "estimated_time_of_arrival",
                "Live",
              ],
              [
                'Take-off Runway',
                flight.takeoffRunway?.toString() ?? 'N/A',
                true,
                "take_off_runway",
                "Live",
              ],
              [
                'Landing Runway',
                flight.landingRunway?.toString() ?? 'N/A',
                true,
                "landing_runway",
                "Live",
              ],
              [
                'Actual ground distance (km)',
                flight.actualDistance?.toString() ?? 'N/A',
                true,
                "actual_ground_distance_km",
                "Live",
              ],
              [
                'Circle distance (km)',
                flight.circleDistance?.toString() ?? 'N/A',
                true,
                "circle_distance_km",
                "Live",
              ],
              [
                'Flight Duration',
                flight.flightTime ?? 'N/A',
                true,
                "flight_duration",
                "Live",
              ],
              [
                'Operating Carrier',
                flight.operatingAs ?? 'N/A',
                true,
                "operating_carrier",
                "Live",
              ],
            ],
            context: context,
          );
        case 2:
          return customFieldForTextAndValue(
            false,
            fields: [
              [
                'First seen',
                flight.firstSeen?.toString() ?? 'N/A',
                true,
                "first_seen",
                "Live",
              ],
              [
                'Last seen',
                flight.lastSeen?.toString() ?? 'N/A',
                true,
                "last_seen",
                "Live",
              ],
              [
                'Landed',
                flight.flightEnded == true ? "Yes (Ended)" : "No",
                true,
                "landed",
                "Live",
              ],
              [
                'Landing Time',
                flight.landingTime?.toString() ?? 'N/A',
                true,
                "landing_time",
                "Live",
              ],
            ],
            context: context,
          );
      }
    } else {
      switch (index) {
        case 0:
          return customFieldForTextAndValue(
            false,
            fields: [
              [
                'ICAO Type Code',
                detail?.identification.icaoTypeCode ??
                    _currentFlightDetail?.type ??
                    'N/A',
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
              ['Aircraft Role', detail?.identification.aircraftRole ?? 'N/A',true,"aircraft_role","Aircraft"],
              ['Aircraft Type', detail?.identification.aircraftType ?? 'N/A',true,"aircraft_type","Aircraft"],
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
                'Maximum Speed (kts/Mach)',
                detail?.performance.maxCruiseSpeed ?? 'N/A',
                true,
                "maximum_speed",
                "Aircraft",
              ],

              [
                'VMO (kts)',
                detail?.performance.vmoKts ?? 'N/A',
                true,
                "vmo",
                "Aircraft",
              ],

              [
                'MMO (Mach)',
                detail?.performance.mmoMach ?? 'N/A',
                true,
                "mmo",
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
    }
    return Container();
  }
}

// ── PROGRESS BAR ──────────────────────────────────────────────────────────────
Widget buildCustomProgressBar(double progress, int groundSpeed, int altitude) {
  return Container(
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              const padding = 5.0;
              const indicatorSize = 18.0;
              final usableWidth = totalWidth - (padding * 2);
              final indicatorCenterX = padding + (usableWidth * progress);
              const overlap = 2.0;
              return Stack(
                children: [
                  Positioned(
                    left: indicatorCenterX - overlap,
                    right: padding,
                    top: 30,
                    child: Container(height: 2.5, color: Colors.grey.shade300),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    left: (indicatorCenterX - indicatorSize / 2).clamp(
                      padding,
                      totalWidth - padding - indicatorSize,
                    ),
                    top: 22,
                    child: Container(
                      width: indicatorSize,
                      height: indicatorSize,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    left: padding,
                    top: 30,
                    width: (indicatorCenterX - padding + overlap).clamp(
                      0,
                      usableWidth,
                    ),
                    child: Container(height: 2.5, color: Colors.black),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$groundSpeed kts',
              style: AppTextStyles.regular(
                14,
              ).copyWith(height: 1.0, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 10),
            const Text("•", style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 10),
            Text(
              '$altitude ft',
              style: AppTextStyles.regular(
                14,
              ).copyWith(height: 1.0, color: AppColors.primaryBlue),
            ),
          ],
        ),
      ],
    ),
  );
}

// ── BROWSER TAB PAINTER ───────────────────────────────────────────────────────
class BrowserTabPainter extends CustomPainter {
  final Color tabColor;
  final double topRadius;

  const BrowserTabPainter({required this.tabColor, required this.topRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final tr = topRadius;

    final tabPath = Path()
      ..moveTo(tr, 0)
      ..lineTo(w - tr, 0)
      ..quadraticBezierTo(w, 0, w, tr)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..lineTo(0, tr)
      ..quadraticBezierTo(0, 0, tr, 0)
      ..close();
    canvas.drawPath(tabPath, Paint()..color = tabColor);
  }

  @override
  bool shouldRepaint(BrowserTabPainter old) => tabColor != old.tabColor;
}
