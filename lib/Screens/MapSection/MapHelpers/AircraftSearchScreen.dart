import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Constants/constantImages.dart';
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
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(
              context,
              List<AircraftModel>.from(cubit.selectedAircraft),
            ),
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.closeIconsearch),
              height: 22,
              width: 22,
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),

      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                final query = value.trim();
                if (query.length >= 3) {
                  cubit.searchAircraftByICAO(icaoCode: query, context: context);
                } else {
                  cubit.clearResults();
                }
              },
              decoration: InputDecoration(
                hintText: "Search aircraft ICAO",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 2),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 35,
                  maxHeight: 25,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
                        Text(
                          "Selected Aircraft (${selected.length}/5)",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...selected.map(
                              (aircraft) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD2E6FC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      aircraft.manufacturer?.companyName ?? "-",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      aircraft.aircraftModel,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      // ✅ Remove selected aircraft
                                      cubit.removeSelectedAircraft(
                                        aircraft.icaoTypeCode,
                                      );
                                      _notifySelectionChanged(cubit);
                                    },
                                    child: SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.closeIconsearch,
                                      ),
                                      height: 22,
                                      width: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 30, color: Colors.grey),
                      ],

                      // --- Search Results ---
                      ...filtered.map(
                            (aircraft) => GestureDetector(
                          onTap: () {
                            // ✅ Limit max 5 selections
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

                            // ✅ Add selected aircraft
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    aircraft.aircraftModel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
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
