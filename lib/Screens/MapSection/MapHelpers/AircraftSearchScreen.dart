import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import '../../../bloc/MapSection/MapAircraftList/aircraft_List_Data_Cubit.dart';
import '../../../bloc/MapSection/MapAircraftList/aircraft_List_Data_State.dart';

class AircraftSearchScreen extends StatelessWidget {
  final List<AircraftModel> initialSelected;
  final Function(List<AircraftModel>)? onSelectionChanged;

  const AircraftSearchScreen({
    Key? key,
    this.initialSelected = const [],
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = AircraftListDataCubit();
        cubit.initSelectedAircraft(List<AircraftModel>.from(initialSelected));
        cubit.loadSelectedAircraft();
        return cubit;
      },
      child: _AircraftSearchView(onSelectionChanged: onSelectionChanged),
    );
  }
}

class _AircraftSearchView extends StatefulWidget {
  final Function(List<AircraftModel>)? onSelectionChanged;

  const _AircraftSearchView({this.onSelectionChanged});

  @override
  State<_AircraftSearchView> createState() => _AircraftSearchViewState();
}

class _AircraftSearchViewState extends State<_AircraftSearchView> {
  late TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _notifySelectionChanged(AircraftListDataCubit cubit) {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(
        List<AircraftModel>.from(cubit.selectedAircraft),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AircraftListDataCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "    Search",
        centerTitle: false,
        rightButton: IconButton(
          onPressed: () => Navigator.pop(
            context,
            List<AircraftModel>.from(cubit.selectedAircraft),
          ),
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.closeIconSearch),
            height: 22,
            width: 22,
          ),
        ),
      ),

      body: Column(
        children: [
          SearchBarWidget(
            enableGestureMode: false,
            enableBackArrow: false,
            enableFilter: false,
            enableCloseScreen: false,
            isComeFromMapSection: false,
            controller: _searchController,
            searchTitle: 'Search Aircraft',
            onChanged: (value) {
              final query = value.trim();
              if (query.length >= 3) {
                cubit.searchAircraftByICAO(icaoCode: query, context: context);
              } else {
                cubit.clearResults();
              }
            },
          ),

          // --- Divider ---
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 10),

          // --- Combined Scrollable List ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<AircraftListDataCubit, AircraftListDataState>(
                builder: (context, state) {
                  final selected = cubit.selectedAircraft;
                  final filtered = state.aircraftList
                      .where(
                        (a) => !selected.any(
                          (s) => s.icaoTypeCode == a.icaoTypeCode,
                        ),
                      )
                      .toList();

                  if (state.isLoading) {
                    return const Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (selected.isEmpty && filtered.isEmpty) {
                    return const Center(child: Text("No results found"));
                  }

                  return ListView(
                    children: [
                      // --- Selected Aircraft ---
                      if (selected.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Selected Aircraft (${selected.length}/5)",
                            style: AppTextStyles.bold(
                              18,
                            ).copyWith(height: 1.0, color: AppColors.black),
                          ),
                        ),

                        const SizedBox(height: 30),
                        ...selected.map(
                          (aircraft) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.colorForSearchListBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      aircraft.manufacturer?.companyName ?? "-",
                                      style: AppTextStyles.bold(16.34).copyWith(
                                        height: 1.4,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      aircraft.aircraftModel,
                                      style: AppTextStyles.bold(16.34).copyWith(
                                        height: 1.4,
                                        letterSpacing: 1,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.colorForFilterScreen,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      aircraft.icaoTypeCode,
                                      style: AppTextStyles.bold(12).copyWith(
                                        height: 1.0,
                                        color: AppColors.darkValueTextColour,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      cubit.removeSelectedAircraft(
                                        aircraft.icaoTypeCode,
                                      );
                                      _notifySelectionChanged(cubit);
                                    },
                                    child: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                      //--- Search Results ---
                      ...filtered.map(
                        (aircraft) => GestureDetector(
                          onTap: () {
                            if (cubit.selectedAircraft.length >= 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "You can select up to 5 aircraft only.",
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            cubit.addSelectedAircraft(aircraft);
                            _notifySelectionChanged(cubit);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    aircraft.manufacturer?.companyName ?? "-",
                                    style: AppTextStyles.bold(16.34).copyWith(
                                      height: 1.4,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    aircraft.aircraftModel,
                                    style: AppTextStyles.bold(16.34).copyWith(
                                      height: 1.4,
                                      letterSpacing: 1,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                  child: Text(
                                    aircraft.icaoTypeCode,
                                    style: AppTextStyles.bold(12).copyWith(
                                      height: 1.0,
                                      color: AppColors.darkValueTextColour,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // --- Save Button ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<AircraftListDataCubit, AircraftListDataState>(
              builder: (context, state) {
                final hasSelection = cubit.selectedAircraft.isNotEmpty;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasSelection
                        ? () {
                            Navigator.pop(
                              context,
                              List<AircraftModel>.from(cubit.selectedAircraft),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasSelection
                          ? const Color(0xFF3F3D56)
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Save", style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
