import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AllMySticker_repository.dart';
import 'AllMySticker_state.dart';

class AllMyStickerCubit extends Cubit<AllMyStickerState> {

  AllMyStickerCubit() : super(AllMyStickerState());

  Future<void> loadMyStickers() async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        status: CommonApiStatus.initial,
      ),
    );

    try {
      final stickers = await AllMyStickerRepository().getListAllStickerTopic();

      emit(
        state.copyWith(
          stickersAllData: stickers,
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
