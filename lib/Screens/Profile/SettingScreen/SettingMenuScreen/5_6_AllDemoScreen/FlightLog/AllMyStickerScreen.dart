import 'package:avionics_internal/bloc/Games/SubGameSection/AllSticker/AllMySticker_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/AllSticker/AllMySticker_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../FlightStickers/ProgressHeader.dart';
import 'AllMyStickerCard.dart';

class AllMyStickerScreen extends StatefulWidget {
  const AllMyStickerScreen({super.key});

  @override
  State<AllMyStickerScreen> createState() => _AllMyStickerScreenState();
}

class _AllMyStickerScreenState extends State<AllMyStickerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AllMyStickerCubit>().loadMyStickers();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;

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
      body: BlocBuilder<AllMyStickerCubit, AllMyStickerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CommonApiStatus.failure) {
            return Center(child: Text(state.errorMessage ?? ''));
          }

          if (state.stickersAllData == null) {
            return const Center(child: Text('No stickers found'));
          } else {
            return SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1500),
                  child: Column(
                    children: [
                      ProgressHeader(
                        title: 'Sticker Unlock Progress',
                        unlocked: state.stickersAllData!.totalUnlocked,
                        total: state.stickersAllData!.total,
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                            itemCount: state.stickersAllData!.data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: isDesktopWeb ? 20 : 10,
                                  mainAxisSpacing: isDesktopWeb ? 20 : 10,
                                  childAspectRatio: isDesktopWeb ? 1.05 : 1,
                                ),
                            itemBuilder: (_, index) {
                              return AircraftCategoryCard(
                                category: state.stickersAllData!.data[index],
                                onTap: () {
                                  // AppNavigator.push(
                                  //   context,
                                  //   const StickerUnlockScreen(),
                                  //   disableSwipeBack: true,
                                  // );

                                  // showDialog(
                                  //   context: context,
                                  //   barrierDismissible: false,
                                  //   builder: (_) => StickerUnlockedDialog(
                                  //     category: state.categories[index],
                                  //     stickerName: "Airbus A318",
                                  //     imagePath:
                                  //         "assets/dummyPictures/MainLogoAirplane.png",
                                  //     onTap: () {
                                  // AppNavigator.push(
                                  //   context,
                                  //   const StickerUnlockScreen(),
                                  //   disableSwipeBack: true,
                                  // );
                                  //     },
                                  //   ),
                                  // );
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
          }
        },
      ),
    );
  }
}
