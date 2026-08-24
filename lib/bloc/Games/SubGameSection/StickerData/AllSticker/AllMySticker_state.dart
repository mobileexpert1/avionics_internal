import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AllMySticker_model.dart';

class AllMyStickerState {
  final AllMyStickerResponseModel? stickersAllData;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const AllMyStickerState({
    this.stickersAllData,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  AllMyStickerState copyWith({
    AllMyStickerResponseModel? stickersAllData,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return AllMyStickerState(
      stickersAllData: stickersAllData ?? this.stickersAllData,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}
