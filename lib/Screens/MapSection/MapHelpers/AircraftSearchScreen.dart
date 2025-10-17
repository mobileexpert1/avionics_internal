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
      widget.onSelectionChanged!(List<AircraftModel>.from(cubit.selectedAircraft));
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
            onPressed: () => Navigator.pop(context),
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

          // --- Selected Aircraft ---
          BlocBuilder<AircraftListDataCubit, AircraftListDataState>(
            builder: (context, state) {
              if (cubit.selectedAircraft.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Aircraft (${cubit.selectedAircraft.length}/5)",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: cubit.selectedAircraft.map((aircraft) {
                        return Padding(
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
                                      fontSize: 14,
                                      color: Color(0xFF3F3D56),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    aircraft.aircraftModel ?? "-",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF3F3D56),
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
                                    aircraft.icaoTypeCode ?? "-",
                                    style: const TextStyle(
                                      color: Color(0xFF3F3D56),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    cubit.removeSelectedAircraft(aircraft.icaoTypeCode);
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
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),

          // --- Search Results ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<AircraftListDataCubit, AircraftListDataState>(
                builder: (context, state) {
                  if (state.isLoading) return const Center(child: CircularProgressIndicator());

                  final filteredList = state.aircraftList
                      .where((a) => !cubit.selectedAircraft.any((s) => s.icaoTypeCode == a.icaoTypeCode))
                      .toList();

                  if (filteredList.isEmpty) return const Center(child: Text("No results found"));

                  return ListView.separated(
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.grey, height: 15),
                    itemBuilder: (context, index) {
                      final aircraft = filteredList[index];
                      return GestureDetector(
                        onTap: () {
                          cubit.addSelectedAircraft(aircraft);
                          _notifySelectionChanged(cubit);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                                    fontSize: 14,
                                    color: Color(0xFF3F3D56),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  aircraft.aircraftModel ?? "-",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF3F3D56),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey, width: 0.2),
                                ),
                                child: Text(
                                  aircraft.icaoTypeCode ?? "-",
                                  style: const TextStyle(
                                    color: Color(0xFF3F3D56),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, List<AircraftModel>.from(cubit.selectedAircraft));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3F3D56),
                  side: const BorderSide(color: Color(0xFF3F3D56)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
