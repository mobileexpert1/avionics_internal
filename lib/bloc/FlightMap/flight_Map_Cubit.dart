import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import 'flight_map_state.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  FlightMapCubit() : super(FlightMapState());

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: CommonApiStatus.submitting, isLoading: true));

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: 'Location services are disabled.',
            isLoading: false,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              status: CommonApiStatus.failure,
              errorMessage: 'Location permissions are denied',
              isLoading: false,
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: 'Location permissions are permanently denied',
            isLoading: false,
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      emit(
        state.copyWith(
          position: position,
          status: CommonApiStatus.success,
          isSuccess: true,
          isLoading: false,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Platform error: ${e.message}',
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Something went wrong: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  void resetLocationState() {
    emit(FlightMapState());
  }
}

