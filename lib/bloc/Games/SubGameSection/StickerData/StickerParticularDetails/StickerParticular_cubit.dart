import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../AllMySticker_repository.dart';
import 'StickerParticular_state.dart';

class StickerParticularCubit extends Cubit<StickerParticularState> {
  StickerParticularCubit() : super(StickerParticularState());

  Future<void> loadParticularStickerDetails(String stickerId) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        status: CommonApiStatus.initial,
      ),
    );

    try {
      final stickers = await AllMyStickerRepository()
          .geParticularStickerDetails(stickerId);

      emit(
        state.copyWith(
          stickerAircraftData: stickers,
          isLoading: false,
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
