import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Home/AircraftComparison/AircraftComparisonModel.dart';

class AircraftListResponse {
  final String detail;
  final List<AircraftModel> data;

  AircraftListResponse({
    required this.detail,
    required this.data,
  });

  factory AircraftListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    return AircraftListResponse(
      detail: json['detail'] ?? '',
      data: dataList.map((e) => AircraftModel.fromJson(e)).toList(),
    );
  }
}

class AircraftListDataState {
  final List<AircraftModel> aircraftList; // FIX: use AircraftListModel
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final CommonApiStatus status;
  final String? detail;

  const AircraftListDataState({
    required this.aircraftList,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
    this.detail,
  });

  factory AircraftListDataState.initial() {
    return const AircraftListDataState(
      aircraftList: [],
      status: CommonApiStatus.initial,
    );
  }

  AircraftListDataState copyWith({
    List<AircraftModel>? aircraftList, // FIX
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    CommonApiStatus? status,
    String? detail,
  }) {
    return AircraftListDataState(
      aircraftList: aircraftList ?? this.aircraftList,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      detail: detail ?? this.detail,
    );
  }
}
