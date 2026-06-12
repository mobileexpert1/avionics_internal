import '../../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AircraftCategoryModel.dart';

class AircraftCategoryState {
  final List<AircraftCategoryModel> categories;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const AircraftCategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  int get totalUnlocked =>
      categories.fold(0, (sum, item) => sum + item.unlockedCount);

  int get totalStickers =>
      categories.fold(0, (sum, item) => sum + item.totalCount);

  double get progress {
    if (totalStickers == 0) return 0;
    return totalUnlocked / totalStickers;
  }

  AircraftCategoryState copyWith({
    List<AircraftCategoryModel>? categories,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return AircraftCategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}
