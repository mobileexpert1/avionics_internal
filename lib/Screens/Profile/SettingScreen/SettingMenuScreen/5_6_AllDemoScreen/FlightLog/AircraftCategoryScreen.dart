import 'package:avionics_internal/Screens/Profile/SettingScreen/SettingMenuScreen/5_6_AllDemoScreen/FlightStickers/StickerUnlockScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../../Constants/ConstantStrings.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../../Helpers/AppNavigator.dart';
import '../FlightStickers/ProgressHeader.dart';
import '../FlightStickers/StickerUnlockedDialog.dart';
import 'AircraftCategoryCard.dart';
import 'AircraftCategoryCubit.dart';
import 'AircraftCategoryState.dart';

class AircraftCategoryScreen extends StatefulWidget {
  const AircraftCategoryScreen({super.key});

  @override
  State<AircraftCategoryScreen> createState() => _AircraftCategoryScreenState();
}

class _AircraftCategoryScreenState extends State<AircraftCategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AircraftCategoryCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    final int crossAxisCount = isDesktopWeb
        ? (screenWidth >= 1500
              ? 5
              : screenWidth >= 1200
              ? 4
              : 3)
        : 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "My Stickers",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: BlocBuilder<AircraftCategoryCubit, AircraftCategoryState>(
        builder: (context, state) {
          if (state.status == CommonApiStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CommonApiStatus.failure) {
            return Center(child: Text(state.errorMessage ?? ''));
          }

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: Column(
                  children: [
                    ProgressHeader(
                      unlocked: state.totalUnlocked,
                      total: state.totalStickers,
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          itemCount: state.categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: isDesktopWeb ? 20 : 10,
                                mainAxisSpacing: isDesktopWeb ? 20 : 10,
                                childAspectRatio: isDesktopWeb ? 1.05 : 1,
                              ),
                          itemBuilder: (_, index) {
                            return AircraftCategoryCard(
                              category: state.categories[index],
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => StickerUnlockedDialog(
                                    category: state.categories[index],
                                    stickerName: "Airbus A318",
                                    imagePath:
                                        "assets/dummyPictures/MainLogoAirplane.png",
                                    onTap: () {
                                      AppNavigator.push(
                                        context,
                                        const StickerUnlockScreen(),
                                        disableSwipeBack: true,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
