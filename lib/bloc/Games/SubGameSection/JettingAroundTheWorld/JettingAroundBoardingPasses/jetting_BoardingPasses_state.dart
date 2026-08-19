import 'package:flutter_earth_globe/globe_coordinates.dart';

import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'jetting_BoardingPasses_model.dart';

class JettingBoardingPassState {
  final JettingBoardingPassModel? jettingTheWorldModel;
  final List<BoardingPassModel> airportList;
  final List<GlobeCoordinates> routeCoordinates;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const JettingBoardingPassState({
    this.jettingTheWorldModel,
    this.airportList = const [],
    this.routeCoordinates = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  JettingBoardingPassState copyWith({
    JettingBoardingPassModel? jettingTheWorldModel,
    List<BoardingPassModel>? airportList,
    List<GlobeCoordinates>? routeCoordinates,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return JettingBoardingPassState(
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
