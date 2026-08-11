import 'package:flutter_earth_globe/globe_coordinates.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'jettingTheWorld_model.dart';

class JettingTheWorldState {
  final JettingTheWorldModel? jettingTheWorldModel;

  final List<AirportPerItemModel> airportList;

  final List<GlobeCoordinates> routeCoordinates;

  final bool isLoading;
  final bool isSuccess;

  final String? errorMessage;
  final String? apiError;

  final CommonApiStatus status;

  const JettingTheWorldState({
    this.jettingTheWorldModel,

    this.airportList = const [],

    this.routeCoordinates = const [],

    this.isLoading = false,

    this.isSuccess = false,

    this.errorMessage,

    this.apiError,

    this.status = CommonApiStatus.initial,
  });

  JettingTheWorldState copyWith({
    JettingTheWorldModel? jettingTheWorldModel,

    List<AirportPerItemModel>? airportList,

    List<GlobeCoordinates>? routeCoordinates,

    bool? isLoading,

    bool? isSuccess,

    String? errorMessage,

    String? apiError,

    CommonApiStatus? status,
  }) {
    return JettingTheWorldState(
      jettingTheWorldModel: jettingTheWorldModel ?? this.jettingTheWorldModel,

      airportList: airportList ?? this.airportList,

      routeCoordinates: routeCoordinates ?? this.routeCoordinates,

      isLoading: isLoading ?? this.isLoading,

      isSuccess: isSuccess ?? this.isSuccess,

      errorMessage: errorMessage ?? this.errorMessage,

      apiError: apiError ?? this.apiError,

      status: status ?? this.status,
    );
  }
}
