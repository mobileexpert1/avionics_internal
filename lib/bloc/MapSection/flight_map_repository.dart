import 'package:flutter/material.dart';

import '../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Helpers/CreditManager/CreditManager.dart';
import '../../Screens/Profile/SettingScreen/SettingMenuScreen/3_AddOnPacks/AddOnPacksScreen.dart';
import 'flight_key_values_model.dart';
import 'flight_map_detailModel.dart';
import 'flight_map_model.dart';

class FlightRepository {
  Future<BaseDetailResponseModel> postFlightCreditApi({
    required int type,
    required int credit,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiFunctionUrlAirplaneConstant.aircraftFlightCredit,
    );
    try {
      final response = await ApiService.post(
        url: url,
        body: {"type": type, "credit": credit},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<FlightModel>> getFlights({
    required String bounds,
    required flightLimit,
    String? aircraft,
    String? categories,
    required BuildContext context,
  }) async {
    try {
      final baseUrl =
          "${MapFlightAircraftSectionConstant.baseUrl}/flight-positions/full";

      String finalAircraft = "A318,A320,A20N,A21N";
      String finalCategories = "C,P";

      if (aircraft != null && aircraft.isNotEmpty) {
        finalAircraft = aircraft;
      }

      if (categories != null && categories.isNotEmpty) {
        finalCategories = categories;
      }

      if (CreditManager().remainingCredit <= 10 &&
          CreditManager().remainingCredit >= 8) {
        flightLimit = 1;
      } else {
        if (CreditManager().remainingCredit <= 8) {
          AlertHelperForSubsPopup.showSubscriptionEndAlert(
            isFromTrackingClass: false,
            context: context,
            title: "Credits limit exhausted",
            isFromWilcoAndTrackingScreen: true,
            buttonText: "Buy Credits",
            message:
                "Your credits limit has been exhausted. Please purchase a extra credits.",
            onGoToActionBlock: () {
              openAddOnPacksBottomSheet(context, AddOnPackType.creditsOnly);
            },
          );
          return [];
        }
      }

      final url = Uri.parse(
        "$baseUrl?"
        "bounds=$bounds"
        "&limit=$flightLimit"
        "&aircraft=$finalAircraft"
        "&altitude_ranges=0-46000"
        "&categories=$finalCategories",
      );

      var mapKeyValue = await SharedPrefsHelper.getMapKeyValuesForApi();
      if (mapKeyValue.isEmpty) {
        try {
          final responseKeyValue = await FlightRepository()
              .getMapKeyValueFromServer();
          if (responseKeyValue.data.fr24 != null &&
              responseKeyValue.data.fr24 != "") {
            await SharedPrefsHelper.seMapKeyValuesFromServer(
              responseKeyValue.data.fr24 ?? "",
            );
          }
        } catch (e) {
          throw e.toString();
        }
      }
      final response = await ApiService.get(url: url, isForFlightRadar: true);
      final flightResponse = FlightResponse.fromJson(response);
      return flightResponse.flights;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<FlightResponse> getParticularFlightDetails({
    required String flightId,
  }) async {
    final url = Uri.parse(
      "${MapFlightAircraftSectionConstant.baseUrl}/flight-positions/full"
      "?bounds=90,-90,-180,180&flights=$flightId",
    );

    try {
      final response = await ApiService.get(url: url, isForFlightRadar: true);
      final flightResponse = FlightResponse.fromJson(response);
      return flightResponse;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> openAddOnPacksBottomSheet(
    BuildContext context,
    AddOnPackType packType,
  ) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.80,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AddOnPacksScreen(packType: packType),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> getFlightDetails({
    required String flightId,
    required String fromDateTime,
    required String toDateTime,
    required BuildContext context,
    FlightModel? flightModel,
  }) async {
    if (CreditManager().remainingCredit <= 2) {
      Future.microtask(() {
        AlertHelperForSubsPopup.showSubscriptionEndAlert(
          isFromTrackingClass: false,
          context: context,
          title: "Credits limit exhausted",
          isFromWilcoAndTrackingScreen: true,
          buttonText: "Buy Credits",
          message:
              "Your credits limit has been exhausted. Please purchase a extra credits.",
          onGoToActionBlock: () {
            openAddOnPacksBottomSheet(context, AddOnPackType.creditsOnly);
          },
        );
      });
      return null;
    }

    final url = Uri.parse(
      "${MapFlightAircraftSectionConstant.baseUrlDetail}"
      "?flight_ids=$flightId"
      "&flight_datetime_from=$fromDateTime"
      "&flight_datetime_to=$toDateTime",
    );

    try {
      final response = await ApiService.get(url: url, isForFlightRadar: true);
      final flightResponse = FlightDetailResponse.fromJson(response);

      FlightAircraftDetail flightDetail;
      if (flightResponse.result != null) {
        flightDetail = flightResponse.result!;
      } else if (flightResponse.flights.isNotEmpty) {
        flightDetail = flightResponse.flights.first;
      } else {
        throw Exception("No flight data found for ID: $flightId");
      }
      final aircraftDetails = await getAircraftDetails(
        aircraftId: flightDetail.type ?? '',
        origIcao: flightDetail.departureIcao ?? '',
        destIcao: flightDetail.arrivalIcao ?? '',
        callSign: flightDetail.callsign ?? '',
      );

      final mergedDetail = mergeFlightAndAircraftDetails(
        flightDetail,
        aircraftDetails,
      );
      return {'flightDetail': mergedDetail, 'flightModel': flightModel};
    } catch (e) {
      throw e.toString();
    }
  }

  FlightAircraftDetail mergeFlightAndAircraftDetails(
    FlightAircraftDetail flightDetail,
    List<FlightAircraftDetail> aircraftDetails,
  ) {
    final aircraftDetail = aircraftDetails.isNotEmpty
        ? aircraftDetails.first
        : null;

    return FlightAircraftDetail(
      id: flightDetail.id,
      flightNumber: flightDetail.flightNumber,
      callsign: flightDetail.callsign,
      operatingAs: flightDetail.operatingAs,
      paintedAs: flightDetail.paintedAs,
      type: flightDetail.type,
      registration: flightDetail.registration,
      departureIata: flightDetail.departureIata,
      departureIcao: flightDetail.departureIcao,
      arrivalIata: flightDetail.arrivalIata,
      arrivalIcao: flightDetail.arrivalIcao,
      eta: flightDetail.eta,
      latitude: flightDetail.latitude,
      longitude: flightDetail.longitude,
      track: flightDetail.track,
      groundSpeed: flightDetail.groundSpeed,
      altitude: flightDetail.altitude,

      // Aircraft fields:
      aircraftModelId: aircraftDetail?.aircraftModelId,
      aircraftModel:
          aircraftDetail?.aircraftModel ?? flightDetail.aircraftModel,
      isFavorite: aircraftDetail?.isFavorite ?? flightDetail.isFavorite,
      icaoTypeCode: aircraftDetail?.icaoTypeCode ?? flightDetail.icaoTypeCode,
      image: aircraftDetail?.image ?? flightDetail.image,
      manufacturer: aircraftDetail?.manufacturer ?? flightDetail.manufacturer,

      // Airport fields
      originAirport:
          aircraftDetail?.originAirport ?? flightDetail.originAirport,
      destinationAirport:
          aircraftDetail?.destinationAirport ?? flightDetail.destinationAirport,
      // Preserve other fields from flightDetail
      takeoffTime: flightDetail.takeoffTime,
      takeoffRunway: flightDetail.takeoffRunway,
      actualArrivalIcao: flightDetail.actualArrivalIcao,
      actualArrivalIata: flightDetail.actualArrivalIata,
      landingTime: flightDetail.landingTime,
      landingRunway: flightDetail.landingRunway,
      flightTime: flightDetail.flightTime,
      actualDistance: flightDetail.actualDistance,
      circleDistance: flightDetail.circleDistance,
      category: flightDetail.category,
      hex: flightDetail.hex,
      firstSeen: flightDetail.firstSeen,
      lastSeen: flightDetail.lastSeen,
      flightEnded: flightDetail.flightEnded,
    );
  }

  Future<List<FlightAircraftDetail>> getAircraftDetails({
    required String aircraftId,
    required String origIcao,
    required String destIcao,
    required String callSign,
  }) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiServiceUrlAirplaneConstant.getListAirbus}details"
      "?aircraft_id=$aircraftId&orig_icao=$origIcao&dest_icao=$destIcao&callsign=$callSign",
    );

    try {
      final response = await ApiService.get(url: url);
      final aircraftResponse = FlightDetailResponse.fromJson(response);

      if (aircraftResponse.result != null) {
        return [aircraftResponse.result!];
      }
      return aircraftResponse.flights;
    } catch (e) {
      print('Error fetching aircraft details: $e');
      return [];
    }
  }

  Future<FlightResponse?> getFlightPositions(String flightNumber) async {
    String url =
        "${MapFlightAircraftSectionConstant.baseUrlForFlightPosition}90,"
        "-90,-180,180&&flights=$flightNumber";
    final uri = Uri.parse(url);
    try {
      final jsonData =
          await ApiService.get(url: uri, isForFlightRadar: true)
              as Map<String, dynamic>;
      return FlightResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<FlightKeyValuesModel> getMapKeyValueFromServer() async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.authFetchMapKey,
    );
    try {
      final jsonData =
          await ApiService.get(url: uri, isForFlightRadar: true)
              as Map<String, dynamic>;
      return FlightKeyValuesModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<FlightModel>> getFlightsWithFilters({
    required String bounds,
    int limit = 20,
    List<String>? selectedIcaoTypes,
    List<String>? selectedCategories,
  }) async {
    try {
      final aircraftParam =
          (selectedIcaoTypes != null && selectedIcaoTypes.isNotEmpty)
          ? selectedIcaoTypes.join(',')
          : 'A318,A320,A20N,A21N';

      final categoriesParam =
          (selectedCategories != null && selectedCategories.isNotEmpty)
          ? selectedCategories.join(',')
          : 'C,P';

      final url = Uri.parse(
        "${MapFlightAircraftSectionConstant.baseUrl}/flight-positions/full"
        "?bounds=$bounds"
        "&limit=$limit"
        "&aircraft=$aircraftParam"
        "&altitude_ranges=0-46000"
        "&categories=$categoriesParam",
      );

      final response = await ApiService.get(url: url, isForFlightRadar: true);
      final flightResponse = FlightResponse.fromJson(response);
      return flightResponse.flights;
    } catch (e) {
      throw e.toString();
    }
  }
}
