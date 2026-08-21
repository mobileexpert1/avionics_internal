import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';

import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsCubit.dart';
import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsState.dart';

import 'Airplane3DViewScreen.dart';
import 'AirplaneCompleteScreen.dart';
import 'AirplanePartLockedDialog.dart';
import 'AirplanePartsCard.dart';

import '../../SettingScreen/SettingMenuScreen/5_6_AllDemoScreen/FlightStickers/ProgressHeader.dart';

class AirplanePartsScreen extends StatelessWidget {
  final bool isFromGame;
  const AirplanePartsScreen({super.key, this.isFromGame = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AirPlanePartsCubit(context: context),
      child: _AirplanePartsView(isFromGame: isFromGame),
    );
  }
}

class _AirplanePartsView extends StatelessWidget {
  final bool isFromGame;

  const _AirplanePartsView({required this.isFromGame});

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
        title: "My Airplane",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            if (isFromGame) {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context, true);
            }
          },
        ),
      ),

      body: BlocBuilder<AirPlanePartsCubit, AirPlanePartsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage ?? ''));
          }

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),

                child: Column(
                  children: [
                    ProgressHeader(
                      title: "3D Parts Unlocked",
                      unlocked: state.unlockedCount,
                      total: state.totalCount,
                      bottomTitle:
                          "Collect all ${state.totalCount} parts to complete your aircraft",
                      isCompletedGreen: true,
                      onView3DAircraft: () {
                        final part = state.parts.firstWhere(
                              (part) => part.collectedCount >= part.totalCount,
                          orElse: () => state.parts.first,
                        );

                        debugPrint("Aircraft Path: ${part.aircraftPath}");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AirplaneCompleteScreen(
                              aircraftPath: part.aircraftPath,
                            ),
                          ),
                        );
                      },
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: GridView.builder(
                          itemCount: state.parts.length,

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: isDesktopWeb ? 20 : 10,
                                mainAxisSpacing: isDesktopWeb ? 20 : 10,
                                childAspectRatio: 1,
                              ),

                          itemBuilder: (_, index) {
                            final part = state.parts[index];

                            return AirplanePartsCard(
                              part: part,
                              index: index,
                              onTap: () {
                                if (part.collectedCount == 0) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return AirplanePartLockedDialog(
                                        part: part,
                                        onContinue: () {},
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Airplane3DViewScreen(
                                        selectedPart: part,
                                      ),
                                    ),
                                  );
                                }
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
