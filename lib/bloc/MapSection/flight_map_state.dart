import 'package:avionics_internal/bloc/MapSection/flight_map_detailModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../Home/AircraftComparison/AircraftComparisonModel.dart';
import 'flight_map_model.dart';

class FlightMapState {
  final CommonApiStatus status;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Position? position;
  final List<FlightModel>? flights;
  final List<AircraftModel>? flightsListDetails;
  final MapType mapType;
  final List<FlightAircraftDetail>? flightDetail;
  final FlightAircraftDetail? selectedFlightDetail;
  final AircraftModel? selectedAircraftDetails;
  final FlightModel? selectedFlight;
  final bool isTracking;
  final Set<Marker> markers;
  final int animationDuration;

  FlightMapState({
    this.status = CommonApiStatus.initial,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.position,
    this.flights,
    this.flightsListDetails,
    this.mapType = MapType.normal,
    this.flightDetail,
    this.selectedFlightDetail,
    this.selectedAircraftDetails,
    this.selectedFlight,
    this.isTracking = false,
    this.markers = const {},
    this.animationDuration = 50,
  });

  FlightMapState copyWith({
    CommonApiStatus? status,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Position? position,
    List<FlightModel>? flights,
    List<AircraftModel>? flightsListDetails,
    MapType? mapType,
    List<FlightAircraftDetail>? flightDetail,
    FlightAircraftDetail? selectedFlightDetail,
    AircraftModel? selectedAircraftDetails,
    FlightModel? selectedFlight,
    bool? isTracking,
    Set<Marker>? markers,
    int? animationDuration,
  }) {
    return FlightMapState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      flights: flights ?? this.flights,
      flightsListDetails: flightsListDetails ?? this.flightsListDetails,
      mapType: mapType ?? this.mapType,
      flightDetail: flightDetail ?? this.flightDetail,
      selectedFlightDetail: selectedFlightDetail ?? this.selectedFlightDetail,
      selectedAircraftDetails:
          selectedAircraftDetails ?? this.selectedAircraftDetails,
      selectedFlight: selectedFlight ?? this.selectedFlight,
      isTracking: isTracking ?? this.isTracking,
        markers: markers ?? this.markers,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}
