import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'map_Search_Aircraft_List_Model.dart';

class MapSearchAircraftListState {
  final List<FlightResult> flights;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final CommonApiStatus status;
  final FlightStats? stats;
  final FlightResult? selectedFlight;

  const MapSearchAircraftListState({
    required this.flights,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
    this.stats,
    this.selectedFlight,
  });

  factory MapSearchAircraftListState.initial() {
    return const MapSearchAircraftListState(
      flights: [],
      status: CommonApiStatus.initial,
    );
  }

  MapSearchAircraftListState copyWith({
    List<FlightResult>? flights,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    CommonApiStatus? status,
    FlightStats? stats,
    FlightResult? selectedFlight,
  }) {
    return MapSearchAircraftListState(
      flights: flights ?? this.flights,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      stats: stats ?? this.stats,
      selectedFlight: selectedFlight ?? this.selectedFlight,
    );
  }
}
