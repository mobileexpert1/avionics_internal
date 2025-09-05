// import 'package:geolocator/geolocator.dart';
// import '../../Constants/ApiClass/ApiErrorModel.dart';
// import 'flight_map_model.dart';
//
// class FlightMapState {
//   final Position? position;
//   final List<FlightModel>? flights;
//   final CommonApiStatus status;
//   final bool isLoading;
//   final bool isSuccess;
//   final String? errorMessage;
//   final String? selectedCountry;
//
//   FlightMapState({
//     this.position,
//     this.flights,
//     this.status = CommonApiStatus.initial,
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.errorMessage,
//     this.selectedCountry,
//   });
//
//   FlightMapState copyWith({
//     Position? position,
//     List<FlightModel>? flights,
//     CommonApiStatus? status,
//     bool? isLoading,
//     bool? isSuccess,
//     String? errorMessage,
//     String? selectedCountry,
//   }) {
//     return FlightMapState(
//       position: position ?? this.position,
//       flights: flights ?? this.flights,
//       status: status ?? this.status,
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       errorMessage: errorMessage ?? this.errorMessage,
//       selectedCountry: selectedCountry ?? this.selectedCountry,
//     );
//   }
// }


import 'package:geolocator/geolocator.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../Home/AircraftComparison/AircraftComparisonModel.dart';
import '../Home/AllPlanesBloc/AllPlanes_model.dart';
import 'MapAircraftList/aircraft_List_Data_State.dart';
import 'flight_map_model.dart';

class FlightMapState {
  final CommonApiStatus status;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Position? position;
  final List<FlightModel>? flights;
  final List<AircraftModel>? flightsListDetails;

  FlightMapState({
    this.status = CommonApiStatus.initial,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.position,
    this.flights,
    this.flightsListDetails,
  });

  FlightMapState copyWith({
    CommonApiStatus? status,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Position? position,
    List<FlightModel>? flights,
    List<AircraftModel>? flightsListDetails,
  }) {
    return FlightMapState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      flights: flights ?? this.flights,
      flightsListDetails: flightsListDetails ?? this.flightsListDetails,
    );
  }
}