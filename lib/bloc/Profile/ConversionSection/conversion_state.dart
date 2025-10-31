import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'conversion_model.dart';

class ConversionState {
  final List<ConversionCategory> categories;
  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  ConversionState({
    this.categories = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ConversionState copyWith({
    List<ConversionCategory>? categories,
    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ConversionState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}