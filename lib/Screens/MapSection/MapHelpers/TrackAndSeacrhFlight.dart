import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_state.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../../bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import '../../../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/SelectableAircraftCard.dart';
import '../../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_cubit.dart';
import '../../Home/HomeAirbus/AirCraftSection/AirCraftDetailScreen.dart';

class TrackAndSearchFlight extends StatefulWidget {
  const TrackAndSearchFlight({super.key});

  @override
  State<TrackAndSearchFlight> createState() => _AllPlanesScreenState();
}

class _AllPlanesScreenState extends State<TrackAndSearchFlight> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onSearch(String value) {
    if (value.length >= 3) {
      final cubit = context.read<MapSearchAircraftListCubit>();
      cubit.loadListOfAllLiveFlights(querySearch: value, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900), // Web max width
            child: Column(
              children: [
                const SizedBox(height: 10),
                SearchBarWidget(
                  enableBackArrow: true,
                  enableFilter: false,
                  enableCloseScreen: false,
                  controller: searchController,
                  onChanged: _onSearch,
                  searchTitle: 'Search and Track a flight...',
                  onBackButtonTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child:
                      BlocBuilder<
                        MapSearchAircraftListCubit,
                        MapSearchAircraftListState
                      >(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.flights.isEmpty) {
                            return const Center(
                              child: Text(
                                'No aircraft available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: state.flights.length,
                            itemBuilder: (context, index) {
                              final data = state.flights[index];
                              return Padding(
                                key: ValueKey(index),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.width * 0.017,
                                ),
                                child: SimpleAircraftCard(
                                  imagePath: (data.detail.logo == ""
                                      ? Image.asset(
                                          CommonUi.setPngImage(
                                            AssetsPath.aeroplaneComparison,
                                          ),
                                          width: 50,
                                          height: 120,
                                          fit: BoxFit.fill,
                                        )
                                      : CachedAnyImage(
                                          imagePath: data.detail.logo,
                                          width: 50,
                                          height: 120,
                                          contentImage: BoxFit.fill,
                                        )),

                                  model: data.detail.acType,
                                  badge: data.detail.flight ?? "",
                                  manufacturer: "",
                                  airline: "",
                                  airlineImagePath: SizedBox.shrink(),
                                  callSign: data.detail.callsign ?? "",
                                  onTap: () {
                                    Navigator.pop(context, data);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
