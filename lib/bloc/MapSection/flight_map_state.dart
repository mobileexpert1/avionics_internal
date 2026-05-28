import 'dart:math' as math;

import 'package:avionics_internal/bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_detailModel.dart';
import 'package:flutter/cupertino.dart';
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

  final int activeCard;
  final List<AircraftStationModel>? airports;
  final AircraftStationModel? selectedAirport;
  final List<String>? selectedCategories;
  final List<String>? selectedAircraftIcaos;
  final SavedFlightResponse? savedFlights;

  final int? numberOfFlights;
  final int? searchRadius;

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

    this.savedFlights,

    this.numberOfFlights = 10,
    this.searchRadius = 150,
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

    int? numberOfFlights,
    int? searchRadius,
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
      selectedAircraftIcaos:
          selectedAircraftIcaos ?? this.selectedAircraftIcaos,
      savedFlights: savedFlights ?? this.savedFlights,

      numberOfFlights: numberOfFlights ?? this.numberOfFlights,
      searchRadius: searchRadius ?? this.searchRadius,
    );
  }
}

double convertNmToMeters(int nm) {
  return nm * 1852;
}

LatLngBounds getBoundsFromRadius({
  required LatLng center,
  required double radiusMeters,
}) {
  const double earthRadius = 6378137;

  final lat = center.latitude * math.pi / 180;
  final lng = center.longitude * math.pi / 180;

  final angularDistance = radiusMeters / earthRadius;

  final minLat = lat - angularDistance;
  final maxLat = lat + angularDistance;

  final sinVal = math.sin(angularDistance) / math.cos(lat);
  final clampedSinVal = sinVal.clamp(-1.0, 1.0);
  final deltaLng = math.asin(clampedSinVal);

  final minLng = lng - deltaLng;
  final maxLng = lng + deltaLng;

  final clampedMinLat = (minLat * 180 / math.pi).clamp(-90.0, 90.0);
  final clampedMaxLat = (maxLat * 180 / math.pi).clamp(-90.0, 90.0);

  double clampedMinLng = (minLng * 180 / math.pi);
  double clampedMaxLng = (maxLng * 180 / math.pi);

  if (clampedMinLng < -180) clampedMinLng += 360;
  if (clampedMaxLng > 180) clampedMaxLng -= 360;

  return LatLngBounds(
    southwest: LatLng(clampedMinLat, clampedMinLng),
    northeast: LatLng(clampedMaxLat, clampedMaxLng),
  );
}

LatLng getBoundsCenter(LatLngBounds bounds) {
  return LatLng(
    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
    (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
  );
}

double getZoomLevelFromRadius(int radiusNm) {
  debugPrint("Radius NM: $radiusNm");
  if (radiusNm <= 1) return 8.3;
  if (radiusNm <= 5) return 8.2;
  if (radiusNm <= 10) return 8.1;
  if (radiusNm <= 25) return 7.6;
  if (radiusNm <= 50) return 7.5;
  if (radiusNm <= 75) return 6.9;
  if (radiusNm <= 100) return 6.7;
  if (radiusNm <= 150) return 6.2;
  if (radiusNm <= 200) return 5.9;
  if (radiusNm <= 300) return 5.4;
  if (radiusNm <= 400) return 4.95;
  if (radiusNm <= 500) return 4.7;
  if (radiusNm <= 750) return 4.2;
  if (radiusNm <= 1050) return 3.7;
  return 3.4;
}

double getVisualRadiusBufferNm(int radiusNm) {
  debugPrint("Radius NM: $radiusNm");
  if (radiusNm <= 50) return 40;
  if (radiusNm <= 100) return 60;
  if (radiusNm <= 200) return 80;
  if (radiusNm <= 300) return 100;
  if (radiusNm <= 400) return 130;
  if (radiusNm <= 500) return 150;
  if (radiusNm <= 750) return 170;
  if (radiusNm <= 1050) return 200;
  return 30;
}
