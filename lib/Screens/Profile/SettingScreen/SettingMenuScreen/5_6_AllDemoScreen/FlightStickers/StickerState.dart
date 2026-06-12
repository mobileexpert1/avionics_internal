import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'StickerModel.dart';

class StickerState {
  final List<StickerModel> stickers;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const StickerState({
    this.stickers = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  int get unlockedCount =>
      stickers.where((e) => e.isUnlocked).length;

  int get total => stickers.length;

  double get progress {
    if (stickers.isEmpty) return 0;
    return unlockedCount / stickers.length;
  }

  StickerState copyWith({
    List<StickerModel>? stickers,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return StickerState(
      stickers: stickers ?? this.stickers,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}