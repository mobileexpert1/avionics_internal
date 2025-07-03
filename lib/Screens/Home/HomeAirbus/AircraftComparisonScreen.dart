import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppText.dart';
import '../../../Helpers/SearchBarWidget.dart';
import '../../../Helpers/SelectableAircraftCard.dart';
import '../../../bloc/AircraftComparison/AircraftComparisonCubit.dart';
import '../../../bloc/AircraftComparison/AircraftComparisonState.dart';
import '../HomeScreen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchBarWidget(
                enableBackArrow: false,
                enableFilter: true,
                enableCloseScreen: false,
                controller: searchController,
                onFilterTap: () {
                  context.read<AircraftComparisonCubit>().filterModels(
                    searchController.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: BlocBuilder<AircraftComparisonCubit, AircraftComparisonState>(
          builder: (context, state) {
            List models = [];
            Set<String> selectedBadges = {};
            if (state is AircraftComparisonModelsUpdated) {
              models = state.models;
              selectedBadges = state.selectedModelBadges;
            }
            SizedBox(height: screenWidth * 0.03);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenWidth * 0.06),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.06),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: AppTexts(
                        text: "   Select Model for Comparison",
                        imageName: CommonUi.setSvgImage(AssetsPath.BackIcon),
                        font: 'Roboto',
                        side: 'left',
                        color: Colors.black,
                        weight: FontWeight.w600,
                        fontSize: screenWidth * 0.04,
                        imageSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.06),

                  ...models.map((model) {
                    return Padding(
                      key: ValueKey(model.id),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenWidth * 0.017,
                      ),
                      child: SelectableAircraftCard(
                        imagePath: CommonUi.setPngImage(
                          AssetsPath.aeroplaneComparison,
                        ),
                        model: model.name,
                        badge: model.id,
                        manufacturer: model.manufacturer,
                        airline: null,
                        isSelected: selectedBadges.contains(model.id),
                        onTap: () {
                          showComparisonBottomSheet(context, screenWidth);
                          // context
                          //     .read<AircraftComparisonCubit>()
                          //     .toggleSelection(model.id);
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showComparisonBottomSheet(BuildContext context, double screenWidth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 25,
            left: 10,
            right: 10,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 20,
                  right: 30,
                  bottom: 20,
                ),
                child: // Header
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetsPath.comparsion,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Model Comparison',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),

              SelectableAircraftCard(
                imagePath: CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                model: "A-321",
                badge: "A321",
                manufacturer: "Airbus",
                airline: null,
                isSelected: true,
                isComeFromPopUp: true,
              ),

              SizedBox(height: 8),

              SelectableAircraftCard(
                imagePath: CommonUi.setPngImage(AssetsPath.aeroplaneComparison),
                model: "A-321",
                badge: "A321",
                manufacturer: "Airbus",
                airline: null,
                isSelected: true,
                isComeFromPopUp: true,
              ),

              SizedBox(height: 8),

              // Button
              SizedBox(
                width: screenWidth * 0.85,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(63, 61, 81, 1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    "See Comparison",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
