import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'StickerModel.dart';
import 'StickerState.dart';

class StickerCubit extends Cubit<StickerState> {
  StickerCubit() : super(const StickerState());

  Future<void> loadStickers() async {
    emit(state.copyWith(status: CommonApiStatus.initial));

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      emit(
        state.copyWith(
          stickers: _mockStickers(),
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void unlockSticker(String id) {
    final updated = state.stickers.map((sticker) {
      if (sticker.id == id) {
        return sticker.copyWith(isUnlocked: true);
      }
      return sticker;
    }).toList();

    emit(state.copyWith(stickers: updated));
  }

  List<StickerModel> _mockStickers() {
    const planes = [
      ('A318', true),
      ('A318', false),
      ('A318', false),
      ('A318', false),
      ('A318', false),
      ('A318', false),
    ];

    return List.generate(planes.length, (index) {
      final (model, unlocked) = planes[index];

      return StickerModel(
        id: 'sticker_$index',
        brand: 'Airbus',
        model: model,
        isUnlocked: unlocked,
        imageUrl: 'https://picsum.photos/300/200?random=$index',
      );
    });
  }
}
