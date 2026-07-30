import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import 'ProgressHeader.dart';
import 'StickerCard.dart';
import 'StickerCubit.dart';
import 'StickerState.dart';

class StickerUnlockScreen extends StatefulWidget {
  const StickerUnlockScreen({super.key});

  @override
  State<StickerUnlockScreen> createState() => _StickerUnlockScreenState();
}

class _StickerUnlockScreenState extends State<StickerUnlockScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StickerCubit>().loadStickers();
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
      body: BlocBuilder<StickerCubit, StickerState>(
        builder: (context, state) {
          if (state.status == CommonApiStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CommonApiStatus.failure) {
            return Center(child: Text(state.errorMessage ?? ''));
          }

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
                        unlocked: state.unlockedCount,
                        total: state.total,
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
                          itemCount: state.stickers.length,
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
                            final sticker = state.stickers[index];

                            return StickerCard(
                              sticker: sticker,
                              onTap: !sticker.isUnlocked
                                  ? () {
                                      context
                                          .read<StickerCubit>()
                                          .unlockSticker(sticker.id);
                                    }
                                  : null,
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
        },
      ),
    );
  }
}
