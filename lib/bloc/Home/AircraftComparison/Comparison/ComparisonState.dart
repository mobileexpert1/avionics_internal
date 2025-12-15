import 'package:avionics_internal/bloc/Home/AircraftComparison/Comparison/ComparisonModel.dart';
import 'package:equatable/equatable.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';


class ComparisonState extends Equatable {
  final ComparisonModel? comparisonModel;
  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  const ComparisonState({
    this.comparisonModel,
    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ComparisonState copyWith({
    ComparisonModel? comparisonModel,
    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ComparisonState(
      comparisonModel: comparisonModel ?? this.comparisonModel,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    comparisonModel,
    isLoading,
    isSuccess,
    apiError,
    status,
    errorMessage,
  ];
}
