import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AirmanshipBadgeModel.dart';

class AirmanshipBadgesState {
  final List<AirmanshipBadgeModel> categories;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const AirmanshipBadgesState({
    this.categories = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  AirmanshipBadgesState copyWith({
    List<AirmanshipBadgeModel>? categories,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return AirmanshipBadgesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}