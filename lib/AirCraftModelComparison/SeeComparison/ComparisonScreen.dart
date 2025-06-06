import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/constantImages.dart';
import '../../bloc/AircraftComparison/Comparison/ComparisonCubit.dart';
import '../../bloc/AircraftComparison/Comparison/ComparisonState.dart';


class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComparisonCubit()..loadTechnicalData(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            toolbarHeight: 100,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal:0,vertical: 2),
              child: const Text(
                'Comparison A321, A322',
                style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child:  SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.filterIconCompare),
                  fit: BoxFit.fill,
                ),
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.black,
              onTap: (index) {
                final cubit = context.read<ComparisonCubit>();
                if (index == 0) {
                  cubit.loadTechnicalData();
                } else {
                  cubit.loadOperationalData();
                }
              },
              tabs: const [
                Tab(text: 'TECHNICAL DATA'),
                Tab(text: 'OPERATIONAL DATA'),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ComparisonDataTable(),
              ComparisonDataTable(),
            ],
          ),
        ),
      ),
    );
  }
}


class ComparisonDataTable extends StatelessWidget {
  const ComparisonDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComparisonCubit, ComparisonState>(
      builder: (context, state) {
        if (state.labels.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade100),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(''),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('A-321', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('A-322', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              for (int i = 0; i < state.labels.length; i++)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.labels[i]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.a321Values[i]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(state.a322Values[i]),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
