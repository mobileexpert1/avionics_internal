import 'package:avionics_internal/bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_detailModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../Home/AircraftComparison/AircraftComparisonModel.dart';
import '../Home/SavedFlighDetails/savedFlight_model.dart';
import 'FilterMap/filter_Map_State.dart';
import 'flight_map_model.dart';

class FlightMapState {
  final String? openAiKey;
  final bool isLoading;
  final bool isFlightLanded;
  final CommonApiStatus status;
  final bool isSuccess;
  final String? errorMessage;
  final Position? position;
  final List<FlightModel>? flights;
  final List<AircraftModel>? flightsListDetails;
  final CustomMapType mapType;
  final List<FlightAircraftDetail>? flightDetail;
  final FlightAircraftDetail? selectedFlightDetail;
  final AircraftModel? selectedAircraftDetails;
  final FlightModel? selectedFlight;
  final bool isTracking;
  final Set<Marker> markers;
  final int animationDuration;

  final List<AircraftStationModel>? airports;
  final AircraftStationModel? selectedAirport;


  final List<String>? selectedCategories;
  final List<String>? selectedAircraftIcaos;

  final int activeCard;

  final SavedFlightResponse? savedFlights;

  FlightMapState({
    this.openAiKey,
    this.status = CommonApiStatus.initial,
    this.isLoading = false,
    this.isFlightLanded = false,
    this.isSuccess = false,
    this.errorMessage,
    this.position,
    this.flights,
    this.flightsListDetails,
    this.mapType = CustomMapType.standard,
    this.flightDetail,
    this.selectedFlightDetail,
    this.selectedAircraftDetails,
    this.selectedFlight,
    this.isTracking = false,
    this.markers = const {},
    this.animationDuration = 50,
    this.airports,
    this.selectedAirport,
    this.activeCard = 0,

    this.selectedCategories,
    this.selectedAircraftIcaos,

    this.savedFlights

  });

  FlightMapState copyWith({
    String? openAiKey,
    CommonApiStatus? status,
    bool? isLoading,
    bool? isFlightLanded,
    bool? isSuccess,
    String? errorMessage,
    Position? position,
    List<FlightModel>? flights,
    List<AircraftModel>? flightsListDetails,
    CustomMapType? mapType,
    List<FlightAircraftDetail>? flightDetail,
    FlightAircraftDetail? selectedFlightDetail,
    AircraftModel? selectedAircraftDetails,
    FlightModel? selectedFlight,
    bool? isTracking,
    Set<Marker>? markers,
    int? animationDuration,
    List<AircraftStationModel>? airports,
    AircraftStationModel? selectedAirport,
    int? activeCard,


    List<String>? selectedCategories,
    List<String>? selectedAircraftIcaos,
    SavedFlightResponse? savedFlights,
  }) {
    return FlightMapState(
      openAiKey: openAiKey ?? this.openAiKey,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isFlightLanded: isFlightLanded ?? this.isFlightLanded,
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
      airports: airports ?? this.airports,
      selectedAirport: selectedAirport ?? this.selectedAirport,
      activeCard: activeCard ?? this.activeCard,

      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedAircraftIcaos: selectedAircraftIcaos ?? this.selectedAircraftIcaos,
      savedFlights: savedFlights ?? this.savedFlights,
    );
  }
}
