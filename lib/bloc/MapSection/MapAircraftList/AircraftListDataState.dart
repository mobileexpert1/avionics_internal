import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Home/AircraftComparison/AircraftComparisonModel.dart';

class AircraftListDataState {
  final List<AircraftModel> aircraftList;
  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  const AircraftListDataState({
    required this.aircraftList,
    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  AircraftListDataState copyWith({
    List<AircraftModel>? aircraftList,
    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return AircraftListDataState(
      aircraftList: aircraftList ?? this.aircraftList,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
