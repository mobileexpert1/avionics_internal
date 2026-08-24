import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'StickerParticular_model.dart';

class StickerParticularState {
  final StickerParticularResponse? stickerAircraftData;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const StickerParticularState({
    this.stickerAircraftData,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  StickerParticularState copyWith({
    StickerParticularResponse? stickerAircraftData,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return StickerParticularState(
      stickerAircraftData: stickerAircraftData ?? this.stickerAircraftData,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}
