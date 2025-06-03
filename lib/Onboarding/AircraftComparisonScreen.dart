import 'package:avionics_internal/bloc/AircraftComparison/AircraftComparisonCubit.dart';
import 'package:avionics_internal/bloc/AircraftComparison/AircraftComparisonState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Constants/constantImages.dart';
import '../Helpers/AircraftCard.dart';
import '../Helpers/AppText.dart';
import '../Helpers/SearchBarWidget.dart';
import '../Home/HomeScreen.dart';
import '../bloc/AircraftComparison/AircraftModel.dart';

class AircraftComparisonScreen extends StatefulWidget {
  const AircraftComparisonScreen({super.key});

  @override
  State<AircraftComparisonScreen> createState() =>
      _AircraftComparisonScreenState();
}

class _AircraftComparisonScreenState extends State<AircraftComparisonScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AircraftComparisonCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AircraftComparisonCubit, AircraftComparisonState>(
            builder: (context, state) {
              List<AircraftModel> models = [];
              if (state is AircraftComparisonModelsUpdated) {
                models = state.models;
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBarWidget(
                        controller: searchController,
                        onFilterTap: () {
                          context
                              .read<AircraftComparisonCubit>()
                              .filterModels(searchController.text);
                        },
                      ),
                      const SizedBox(height: 2),
                      Divider(),
                      const SizedBox(height: 15),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
                            );
                          },
                          child: AppTexts(
                            text: "Select model for comparison",
                            imageName: CommonUi.setSvgImage(AssetsPath.BackIcon),
                            font: 'Roboto',
                            side: 'left',
                            color: Colors.black,
                            weight: FontWeight.w600,
                            fontSize: 19,
                            imageSize: 25,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      SizedBox(height: 13),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-737-800',
                        badge: 'A737',
                        manufacturer: 'Boeing',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-321',
                        badge: 'A321',
                        manufacturer: 'Airbus',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-322',
                        badge: 'A322',
                        manufacturer: 'Airbus',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-757-200',
                        badge: 'A757',
                        manufacturer: 'Airbus',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-737-800',
                        badge: 'A737',
                        manufacturer: 'Boeing',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-737-800',
                        badge: 'A737',
                        manufacturer: 'Boeing',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'A-737-800',
                        badge: 'A737',
                        manufacturer: 'Boeing',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'DHC-8-400',
                        badge: 'DH8D',
                        manufacturer: 'DH Canada',
                        airline: null,
                      ),
                      SizedBox(height: 7),
                      AircraftCard.buildAircraftCard(
                        imagePath:
                        CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                        model: 'DHC-8-400',
                        badge: 'DH8D',
                        manufacturer: 'DH Canada',
                        airline: null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
