import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/ComparisonCubit.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/ComparisonState.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_cubit.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_model.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/Filtter/filtter_state.dart';
import '../../../../MapSection/AirportStationDetailCard/AirportStationDetailCard.dart';
import '../FilterScreen/Filter_Screen_For_Comparison.dart';

class ComparisonScreen extends StatefulWidget {
  // final bool showTabs;
  final String model1;
  final String model2;
  final String model1Name;
  final String model2Name;

  const ComparisonScreen({
    super.key,
    //this.showTabs = true,
    required this.model1,
    required this.model2,
    required this.model1Name,
    required this.model2Name,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  int _currentTabIndex = 0;

  int subSegmentIndex = 0;
  final subSegmentOptions = const [
    'General',
    'Technical Data',
    'Operational Data',
  ];

  @override
  void initState() {
    super.initState();
    context.read<ComparisonCubit>().fetchComparison(
      context: context,
      aircraft1Id: widget.model1,
      aircraft2Id: widget.model2,
    );
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.comparisonScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isForComparison: true,
        title: "Comparison ${widget.model1Name}, ${widget.model2Name}",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        rightButton: GestureDetector(
          onTap: () async {
            final currentState = context.read<ComparisonFilterCubit1>().state;

            final selectedFilters =
                await showModalBottomSheet<List<FilterCategory1>>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return BlocProvider.value(
                      value: context.read<ComparisonFilterCubit1>(),
                      child: FractionallySizedBox(
                        heightFactor: 0.9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: FilterScreenForComparison(
                            isAlreadyProcessing: currentState.isApplied,
                            modelResponse: currentState,
                          ),
                        ),
                      ),
                    );
                  },
                );
            if (selectedFilters != null) {
              context.read<ComparisonFilterCubit1>().updateSelectedFilters(
                selectedFilters,
                isApplied: true,
              );
            }
          },
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.compareFilter),
            fit: BoxFit.cover,
            width: 27,
            height: 27,
          ),
        ),
      ),
      body: BlocBuilder<ComparisonCubit, ComparisonState>(
        builder: (context, state) {
          return BlocBuilder<ComparisonFilterCubit1, FilterState1>(
            buildWhen: (previous, current) =>
                previous.filterCategories != current.filterCategories ||
                previous.isApplied != current.isApplied,
            builder: (context, filterState) {
              if (state.isLoading) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final model = state.comparisonModel;

              final currentState = context.read<ComparisonFilterCubit1>().state;
              if (!filterState.isApplied &&
                  filterState.filterCategories.isEmpty &&
                  model != null) {
                context
                    .read<ComparisonFilterCubit1>()
                    .loadFiltersFromComparison1(
                      currentState.isApplied,
                      currentState,
                    );
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

              // Filter selected options with detailed debugging
              final allOptions = activeCategory.options;

              final selectedOptions = allOptions
                  .where((o) => o.isSelected)
                  .toList();

              List<String> labels = [];
              List<String> a1Values = [];
              List<String> a2Values = [];

              for (var option in selectedOptions) {
                labels.add(option.name);

                switch (option.id) {
                  case 'icao_type_code':
                    a1Values.add(model.aircraft1.general.icaoTypeCode);
                    a2Values.add(model.aircraft2.general.icaoTypeCode);
                    break;
                  case 'wake_turbulence':
                    a1Values.add(
                      model.aircraft1.general.wakeTurbulenceCategory,
                    );
                    a2Values.add(
                      model.aircraft2.general.wakeTurbulenceCategory,
                    );
                    break;
                  case 'avionics':
                    a1Values.add(
                      model.aircraft1.general.avionicsSystemNameFamily,
                    );
                    a2Values.add(
                      model.aircraft2.general.avionicsSystemNameFamily,
                    );
                    break;
                  case 'no_of_engines':
                    a1Values.add(
                      model.aircraft1.general.noOfEngines.toString(),
                    );
                    a2Values.add(
                      model.aircraft2.general.noOfEngines.toString(),
                    );
                    break;
                  case 'engine_model':
                    a1Values.add(
                      model.aircraft1.general.engineManufacturerAndModel,
                    );
                    a2Values.add(
                      model.aircraft2.general.engineManufacturerAndModel,
                    );
                    break;
                  case 'engine_type':
                    a1Values.add(model.aircraft1.general.engineType);
                    a2Values.add(model.aircraft2.general.engineType);
                    break;

                  // TECHNICAL DATA
                  case 'wingspan_m':
                    a1Values.add(model.aircraft1.technicalData.wingspan.meters);
                    a2Values.add(model.aircraft2.technicalData.wingspan.meters);
                    break;
                  case 'length_m':
                    a1Values.add(model.aircraft1.technicalData.length.meters);
                    a2Values.add(model.aircraft2.technicalData.length.meters);
                    break;
                  case 'height_m':
                    a1Values.add(model.aircraft1.technicalData.height.meters);
                    a2Values.add(model.aircraft2.technicalData.height.meters);
                    break;
                  case 'max_Payload':
                    a1Values.add(model.aircraft1.technicalData.maxPayload);
                    a2Values.add(model.aircraft2.technicalData.maxPayload);
                    break;
                  case 'mtow':
                    a1Values.add(model.aircraft1.technicalData.mtow);
                    a2Values.add(model.aircraft2.technicalData.mtow);
                    break;
                  case 'mlw':
                    a1Values.add(model.aircraft1.technicalData.mlw);
                    a2Values.add(model.aircraft2.technicalData.mlw);
                    break;

                  // OPERATIONAL DATA
                  case 'takeoff_speed_kts':
                    a1Values.add(
                      model.aircraft1.operationalData.takeoffSpeedKts,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.takeoffSpeedKts,
                    );
                    break;
                  case 'service_ceiling_ft':
                    a1Values.add(
                      model.aircraft1.operationalData.serviceCeilingFtFl,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.serviceCeilingFtFl,
                    );
                    break;
                  case 'max_altitude_ft':
                    a1Values.add(
                      model.aircraft1.operationalData.maxCertifiedAltitudeFtFl,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.maxCertifiedAltitudeFtFl,
                    );
                    break;
                  case 'cruise_speed_kts':
                    a1Values.add(
                      model.aircraft1.operationalData.cruiseSpeed.cruiseKt,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.cruiseSpeed.cruiseKt,
                    );
                    break;
                  case 'cruise_mach':
                    a1Values.add(
                      model.aircraft1.operationalData.cruiseSpeed.cruiseMach,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.cruiseSpeed.cruiseMach,
                    );
                    break;
                  case 'ferry_range_nm':
                    a1Values.add(
                      model.aircraft1.operationalData.range.ferryRangeNm,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.range.ferryRangeNm,
                    );
                    break;
                  case 'normal_range_nm':
                    a1Values.add(
                      model.aircraft1.operationalData.range.normalRangeNm,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.range.normalRangeNm,
                    );
                    break;
                  case 'normal_range_km':
                    a1Values.add(
                      model.aircraft1.operationalData.range.normalRangeKm,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.range.normalRangeKm,
                    );
                    break;
                  case 'initial_rate_of_descent_fpm':
                    a1Values.add(
                      model.aircraft1.operationalData.initialRateOfDescentFpm,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.initialRateOfDescentFpm,
                    );
                    break;
                  case 'average_rate_of_descent_fpm':
                    a1Values.add(
                      model.aircraft1.operationalData.averageRateOfDescentFpm,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.averageRateOfDescentFpm,
                    );
                    break;
                  case 'min_clean_speed_kts':
                    a1Values.add(
                      model.aircraft1.operationalData.minimumCleanSpeedKts,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.minimumCleanSpeedKts,
                    );
                    break;
                  case 'approach_speed_kts':
                    a1Values.add(
                      model.aircraft1.operationalData.approachSpeedKts,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.approachSpeedKts,
                    );
                    break;
                  case 'landing_speed_kts':
                    a1Values.add(
                      model.aircraft1.operationalData.landingSpeedKts,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.landingSpeedKts,
                    );
                    break;
                  case 'landing_distance_m':
                    a1Values.add(
                      model.aircraft1.operationalData.landingDistanceM,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.landingDistanceM,
                    );
                    break;
                  case 'runway_required_m':
                    a1Values.add(
                      model.aircraft1.operationalData.runwayLengthRequiredM,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.runwayLengthRequiredM,
                    );
                    break;
                  case 'stall_speed':
                    a1Values.add(
                      model.aircraft1.operationalData.stallSpeedIfAvailable,
                    );
                    a2Values.add(
                      model.aircraft2.operationalData.stallSpeedIfAvailable,
                    );
                    break;
                  default:
                    a1Values.add('N/A');
                    a2Values.add('N/A');
                }
              }

              return Column(
                children: [
                  Container(
                    color: AppColors.primaryDark,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: RadioChips(
                            isForFlightScreen: false,
                            values: subSegmentOptions,
                            selectedIndex: _currentTabIndex,
                            onSelected: (i) =>
                                setState(() => _currentTabIndex = i),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "PARAMETERS",
                                  style: AppTextStyles.regular(14).copyWith(
                                    height: 1.0,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.model1Name,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.bold(16).copyWith(
                                    height: 1.0,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.model2Name,
                                  textAlign: TextAlign.center,

                                  style: AppTextStyles.bold(16).copyWith(
                                    height: 1.0,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(15),
                      child: selectedOptions.isEmpty
                          ? const Center(
                              child: Text(
                                "No parameters selected for this category",
                              ),
                            )
                          : Table(
                              columnWidths: const {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                              },
                              border: TableBorder.all(
                                color: AppColors.dividerLineColourForComparison,
                                width: 1,
                                borderRadius: BorderRadius.circular(12),
                              ),

                              children: [
                                for (int i = 0; i < labels.length; i++)
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          labels[i],
                                          style: AppTextStyles.bold(14)
                                              .copyWith(
                                                height: 1.3,
                                                color: AppColors
                                                    .grayForCompareTextColour,
                                              ),
                                        ),
                                      ),

                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.fill,
                                        child: Container(
                                          color: AppColors.grayForCompareItem,
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              a1Values[i],
                                              style: AppTextStyles.regular(15)
                                                  .copyWith(
                                                    height: 1.3,
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            a2Values[i],
                                            style: AppTextStyles.regular(15)
                                                .copyWith(
                                                  height: 1.3,
                                                  color: AppColors.black,
                                                ),
                                          ),
                                        ),
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
    );
  }
}
