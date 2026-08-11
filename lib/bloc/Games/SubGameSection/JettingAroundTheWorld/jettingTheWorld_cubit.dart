import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
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
}
