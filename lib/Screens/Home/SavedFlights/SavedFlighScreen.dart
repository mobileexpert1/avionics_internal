import 'package:avionics_internal/Constants/ApiClass/shared_prefs_helper.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../CustomFiles/CustomTabBar.dart';
import '../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../../bloc/MapSection/flight_map_detailModel.dart';
import '../../../bloc/home/SavedFlighDetails/savedFlight_cubit.dart';
import '../../../bloc/home/SavedFlighDetails/savedFlight_state.dart';
import '../../MapSection/MapHelpers/FlightDetailScreen.dart';
import '../HomeAirbus/AirCraftSection/AirCraftDetailScreen.dart';

class SavedFlighScreen extends StatefulWidget {
  final bool showTabs;
  final FlightAircraftDetail? flightDetail;

  const SavedFlighScreen({super.key, this.showTabs = true, this.flightDetail});

  @override
  State<SavedFlighScreen> createState() => _SavedFlighScreenState();
}

class _SavedFlighScreenState extends State<SavedFlighScreen> {
  int _currentTabIndex = 0;
  final List<String> _tabTitles = ['SAVED', 'FAVORITE'];

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

    if (localKey.isNotEmpty) {
      return;
    }

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

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final isSavedTab = _currentTabIndex == 0;
          final isFavorite = item.isFavorite == true;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSavedTab
                          ? AppColors.saveButtonColour
                          : AppColors.saveButtonColour,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSavedTab || isFavorite)
                          Icon(
                            Icons.bookmark_remove,
                            color: Colors.white,
                            size: kIsWeb ? 22 : 24,
                          ),
                        if (isFavorite) const SizedBox(width: 8),
                        if (!isSavedTab || isFavorite)
                          Icon(
                            Icons.do_disturb_alt_outlined,
                            color: Colors.white,
                            size: kIsWeb ? 22 : 24,
                          ),
                      ],
                    ),
                  ),
                ),
                Slidable(
                  key: ValueKey(item.id),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.15,
                    children: [
                      CustomSlidableAction(
                        onPressed: (_) async {
                          final cubit = context.read<AllPlanesCubit>();
                          if (isSavedTab) {
                            await cubit.planFavOrUnfav(
                              item.id.toString(),
                              context,
                            );
                          } else {
                            await cubit.planFavOrUnfav1(
                              item.id,
                              item.callsign,
                              item.flightId,
                              item.flightNumber,
                              context,
                            );
                          }
                          setState(() {
                            list.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.transparent,
                        child: const SizedBox.shrink(),
                      ),
                    ],
                  ),
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
                            builder: (_) =>
                                AirCraftDetailScreen(aircraftId: item.id),
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
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              item.image,
                              width: 100,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, _, _) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Expanded(
                          //   child: Text(
                          //     item.aircraftModel,
                          //     style: const TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //       fontSize: 16,
                          //     ),
                          //     overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                          Expanded(
                            child: Text(
                              _currentTabIndex == 0
                                  ? (item.aircraftModel ?? 'Unknown Aircraft')
                                  : (item.callsign?.isNotEmpty == true
                                        ? item.callsign!
                                        : 'Unknown Flight'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(SavedFlightState state) {
    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _currentTabIndex == 0
        ? _buildAircraftList(state.savedflight, "No saved aircraft found.")
        : _buildAircraftList(state.favorites, "No favorite aircraft found.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Saved",
        centerTitle: false,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTabs)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: CustomTabBar(
                    tabTitles: _tabTitles,
                    initialIndex: _currentTabIndex,
                    onTabSelected: (index) {
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                  ),
                ),
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
