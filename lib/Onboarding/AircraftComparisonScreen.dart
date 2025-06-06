import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Home/HomeScreen.dart';
import '../bloc/AircraftComparison/AircraftComparisonCubit.dart';
import '../bloc/AircraftComparison/AircraftComparisonState.dart';
import '../Constants/constantImages.dart';
import '../Helpers/AppText.dart';
import '../Helpers/SearchBarWidget.dart';
import '../Helpers/SelectableAircraftCard.dart';

class AircraftComparisonScreen extends StatefulWidget {
  const AircraftComparisonScreen({super.key});

  @override
  State<AircraftComparisonScreen> createState() =>
      _AircraftComparisonScreenState();
}

class _AircraftComparisonScreenState extends State<AircraftComparisonScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AircraftComparisonCubit>(); // Ensure Cubit is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<AircraftComparisonCubit, AircraftComparisonState>(
          builder: (context, state) {
            List models = [];
            Set<String> selectedBadges = {};
            if (state is AircraftComparisonModelsUpdated) {
              models = state.models;
              selectedBadges = state.selectedModelBadges;
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBarWidget(
                      enableBackArrow: false,
                      enableFilter: true,
                      enableCloseScreen: false,
                      controller: searchController,
                      onFilterTap: () {
                        context
                            .read<AircraftComparisonCubit>()
                            .filterModels(searchController.text);
                      },
                    ),
                    const SizedBox(height: 2),
                    const Divider(),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  HomeScreen(),
                            ),
                          );
                        },
                        child: AppTexts(
                          text: "   Select Model for Comparison",
                          imageName:
                          CommonUi.setSvgImage(AssetsPath.BackIcon),
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
                    const SizedBox(height: 13),
                    ...models.map((model) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10,vertical: 7),
                        child: SelectableAircraftCard(
                          imagePath: CommonUi.setPngImage(
                              AssetsPath.aeroplaneComparison),
                          model: model.name,
                          badge: model.id,
                          manufacturer: model.manufacturer,
                          airline: null,
                          isSelected: selectedBadges.contains(model.id),
                          onTap: () {
                            context
                                .read<AircraftComparisonCubit>()
                                .toggleSelection(model.id);
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}