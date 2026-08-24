import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../bloc/Games/SubGameSection/StickerData/StickerParticularDetails/StickerParticular_cubit.dart';
import '../../../../../bloc/Games/SubGameSection/StickerData/StickerParticularDetails/StickerParticular_state.dart';
import 'ProgressHeader.dart';
import 'StickerParticularCard.dart';

class StickerUnlockScreen extends StatefulWidget {
  const StickerUnlockScreen({super.key, required this.stickerId});

  final String stickerId;

  @override
  State<StickerUnlockScreen> createState() => _StickerUnlockScreenState();
}

class _StickerUnlockScreenState extends State<StickerUnlockScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StickerParticularCubit>().loadParticularStickerDetails(
      widget.stickerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;
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
      body: BlocBuilder<StickerParticularCubit, StickerParticularState>(
        builder: (context, state) {
          if (state.status == CommonApiStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CommonApiStatus.failure) {
            return Center(child: Text(state.errorMessage ?? ''));
          }

          if (state.stickerAircraftData != null) {
            return SafeArea(
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktopWeb ? 1400 : double.infinity,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktopWeb
                              ? 20
                              : isMobileWeb
                              ? 12
                              : 0,
                        ),
                        child: ProgressHeader(
                          unlocked: state
                              .stickerAircraftData!
                              .data
                              .aircraftSummary
                              .unlocked,
                          total: state
                              .stickerAircraftData!
                              .data
                              .aircraftSummary
                              .total,
                          title: 'Sticker Unlock Progress',
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isDesktopWeb ? 1400 : double.infinity,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktopWeb
                                ? 30
                                : isMobileWeb
                                ? 12
                                : 10,
                            vertical: 8,
                          ),
                          child: GridView.builder(
                            itemCount: state
                                .stickerAircraftData!
                                .data
                                .aircrafts
                                .length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktopWeb
                                      ? 4
                                      : isMobileWeb
                                      ? 2
                                      : 2,
                                  crossAxisSpacing: isDesktopWeb ? 20 : 10,
                                  mainAxisSpacing: isDesktopWeb ? 20 : 10,
                                  childAspectRatio: isDesktopWeb
                                      ? 1.0
                                      : isMobileWeb
                                      ? 0.92
                                      : 1.0,
                                ),
                            itemBuilder: (context, index) {
                              final sticker = state
                                  .stickerAircraftData!
                                  .data
                                  .aircrafts[index];

                              return StickerCard(
                                sticker: sticker,
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('No Sticker Data available'));
        },
      ),
    );
  }
}
