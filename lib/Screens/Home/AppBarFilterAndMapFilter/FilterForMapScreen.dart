import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Helpers/CustomDivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import '../../../bloc/MapSection/FilterMap/filter_Map_Cubit.dart';
import '../../../bloc/MapSection/FilterMap/filter_Map_State.dart';
import '../../../bloc/MapSection/MapAircraftList/aircraft_List_Data_Cubit.dart';
import '../../MapSection/MapHelpers/AircraftSearchScreen.dart';
import '../../MapSection/MapHelpers/CustomSliderSection.dart';
import 'ExpandableSection.dart';
import 'SegmentedControl.dart';

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
          isClearBackgroundColour: true,
          isHideTopGradient: true,
          isForHomeScreen: true,
          leftButton: BlocBuilder<FilterMapMainCubit, FilterMapState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Filter",
                  style: AppTextStyles.bold(
                    20,
                  ).copyWith(height: 1.0, color: AppColors.primaryDark),
                ),
              );
            },
          ),
          title: "",
          rightButton: BlocBuilder<FilterMapMainCubit, FilterMapState>(
            builder: (context, state) {
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Apply",
                      style: AppTextStyles.semiRegular(
                        18,
                      ).copyWith(height: 1.0, color: AppColors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: BlocBuilder<FilterMapMainCubit, FilterMapState>(
            builder: (context, state) {
              final cubit = context.read<FilterMapMainCubit>();
              final aircraftCubit = context.watch<AircraftListDataCubit>();
              return ListView(
                children: [
                  ExpandableSection(
                    isComeFromManufactureScreen: false,
                    title: "NUMBER OF FLIGHTS",
                    expanded: cubit.state.showNumberOfFlights,
                    onToggle: cubit.togglesNumberOfFlightsSection,
                    child: CustomSliderSection(
                      value: state.numberOfFlights.toDouble(),
                      min: 1,
                      max: 200,
                      label: "${state.numberOfFlights} Flights",
                      onChanged: (val) {
                        cubit.updateFlights(val.toInt());
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  ExpandableSection(
                    isComeFromManufactureScreen: false,
                    title: "SEARCH RADIUS (NM)",
                    expanded: cubit.state.showSearchInRadius,
                    onToggle: cubit.toggleSearchInRadiusSection,
                    child: CustomSliderSection(
                      value: state.searchRadius.toDouble(),
                      min: 1,
                      max: 200,
                      label: "${state.searchRadius} NM",
                      onChanged: (val) {
                        cubit.updateRadius(val.toInt());
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  ExpandableSection(
                    isComeFromManufactureScreen: false,
                    title: "CATEGORIES",
                    expanded: state.showCategories,
                    onToggle: cubit.toggleCategoriesSection,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          [
                            "CARGO",
                            "BUSINESS_JETS",
                            "PASSENGER",
                            "GLIDERS",
                          ].map((label) {
                            final isSelected = state.selectedCategories
                                .contains(label);
                            return GestureDetector(
                              onTap: () => cubit.toggleCategory(label),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : AppColors.grayForFeedbackAndText,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      label,
                                      style: AppTextStyles.regular(12).copyWith(
                                        height: 1.0,
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.grayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// Map Section
                  ExpandableSection(
                    isComeFromManufactureScreen: false,
                    title: "MAP",
                    expanded: state.showMap,
                    onToggle: cubit.toggleMapSection,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedControl(
                          options: const [
                            'Standard',
                            'Satellite',
                            'Hybrid',
                            'FIR Borders',
                          ],
                          selectedValue: cubit.getMapTypeName(),
                          onChanged: cubit.changeMapTypeByName,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  ExpandableSection(
                    isComeFromManufactureScreen: false,
                    title: "AIRCRAFT ICAO CODE",
                    expanded: cubit.state.showAircraftLabels,
                    onToggle: cubit.toggleAircraftLabels,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result =
                                await Navigator.push<List<AircraftModel>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: aircraftCubit,
                                      child: AircraftSearchScreen(
                                        initialSelected:
                                            aircraftCubit.selectedAircraft,
                                      ),
                                    ),
                                  ),
                                );
                            if (result != null) {
                              aircraftCubit.setSelectedAircraft(result);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greyForAirportDetailCard,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                "+ Add Aircraft ICAO Code",
                                style: AppTextStyles.regular(16).copyWith(
                                  height: 1.0,
                                  color: AppColors.grayMedium,
                                ),
                              ),
                            ),
                          ),
                        ),

                        ...aircraftCubit.selectedAircraft.map((aircraft) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  CommonUi.setSvgImage(
                                    AssetsPath.generalCompare,
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    aircraft.manufacturer?.companyName ?? "-",
                                    style: AppTextStyles.regular(16).copyWith(
                                      height: 1.0,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    aircraft.aircraftModel,
                                    style: AppTextStyles.regular(16).copyWith(
                                      height: 1.0,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.colorForSearchListBackground,
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
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () =>
                                      aircraftCubit.removeSelectedAircraft(
                                        aircraft.icaoTypeCode,
                                      ),
                                  child: SvgPicture.asset(
                                    CommonUi.setSvgImage(AssetsPath.closeIcon),
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Reset Button
                  ElevatedButton(
                    onPressed: () {
                      cubit.resetFilter();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(
                        color: AppColors.dividerLineColourForComparison,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.rotate_left_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Reset Filter",
                          style: AppTextStyles.semiBold(16).copyWith(
                            height: 1.4,
                            letterSpacing: 1,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
