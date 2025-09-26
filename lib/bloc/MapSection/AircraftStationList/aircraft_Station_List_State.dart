import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'aircraft_Station_List_Model.dart';

class AircraftStationListState {
  final List<AircraftStationModel> stations;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final CommonApiStatus status;
  final String? detail;

  const AircraftStationListState({
    required this.stations,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
    this.detail,
  });

  factory AircraftStationListState.initial() {
    return const AircraftStationListState(
      stations: [],
      status: CommonApiStatus.initial,
    );
  }

  AircraftStationListState copyWith({
    List<AircraftStationModel>? stations,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    CommonApiStatus? status,
    String? detail,
  }) {
    return AircraftStationListState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      detail: detail ?? this.detail,
    );
  }
}
