import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../../CustomFiles/CustomTabBar.dart';
import '../../bloc/AircraftComparison/Comparison/ComparisonCubit.dart';
import '../../bloc/AircraftComparison/Comparison/ComparisonState.dart';

class ComparisonScreen extends StatefulWidget {
  final bool showTabs;

  const ComparisonScreen({Key? key, this.showTabs = true}) : super(key: key);

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ComparisonCubit>().loadTechnicalData(); // Default tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Comparison A321, A322",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTabs)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTabBar(
                tabTitles: const ['TECHNICAL DATA', 'OPERATIONAL DATA'],
                initialIndex: _currentTabIndex,
                isComeFromComparsionScreen: true,
                onTabSelected: (index) {
                  setState(() => _currentTabIndex = index);
                  if (index == 0) {
                    context.read<ComparisonCubit>().loadTechnicalData();
                  } else {
                    context.read<ComparisonCubit>().loadOperationalData();
                  }
                },
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<ComparisonCubit, ComparisonState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.labels.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(20),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      // Header row
                      TableRow(
                        children: [
                          // Parameter with no background
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Wrap(),
                          ),
                          // A321 with background
                          Container(
                            color: const Color(0xFFE4E6EA),
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'A321',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // A322 with background
                          Container(
                            color: const Color(0xFFE4E6EA),
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'A322',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Data rows
                      for (int i = 0; i < state.labels.length; i++)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                state.labels[i],
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  state.a321Values[i],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  state.a322Values[i],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
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
