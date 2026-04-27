import 'airCraftDetail_model.dart';

class AirCraftDetailState {
  final AirCraftDetailResponse? airCraftDetails;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;

  const AirCraftDetailState({
    this.airCraftDetails,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.errorMessage,
  });

  AirCraftDetailState copyWith({
    AirCraftDetailResponse? airCraftDetails,
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
    String? errorMessage,
  }) {
    return AirCraftDetailState(
      airCraftDetails: airCraftDetails ?? this.airCraftDetails,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
