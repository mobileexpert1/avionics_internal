import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/SearchBarWidget.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/SelectableAircraftCard.dart';
import '../../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_cubit.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 900),
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
                          if (state.status == CommonApiStatus.failure && state.isLoading == false) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMessage!)),
                                );
                              }
                            });
                          }

                          if (state.status == CommonApiStatus.success &&
                              state.selectedFlight != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                Navigator.pop(context, state.selectedFlight);
                              }
                            });
                          }
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
                                  imagePath:
                                      (data.aircraftDetails?.image == null ||
                                          data.aircraftDetails?.image == ""
                                      ? Image.asset(
                                          CommonUi.setPngImage(
                                            AssetsPath.aeroplaneComparison,
                                          ),
                                          width: 50,
                                          height: 120,
                                          fit: BoxFit.fill,
                                        )
                                      : CachedAnyImage(
                                          imagePath:
                                              data.aircraftDetails!.image,
                                          width: 50,
                                          height: 120,
                                          contentImage: BoxFit.fill,
                                        )),
                                  model:
                                      "${data.aircraftDetails?.aircraftModel ?? " "} ",
                                  badge:
                                      (data
                                              .aircraftDetails
                                              ?.icaoTypeCode
                                              .isNotEmpty ??
                                          false)
                                      ? data.aircraftDetails!.icaoTypeCode
                                      : (data.detail.acType.isNotEmpty ?? false
                                            ? data.detail.acType
                                            : ""),

                                  // data.aircraftDetails?.icaoTypeCode ??
                                  // data.type,
                                  manufacturer:
                                      data
                                          .aircraftDetails
                                          ?.manufacturer
                                          ?.companyName ??
                                      "",
                                  airline: "",
                                  airlineImagePath:
                                      (data
                                                  .aircraftDetails
                                                  ?.manufacturer
                                                  ?.logo ==
                                              null ||
                                          data
                                                  .aircraftDetails
                                                  ?.manufacturer
                                                  ?.logo ==
                                              ""
                                      ? SizedBox.shrink()
                                      : CachedAnyImage(
                                          imagePath:
                                              data
                                                  .aircraftDetails
                                                  ?.manufacturer
                                                  ?.logo ??
                                              "",
                                          width: 50,
                                          height: 120,
                                          contentImage: BoxFit.fill,
                                        )),
                                  callSign: data.detail.callsign,
                                  onTap: () {
                                    final cubit = context
                                        .read<MapSearchAircraftListCubit>();
                                    cubit.getCurrentSearchFlight(data, context);
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
