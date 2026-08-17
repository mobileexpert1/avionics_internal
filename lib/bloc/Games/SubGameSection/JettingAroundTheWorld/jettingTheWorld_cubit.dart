import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../Calculation_Section/calculation_submit_model.dart';
import 'jettingTheWorld_model.dart';
import 'jettingTheWorld_repository.dart';
import 'jettingTheWorld_state.dart';

class JettingTheWorldCubit extends Cubit<JettingTheWorldState> {
  JettingTheWorldCubit() : super(const JettingTheWorldState());

  Future<void> loadAirports(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

        final response = await JettingTheWorldRepository().getAirports();

        if (response != null) {
          final airportList = response.data.map((airport) {
            return AirportPerItemModel(
              icao: airport.icao,
              iata: airport.iata,
              distanceNm: airport.distanceNm,
              flightSegment1: airport.flightSegment1,
              flightSegment2: airport.flightSegment2,
              id: airport.id,
              city: airport.city,
              country: airport.country,
              equatorDistance: airport.equatorDistance,
              latitude: airport.latitude,
              longitude: airport.longitude,
              unlocked: airport.unlocked,
            );
          }).toList();

          emit(
            state.copyWith(
              airportList: airportList,
              isLoading: false,
              isSuccess: true,
              status: CommonApiStatus.success,
            ),
          );
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    }
  }

  Future<void> loadAirportsFromUnlockResponse(
    BuildContext context,
      SubmitCalculationResultData responseData,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

      final unlockAirport = responseData.['data']?['unlock_airport'];

      if (unlockAirport == null) {
        emit(
          state.copyWith(
            isLoading: false,
            status: CommonApiStatus.failure,
            errorMessage: 'Unlock airport data not found',
          ),
        );
        return;
      }

      final preUnblock = unlockAirport['pre_unblock'];
      final newUnblock = unlockAirport['new_unblock'];

      final List<AirportPerItemModel> updatedAirportList = [
        ...state.airportList,
      ];

      // Previous airport
      if (preUnblock != null) {
        final airport = AirportPerItemModel(
          id: preUnblock['id'],
          city: preUnblock['city'],
          country: preUnblock['country'],
          icao: preUnblock['icao'],
          iata: preUnblock['iata'],
          equatorDistance: preUnblock['equator_distance'],
          flightSegment1: preUnblock['flight_segment_1'],
          flightSegment2: preUnblock['flight_segment_2'],
          distanceNm: (preUnblock['distance_nm'] as num?)!.toDouble(),
          latitude: (preUnblock['latitude'] as num?)!.toDouble(),
          longitude: (preUnblock['longitude'] as num?)!.toDouble(),
          unlocked: preUnblock['unlocked'] ?? false,
        );

        // Avoid duplicate airport
        final alreadyExists = updatedAirportList.any(
          (item) => item.id == airport.id,
        );

        if (!alreadyExists) {
          updatedAirportList.add(airport);
        }
      }

      // Newly unlocked airport
      if (newUnblock != null) {
        final airport = AirportPerItemModel(
          id: newUnblock['id'],
          city: newUnblock['city'],
          country: newUnblock['country'],
          icao: newUnblock['icao'],
          iata: newUnblock['iata'],
          equatorDistance: newUnblock['equator_distance'],
          flightSegment1: newUnblock['flight_segment_1'],
          flightSegment2: newUnblock['flight_segment_2'],
          distanceNm: (newUnblock['distance_nm'] as num?)!.toDouble(),
          latitude: (newUnblock['latitude'] as num?)!.toDouble(),
          longitude: (newUnblock['longitude'] as num?)!.toDouble(),
          unlocked: newUnblock['unlocked'] ?? false,
        );

        // Avoid duplicate airport
        final alreadyExists = updatedAirportList.any(
          (item) => item.id == airport.id,
        );

        if (!alreadyExists) {
          updatedAirportList.add(airport);
        }
      }

      emit(
        state.copyWith(
          airportList: updatedAirportList,
          isLoading: false,
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          status: CommonApiStatus.failure,
        ),
      );
    }
  }
}

String getTheDynamicTitleAccordingToLevel(int currentLevel) {
  switch (currentLevel) {
    case 0:
      return "TakeOff";
    case 1:
      return "Climb";
    case 2:
      return "En- Route";
    case 3:
      return "Decent";
    case 4:
      return "Landing";
    default:
      return "";
  }
}
