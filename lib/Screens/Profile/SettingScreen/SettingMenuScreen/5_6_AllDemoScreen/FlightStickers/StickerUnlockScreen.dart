import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../../Constants/ConstantStrings.dart';
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
                ProgressHeader(
                  unlocked: state.unlockedCount,
                  total: state.total,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: GridView.builder(
                      itemCount: state.stickers.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final sticker = state.stickers[index];

                        return StickerCard(
                          sticker: sticker,
                          onTap: !sticker.isUnlocked
                              ? () {
                                  context.read<StickerCubit>().unlockSticker(
                                    sticker.id,
                                  );
                                }
                              : null,
                        );
                      },
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
