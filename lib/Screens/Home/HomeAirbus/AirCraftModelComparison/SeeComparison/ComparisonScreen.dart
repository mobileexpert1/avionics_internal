import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../CustomFiles/CustomTabBar.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/ComparisonCubit.dart';
import '../../../../../bloc/Home/AircraftComparison/Comparison/ComparisonState.dart';

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
    return BlocProvider(
      create: (_) => ComparisonCubit()
        ..fetchComparison(
          context: context,
          aircraft1Id: widget.model1,
          aircraft2Id: widget.model2,
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Comparison ${widget.model1Name}, ${widget.model2Name}",
          centerTitle: false,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          rightButton: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.filterIconCompare),
            fit: BoxFit.fill,
            width: 50,
            height: 50,
          ),
        ),
        body: BlocBuilder<ComparisonCubit, ComparisonState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final model = state.comparisonModel;

            if (model == null) {
              return const Center(child: Text("No data available"));
            }

            List<String> labels = [];
            List<String> a1Values = [];
            List<String> a2Values = [];

            if (_currentTabIndex == 0) {
              labels = [
                "ICAO Type Code",
                "Wake Turbulence",
                "Avionics",
                "No. of Engines",
                "Engine Model",
                "Engine Type",
              ];
              a1Values = [
                model.aircraft1.general.icaoTypeCode,
                model.aircraft1.general.wakeTurbulenceCategory,
                model.aircraft1.general.avionicsSystemNameFamily,
                model.aircraft1.general.noOfEngines.toString(),
                model.aircraft1.general.engineManufacturerAndModel,
                model.aircraft1.general.engineType,
              ];
              a2Values = [
                model.aircraft2.general.icaoTypeCode,
                model.aircraft2.general.wakeTurbulenceCategory,
                model.aircraft2.general.avionicsSystemNameFamily,
                model.aircraft2.general.noOfEngines.toString(),
                model.aircraft2.general.engineManufacturerAndModel,
                model.aircraft2.general.engineType,
              ];
            } else if (_currentTabIndex == 1) {
              labels = [
                "Wingspan (m)",
                "Wingspan (ft)",
                "Length (m)",
                "Length (ft)",
                "Height (m)",
                "Height (ft)",
              ];
              a1Values = [
                model.aircraft1.technicalData.wingspan.meters,
                model.aircraft1.technicalData.wingspan.feet,
                model.aircraft1.technicalData.length.meters,
                model.aircraft1.technicalData.length.feet,
                model.aircraft1.technicalData.height.meters,
                model.aircraft1.technicalData.height.feet,
              ];
              a2Values = [
                model.aircraft2.technicalData.wingspan.meters,
                model.aircraft2.technicalData.wingspan.feet,
                model.aircraft2.technicalData.length.meters,
                model.aircraft2.technicalData.length.feet,
                model.aircraft2.technicalData.height.meters,
                model.aircraft2.technicalData.height.feet,
              ];
            } else {
              labels = [
                "Takeoff Speed (kts)",
                "Service Ceiling (ft)",
                "Max Altitude (ft)",
                "Cruise Speed (kts)",
                "Cruise Mach",
                "Ferry Range (NM)",
                "Normal Range (NM)",
                "Normal Range (km)",
                "Initial Rate of Descent (fpm)",
                "Average Rate of Descent (fpm)",
                "Min Clean Speed (kts)",
                "Approach Speed (kts)",
                "Landing Speed (kts)",
                "Landing Distance (m)",
                "Runway Required (m)",
                "Stall Speed",
              ];
              a1Values = [
                model.aircraft1.operationalData.takeoffSpeedKts,
                model.aircraft1.operationalData.serviceCeilingFtFl,
                model.aircraft1.operationalData.maxCertifiedAltitudeFtFl,
                model.aircraft1.operationalData.cruiseSpeed.cruiseKt,
                model.aircraft1.operationalData.cruiseSpeed.cruiseMach,
                model.aircraft1.operationalData.range.ferryRangeNm,
                model.aircraft1.operationalData.range.normalRangeNm,
                model.aircraft1.operationalData.range.normalRangeKm,
                model.aircraft1.operationalData.initialRateOfDescentFpm,
                model.aircraft1.operationalData.averageRateOfDescentFpm,
                model.aircraft1.operationalData.minimumCleanSpeedKts,
                model.aircraft1.operationalData.approachSpeedKts,
                model.aircraft1.operationalData.landingSpeedKts,
                model.aircraft1.operationalData.landingDistanceM,
                model.aircraft1.operationalData.runwayLengthRequiredM,
                model.aircraft1.operationalData.stallSpeedIfAvailable,
              ];
              a2Values = [
                model.aircraft2.operationalData.takeoffSpeedKts,
                model.aircraft2.operationalData.serviceCeilingFtFl,
                model.aircraft2.operationalData.maxCertifiedAltitudeFtFl,
                model.aircraft2.operationalData.cruiseSpeed.cruiseKt,
                model.aircraft2.operationalData.cruiseSpeed.cruiseMach,
                model.aircraft2.operationalData.range.ferryRangeNm,
                model.aircraft2.operationalData.range.normalRangeNm,
                model.aircraft2.operationalData.range.normalRangeKm,
                model.aircraft2.operationalData.initialRateOfDescentFpm,
                model.aircraft2.operationalData.averageRateOfDescentFpm,
                model.aircraft2.operationalData.minimumCleanSpeedKts,
                model.aircraft2.operationalData.approachSpeedKts,
                model.aircraft2.operationalData.landingSpeedKts,
                model.aircraft2.operationalData.landingDistanceM,
                model.aircraft2.operationalData.runwayLengthRequiredM,
                model.aircraft2.operationalData.stallSpeedIfAvailable,
              ];
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
                    child: Table(
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
                              child: Text("Parameter"),
                            ),
                            Container(
                              color: const Color(0xFFE4E6EA),
                              padding: const EdgeInsets.all(10),
                              child: Center(child: Text(widget.model1Name)),
                            ),
                            Container(
                              color: const Color(0xFFE4E6EA),
                              padding: const EdgeInsets.all(10),
                              child: Center(child: Text(widget.model2Name)),
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
        ),
      ),
    );
  }
}
