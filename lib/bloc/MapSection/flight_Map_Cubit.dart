// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../Constants/ApiClass/ApiErrorModel.dart';
// import 'flight_map_state.dart';
//
// class FlightMapCubit extends Cubit<FlightMapState> {
//   FlightMapCubit() : super(FlightMapState());
//
//   Future<void> getCurrentLocation(BuildContext context) async {
//     emit(state.copyWith(status: CommonApiStatus.submitting, isLoading: true));
//
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         emit(
//           state.copyWith(
//             status: CommonApiStatus.failure,
//             errorMessage: 'Location services are disabled.',
//             isLoading: false,
//           ),
//         );
//         return;
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           emit(state.copyWith(status: CommonApiStatus.failure, isLoading: false));
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')),
//           );
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         emit(state.copyWith(status: CommonApiStatus.failure, isLoading: false));
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location permissions are permanently denied'),
//           ),
//         );
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       emit(
//         state.copyWith(
//           position: position,
//           status: CommonApiStatus.success,
//           isSuccess: true,
//           isLoading: false,
//         ),
//       );
//     } on PlatformException catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Platform error: ${e.message}')));
//       emit(
//         state.copyWith(
//           status: CommonApiStatus.failure,
//           errorMessage: 'Platform error: ${e.message}',
//           isLoading: false,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Platform error: ${e.toString()}')),
//       );
//       emit(
//         state.copyWith(
//           status: CommonApiStatus.failure,
//           errorMessage: 'Something went wrong: ${e.toString()}',
//           isLoading: false,
//         ),
//       );
//     }
//   }
//
//   void resetLocationState() {
//     emit(FlightMapState());
//   }
// }


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import 'flight_map_repository.dart';
import 'flight_map_state.dart';


class FlightMapCubit extends Cubit<FlightMapState> {

  FlightMapCubit() : super(FlightMapState.initial());

  Future<void> loadFlights() async {
    emit(state.copyWith(isLoading: true));

    try {
      final bounds = "50.682,46.218,14.422,22.243";

      final flights = await FlightRepository().getFlights(bounds: bounds);

      emit(state.copyWith(
        flights: flights,
        isLoading: false,
        status: CommonApiStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        status: CommonApiStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

