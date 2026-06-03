import 'package:avionics_internal/Constants/ApiClass/shared_prefs_helper.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Helpers/CacheManger/CachedImageFile.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../../bloc/MapSection/flight_map_detailModel.dart';
import '../../../../bloc/home/SavedFlighDetails/savedFlight_cubit.dart';
import '../../../../bloc/home/SavedFlighDetails/savedFlight_state.dart';
import '../../../Home/HomeAirbus/AirCraftSection/AirCraftDetailScreen.dart';
import '../../../MapSection/MapHelpers/FlightDetailScreen.dart';
import '../../../MapSection/MapHelpers/FlightDetailScreenForMapSection.dart';
import '../../../WilcoBoat/ChatHistoryScreen.dart';

class SavedFlighScreen extends StatefulWidget {
  final bool showTabs;
  final FlightAircraftDetail? flightDetail;

  const SavedFlighScreen({super.key, this.showTabs = true, this.flightDetail});

  @override
  State<SavedFlighScreen> createState() => _SavedFlighScreenState();
}

class _SavedFlighScreenState extends State<SavedFlighScreen> {
  int _currentTabIndex = 0;

  final List<String> mainTabs = ['Bookmark', 'Favorite'];
  int mainTab = 0;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<SavedFlightCubit>().loadSavedAndFavoriteFlights();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.savedFlightScreen,
    );
  }

  Future<void> _GetFr24Key() async {
    final localKey = await SharedPrefsHelper.getMapKeyValuesForApi();
    if (localKey.isNotEmpty) return;

    try {
      final response = await FlightRepository().getMapKeyValueFromServer();
      if (response.data.fr24 != null && response.data.fr24!.isNotEmpty) {
        await SharedPrefsHelper.seMapKeyValuesFromServer(response.data.fr24!);
      }
    } catch (e) {
      debugPrint("FR24 key fetch failed: $e");
    }
  }

  Widget _buildAircraftList(List<dynamic> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.airplanemode_inactive,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(emptyMessage, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final isSavedTab = _currentTabIndex == 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () async {
              if (isSavedTab) {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.airCraftDetailScreen,
                  FirebaseEvents.savedFlightScreen,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AirCraftDetailScreen(aircraftId: item.id),
                  ),
                );
              } else {
                AnalyticsService.instance.buttonPressed(
                  FirebaseEvents.flightAircraftDetail,
                  FirebaseEvents.savedFlightScreen,
                );
                await _GetFr24Key();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<FlightMapCubit>(),
                      child: FlightDetailScreen(
                        ICAOType: item.icaoTypeCode ?? '',
                        flightNumber: item.flightNumber,
                        callsign: item.callsign,
                        flightId: item.flightId,
                        fromSavedFlight: true,
                        flightDetail: FlightAircraftDetail(
                          icaoTypeCode: item.icaoTypeCode,
                          aircraftModel: item.aircraftModel,
                          image: item.image,
                          id: item.id,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      // if (isSavedTab)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedAnyImage(
                          isForPlaneList: true,
                          imagePath: isSavedTab == true
                              ? item.image
                              : item.airline?.logo ?? '',
                          width: isSavedTab == true ? 100 : 80,
                          height: isSavedTab == true ? 50 : 40,
                          contentImage: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: isSavedTab
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.aircraftModel ??
                                            'Unknown Aircraft',
                                        style: AppTextStyles.bold(16).copyWith(
                                          height: 1.4,
                                          color: AppColors.textColour,
                                          letterSpacing: 0.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 8),

                                      if (item.icaoTypeCode?.isNotEmpty ==
                                          true) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0.2,
                                            ),
                                          ),
                                          child: Text(
                                            item.icaoTypeCode!,
                                            style: AppTextStyles.bold(12)
                                                .copyWith(
                                                  height: 1.0,
                                                  color: AppColors.primaryDark,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4),
                                  if (item.callsign?.isNotEmpty == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1C2340),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.callsign!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          final confirmed = await _deleteChat(
                            item.id.toString(),
                            isSavedTab,
                          );

                          if (!confirmed) return;

                          final cubit = context.read<AllPlanesCubit>();

                          if (isSavedTab) {
                            await cubit.planFavOrUnfav(item.id, context);
                          } else {
                            await cubit.planFavOrUnfav1(
                              item.id,
                              item.callsign,
                              item.flightId,
                              item.flightNumber,
                              context,
                            );
                          }

                          if (mounted) {
                            setState(() {
                              list.removeAt(index);
                            });
                          }
                        },
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(
                            isSavedTab
                                ? AssetsPath.bookMarkIcon
                                : AssetsPath.highlightStar,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _deleteChat(String sessionId, bool isComeFromBookMark) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomDialog(
        title: isComeFromBookMark
            ? 'Remove from Bookmark'
            : 'Remove from Favourite',
        description: 'Are you sure you want to remove this item?',
        positiveButtonText: 'Yes',
        positiveColor: AppColors.blackBoxColorForGame,
        onPositiveTap: () {
          Navigator.pop(dialogContext, true);
        },
      ),
    );

    return shouldDelete == true;
  }

  Widget _buildTabContent(SavedFlightState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return _currentTabIndex == 0
        ? _buildAircraftList(state.savedflight, "No saved aircraft found.")
        : _buildAircraftList(state.favorites, "No favorite aircraft found.");
  }

  Widget _buildBrowserTabBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                              _currentTabIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isForComparison: true,
        title: "Saved",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTabs) _buildBrowserTabBar(),

              Expanded(
                child: BlocConsumer<SavedFlightCubit, SavedFlightState>(
                  listener: (context, state) {
                    if (state.status == CommonApiStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? "Something went wrong",
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildTabContent(state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
