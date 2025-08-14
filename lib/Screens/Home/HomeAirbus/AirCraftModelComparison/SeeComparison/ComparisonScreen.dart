import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../CustomFiles/CustomTabBar.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/ComparisonCubit.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/ComparisonState.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_cubit.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_model.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_screen.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_state.dart';

class ComparisonScreen extends StatefulWidget {
  final bool showTabs;
  final String model1;
  final String model2;
  final String model1Name;
  final String model2Name;

  const ComparisonScreen({
    Key? key,
    this.showTabs = true,
    required this.model1,
    required this.model2,
    required this.model1Name,
    required this.model2Name,
  }) : super(key: key);

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ComparisonCubit>().fetchComparison(
        context: context,
        aircraft1Id: widget.model1,
        aircraft2Id: widget.model2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ComparisonCubit()
            ..fetchComparison(
              context: context,
              aircraft1Id: widget.model1,
              aircraft2Id: widget.model2,
            ),
        ),
        BlocProvider(
          create: (_) => ComparisonFilterCubit1(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Comparison ${widget.model1Name}, ${widget.model2Name}",
          centerTitle: false,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          rightButton: GestureDetector(
            onTap: () async {
              final selectedFilters = await showModalBottomSheet<List<FilterCategory1>>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return BlocProvider.value(
                    value: context.read<ComparisonFilterCubit1>(),
                    child: FractionallySizedBox(
                      heightFactor: 0.9,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: FilterScreen1(),
                      ),
                    ),
                  );
                },
              );
              if (selectedFilters != null) {
                print('Selected Filters: ${selectedFilters.map((cat) => "${cat.name}: ${cat.options.map((opt) => "${opt.name}: ${opt.isSelected}").join(", ")}").join("\n")}');
                context.read<ComparisonFilterCubit1>().updateSelectedFilters(selectedFilters, isApplied: true);
              }
            },
            child: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.filterIconCompare),
              fit: BoxFit.fill,
              width: 50,
              height: 50,
            ),
          ),
        ),
        body: BlocBuilder<ComparisonCubit, ComparisonState>(
          builder: (context, state) {
            return BlocBuilder<ComparisonFilterCubit1, FilterState1>(
              buildWhen: (previous, current) => previous.filterCategories != current.filterCategories || previous.isApplied != current.isApplied,
              builder: (context, filterState) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final model = state.comparisonModel;

                if (!filterState.isApplied && filterState.filterCategories.isEmpty && model != null) {
                  context.read<ComparisonFilterCubit1>().loadFiltersFromComparison1();
                }

                if (model == null) {
                  return const Center(child: Text("No data available"));
                }

                final activeCategoryId = _currentTabIndex == 0
                    ? 'general'
                    : _currentTabIndex == 1
                    ? 'technical_data'
                    : 'operational_data';

                final activeCategory = filterState.filterCategories.firstWhere(
                      (cat) => cat.id == activeCategoryId,
                  orElse: () => FilterCategory1(id: '', name: '', options: []),
                );

                // Debug the full filter state and active category options
                print('Filter State Categories: ${filterState.filterCategories.map((cat) => "${cat.name}: ${cat.options.map((o) => "${o.name}: ${o.isSelected}").join(", ")}").join("\n")}');
                print('All Options in ${activeCategory.name}: ${activeCategory.options.map((o) => "${o.name}: ${o.isSelected}").join(", ")}');

                // Filter selected options with detailed debugging
                final allOptions = activeCategory.options;
                print('Before Filtering: ${allOptions.map((o) => "${o.name}: ${o.isSelected}").join(", ")}');
                final selectedOptions = allOptions.where((o) => o.isSelected).toList();
                print('After Filtering: ${selectedOptions.map((o) => "${o.name}: ${o.isSelected}").join(", ")}');
                print('Active Category: ${activeCategory.name}, Selected Options: ${selectedOptions.map((o) => o.name).toList()}');

                List<String> labels = [];
                List<String> a1Values = [];
                List<String> a2Values = [];

                for (var option in selectedOptions) {
                  labels.add(option.name);

                  switch (option.id) {
                  // GENERAL
                    case 'icao_type_code':
                      a1Values.add(model.aircraft1.general.icaoTypeCode ?? 'N/A');
                      a2Values.add(model.aircraft2.general.icaoTypeCode ?? 'N/A');
                      break;
                    case 'wake_turbulence':
                      a1Values.add(model.aircraft1.general.wakeTurbulenceCategory ?? 'N/A');
                      a2Values.add(model.aircraft2.general.wakeTurbulenceCategory ?? 'N/A');
                      break;
                    case 'avionics':
                      a1Values.add(model.aircraft1.general.avionicsSystemNameFamily ?? 'N/A');
                      a2Values.add(model.aircraft2.general.avionicsSystemNameFamily ?? 'N/A');
                      break;
                    case 'no_of_engines':
                      a1Values.add(model.aircraft1.general.noOfEngines?.toString() ?? 'N/A');
                      a2Values.add(model.aircraft2.general.noOfEngines?.toString() ?? 'N/A');
                      break;
                    case 'engine_model':
                      a1Values.add(model.aircraft1.general.engineManufacturerAndModel ?? 'N/A');
                      a2Values.add(model.aircraft2.general.engineManufacturerAndModel ?? 'N/A');
                      break;
                    case 'engine_type':
                      a1Values.add(model.aircraft1.general.engineType ?? 'N/A');
                      a2Values.add(model.aircraft2.general.engineType ?? 'N/A');
                      break;

                  // TECHNICAL DATA
                    case 'wingspan_m':
                      a1Values.add(model.aircraft1.technicalData.wingspan.meters ?? 'N/A');
                      a2Values.add(model.aircraft2.technicalData.wingspan.meters ?? 'N/A');
                      break;
                    case 'length_m':
                      a1Values.add(model.aircraft1.technicalData.length.meters ?? 'N/A');
                      a2Values.add(model.aircraft2.technicalData.length.meters ?? 'N/A');
                      break;
                    case 'height_m':
                      a1Values.add(model.aircraft1.technicalData.height.meters ?? 'N/A');
                      a2Values.add(model.aircraft2.technicalData.height.meters ?? 'N/A');
                      break;
                    case 'max_Payload':
                      a1Values.add(model.aircraft1.technicalData.maxPayload ?? 'N/A');
                      a2Values.add(model.aircraft2.technicalData.maxPayload ?? 'N/A');
                      break;
                    case 'mtow':
                      a1Values.add(model.aircraft1.technicalData.mtow ?? 'N/A');
                      a2Values.add(model.aircraft2.technicalData.mtow ?? 'N/A');
                      break;
                    case 'mlw':
                      a1Values.add(model.aircraft1.technicalData.mlw ?? 'N/A');
                      a2Values.add(model.aircraft2.technicalData.mlw ?? 'N/A');
                      break;

                  // OPERATIONAL DATA
                    case 'takeoff_speed_kts':
                      a1Values.add(model.aircraft1.operationalData.takeoffSpeedKts ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.takeoffSpeedKts ?? 'N/A');
                      break;
                    case 'service_ceiling_ft':
                      a1Values.add(model.aircraft1.operationalData.serviceCeilingFtFl ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.serviceCeilingFtFl ?? 'N/A');
                      break;
                    case 'max_altitude_ft':
                      a1Values.add(model.aircraft1.operationalData.maxCertifiedAltitudeFtFl ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.maxCertifiedAltitudeFtFl ?? 'N/A');
                      break;
                    case 'cruise_speed_kts':
                      a1Values.add(model.aircraft1.operationalData.cruiseSpeed.cruiseKt ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.cruiseSpeed.cruiseKt ?? 'N/A');
                      break;
                    case 'cruise_mach':
                      a1Values.add(model.aircraft1.operationalData.cruiseSpeed.cruiseMach ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.cruiseSpeed.cruiseMach ?? 'N/A');
                      break;
                    case 'ferry_range_nm':
                      a1Values.add(model.aircraft1.operationalData.range.ferryRangeNm ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.range.ferryRangeNm ?? 'N/A');
                      break;
                    case 'normal_range_nm':
                      a1Values.add(model.aircraft1.operationalData.range.normalRangeNm ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.range.normalRangeNm ?? 'N/A');
                      break;
                    case 'normal_range_km':
                      a1Values.add(model.aircraft1.operationalData.range.normalRangeKm ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.range.normalRangeKm ?? 'N/A');
                      break;
                    case 'initial_rate_of_descent_fpm':
                      a1Values.add(model.aircraft1.operationalData.initialRateOfDescentFpm ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.initialRateOfDescentFpm ?? 'N/A');
                      break;
                    case 'average_rate_of_descent_fpm':
                      a1Values.add(model.aircraft1.operationalData.averageRateOfDescentFpm ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.averageRateOfDescentFpm ?? 'N/A');
                      break;
                    case 'min_clean_speed_kts':
                      a1Values.add(model.aircraft1.operationalData.minimumCleanSpeedKts ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.minimumCleanSpeedKts ?? 'N/A');
                      break;
                    case 'approach_speed_kts':
                      a1Values.add(model.aircraft1.operationalData.approachSpeedKts ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.approachSpeedKts ?? 'N/A');
                      break;
                    case 'landing_speed_kts':
                      a1Values.add(model.aircraft1.operationalData.landingSpeedKts ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.landingSpeedKts ?? 'N/A');
                      break;
                    case 'landing_distance_m':
                      a1Values.add(model.aircraft1.operationalData.landingDistanceM ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.landingDistanceM ?? 'N/A');
                      break;
                    case 'runway_required_m':
                      a1Values.add(model.aircraft1.operationalData.runwayLengthRequiredM ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.runwayLengthRequiredM ?? 'N/A');
                      break;
                    case 'stall_speed':
                      a1Values.add(model.aircraft1.operationalData.stallSpeedIfAvailable ?? 'N/A');
                      a2Values.add(model.aircraft2.operationalData.stallSpeedIfAvailable ?? 'N/A');
                      break;
                    default:
                      a1Values.add('N/A');
                      a2Values.add('N/A');
                  }
                }

                return Column(
                  children: [
                    if (widget.showTabs)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTabBar(
                          tabTitles: const [
                            'GENERAL',
                            'TECHNICAL DATA',
                            'OPERATIONAL DATA',
                          ],
                          initialIndex: _currentTabIndex,
                          isComeFromComparsionScreen: true,
                          onTabSelected: (index) {
                            setState(() => _currentTabIndex = index);
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: selectedOptions.isEmpty
                            ? const Center(child: Text("No parameters selected for this category"))
                            : Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                          },
                          border: TableBorder.all(color: Colors.grey, width: 1),
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(""),
                                ),
                                Container(
                                  color: const Color(0xFFEBF5FF),
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      widget.model1Name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3F3D56),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: const Color(0xFFEBF5FF),
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      widget.model2Name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3F3D56),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (int i = 0; i < labels.length; i++)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(labels[i]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(a1Values[i]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(a2Values[i]),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}