import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AircraftComparisonModel.dart';

class AircraftState {
  final List<AircraftModel> aircraftList;
  final bool isLoading;
  final bool isFetchingMore;
  final int currentPage;
  final bool hasNextPage;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  const AircraftState({
    required this.aircraftList,
    this.isLoading = false,
    this.isFetchingMore = false,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  AircraftState copyWith({
    List<AircraftModel>? aircraftList,
    bool? isLoading,
    bool? isFetchingMore,
    int? currentPage,
    bool? hasNextPage,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return AircraftState(
      aircraftList: aircraftList ?? this.aircraftList,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
