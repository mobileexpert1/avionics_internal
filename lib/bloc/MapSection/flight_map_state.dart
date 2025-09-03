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
import 'flight_map_model.dart';

class FlightMapState {
  final CommonApiStatus status;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Position? position;
  final List<FlightModel>? flights;

  FlightMapState({
    this.status = CommonApiStatus.initial,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.position,
    this.flights,
  });

  FlightMapState copyWith({
    CommonApiStatus? status,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Position? position,
    List<FlightModel>? flights,
  }) {
    return FlightMapState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      flights: flights ?? this.flights,
    );
  }
}