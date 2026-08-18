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

      final unlockAirport = responseData.unlockAirport;

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

      final List<AirportPerItemModel> updatedAirportList = [
        ...state.airportList,
      ];

      final airports = [unlockAirport.preUnblock, unlockAirport.newUnblock];

      for (final airport in airports) {
        if (airport == null) continue;

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
      return "Takeoff";
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
