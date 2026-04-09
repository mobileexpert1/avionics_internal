import 'package:avionics_internal/Helpers/CustomDivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import '../../../bloc/MapSection/FilterMap/filter_Map_Cubit.dart';
import '../../../bloc/MapSection/FilterMap/filter_Map_State.dart';
import '../../../bloc/MapSection/MapAircraftList/aircraft_List_Data_Cubit.dart';
import '../../MapSection/MapHelpers/AircraftSearchScreen.dart';

class FilterResult {
  final CustomMapType mapType;
  final List<String> categories;
  final List<String> aircraftIcaos;

  FilterResult(this.mapType, this.categories, this.aircraftIcaos);
}

class FilterForMapScreen extends StatefulWidget {
  final CustomMapType initialMapType;
  final List<String>? initialCategories;
  final List<String>? initialAircraftIcaos;

  const FilterForMapScreen({
    Key? key,
    required this.initialMapType,
    this.initialCategories,
    this.initialAircraftIcaos,
  }) : super(key: key);

  @override
  _filterMapScreenState createState() => _filterMapScreenState();
}

class _filterMapScreenState extends State<FilterForMapScreen> {
  late AircraftListDataCubit aircraftCubit;

  @override
  void initState() {
    super.initState();
    aircraftCubit = AircraftListDataCubit();
    aircraftCubit.loadSelectedAircraft();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AircraftListDataCubit>.value(value: aircraftCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          isHideTopGradient: true,
          isForHomeScreen:true,
          leftButton: BlocBuilder<FilterMapMainCubit, FilterMapState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Filter",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          title: "",
          rightButton: BlocBuilder<FilterMapMainCubit, FilterMapState>(
            builder: (context, state) {
              final bool hasSelection = state.selectedCategories.isNotEmpty ||
                  aircraftCubit.selectedAircraft.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.only(right: 16, top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(
                      FilterResult(
                        state.mapType,
                        state.selectedCategories,
                        aircraftCubit.selectedAircraft
                            .map((a) => a.icaoTypeCode)
                            .where((c) => c.isNotEmpty)
                            .toList(),
                      ),
                    );
                  },
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),

        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: _FilterContent(),
        ),
      ),
    );
  }
}

class _FilterContent extends StatelessWidget {
  const _FilterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterMapMainCubit, FilterMapState>(
      builder: (context, state) {
        final cubit = context.read<FilterMapMainCubit>();
        final aircraftCubit = context.watch<AircraftListDataCubit>();

        return ListView(
          children: [
            ExpandableSection(
              title: "CATEGORIES",
              expanded: state.showCategories,
              onToggle: cubit.toggleCategoriesSection,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ["CARGO", "BUSINESS_JETS", "PASSENGER", "GLIDERS"]
                    .map((label) {
                  final isSelected = state.selectedCategories.contains(
                    label,
                  );
                  return GestureDetector(
                    onTap: () => cubit.toggleCategory(label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFD2E6FC)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF3E3C55),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SvgPicture.asset(
                          //   CommonUi.setSvgImage(AssetsPath.filterCheckMap),
                          //   height: 16,
                          //   width: 16,
                          // ),
                          // const SizedBox(width: 10),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Color(0xFF3E3C55)
                                  : const Color(0xFF3E3C55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                    .toList(),
              ),
            ),
            const SizedBox(height: 50),

            /// Map Section
            ExpandableSection(
              title: "MAP",
              expanded: state.showMap,
              onToggle: cubit.toggleMapSection,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.mapLayers),
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Map Type",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SegmentedControl(
                    options: const [
                      'Standard',
                      'Satellite',
                      'Hybrid',
                      'FIR Borders'
                    ],
                    selectedValue: cubit.getMapTypeName(),
                    onChanged: cubit.changeMapTypeByName,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
            ExpandableSection(
              title: "AIRCRAFT ICAO CODE",
              expanded: cubit.state.showAircraftLabels,
              onToggle: cubit.toggleAircraftLabels,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<List<AircraftModel>>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BlocProvider.value(
                                value: aircraftCubit,
                                child: AircraftSearchScreen(
                                  initialSelected: aircraftCubit
                                      .selectedAircraft,
                                ),
                              ),
                        ),
                      );
                      // if (result != null) {
                      //   for (var aircraft in result) {
                      //     await aircraftCubit.addSelectedAircraft(aircraft);
                      //   }
                      // }
                      if (result != null) {
                        aircraftCubit.setSelectedAircraft(result);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Center(
                        child: Text(
                          "+ Add Aircraft ICAO Code",
                          style: TextStyle(
                            color: Color(0xFF3E3C55),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  ...aircraftCubit.selectedAircraft.map((aircraft) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.aircraftIconmap),
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              aircraft.manufacturer?.companyName ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF3E3C55),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              aircraft.aircraftModel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF3E3C55),
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
                                color: Color(0xFF3E3C55),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () =>
                                aircraftCubit.removeSelectedAircraft(
                                  aircraft.icaoTypeCode,
                                ),
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.closeIcon),
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const CustomDivider(),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Reset Button
            ElevatedButton(
              onPressed: () {
                cubit.resetFilter();
                // aircraftCubit.clearSelectedAircraft();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Color(0xFF3E3C55)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: const Text(
                "Reset Filter",
                style: TextStyle(fontSize: 16, color: Color(0xFF3E3C55)),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 🔹 Expandable Section with Show More/Less toggle
class ExpandableSection extends StatelessWidget {
  final bool? isComeFromManufactureScreen;
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.isComeFromManufactureScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isComeFromManufactureScreen == false)...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3E3C55),
                ),
              ),
              InkWell(
                onTap: onToggle,
                child: Row(
                  children: [
                    Text(expanded ? "Show Less" : "Show More"),
                    const SizedBox(width: 4),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        if (expanded) ...[const SizedBox(height: 20), child],
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.black : Colors.grey),
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_sharp,
              color: isSelected ? Colors.black : Colors.grey,
              size: 15,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Segmented Control
class SegmentedControl extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;

  const SegmentedControl({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
