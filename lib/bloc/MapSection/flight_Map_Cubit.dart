import 'dart:async';

import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Helpers/CreditManager/CreditManager.dart';
import '../../Helpers/NoInternetDialog.dart';
import '../../Helpers/push_notifications/LocalNotificationHelper.dart';
import '../../Screens/Profile/SettingScreen/SettingMenuScreen/3_AddOnPacks/AddOnPacksScreen.dart';
import '../Home/SavedFlighDetails/savedFlight_repository.dart';
import 'AircraftStationList/aircraft_Station_List_Model.dart';
import 'AircraftStationList/aircraft_Station_List_Repository.dart';
import 'FilterMap/filter_Map_State.dart';
import 'MapAircraftList/aircraft_List_Data_Repository.dart';
import 'flight_map_detailModel.dart';
import 'flight_map_model.dart';
import 'flight_map_state.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  Timer? _trackingTimer;
  Set<String>? _favCallSigns;
  bool? isFromTrackingClass;

  FlightMapCubit() : super(FlightMapState());

  void resetTracking() {
    isFromTrackingClass = false;
  }

  void updateTheNumberOfFlightAndRadius(int numberOfFlights, int radius) {
    emit(
      state.copyWith(numberOfFlights: numberOfFlights, searchRadius: radius),
    );
  }

  void changeMapType(CustomMapType type) {
    emit(state.copyWith(mapType: type));
  }

  void setSelectedFlight(FlightModel flight) {
    emit(state.copyWith(selectedFlight: flight));
  }

  void setSelectedAirport(AircraftStationModel airportModel) {
    emit(state.copyWith(selectedAirport: airportModel));
  }

  void clearSelectedFlightDetail() {
    emit(state.copyWith(selectedFlightDetail: null));
  }

  void setFilters(List<String> categories, List<String> aircraftIcaos) {
    emit(
      state.copyWith(
        selectedFlightCategories: categories,
        selectedAircraftIcaos: aircraftIcaos,
      ),
    );
  }

  void toggleFavoriteByCallSign(String? callSign) {
    if (callSign == null || state.flights == null) return;
    final updatedFlights = state.flights!.map((flight) {
      if (flight.callSign == callSign) {
        return flight.copyWith(isFavorite: !(flight.isFavorite));
      }
      return flight;
    }).toList();

    emit(state.copyWith(flights: updatedFlights));
    final newValueForFavUnFavFlights = state.isFavFlightByS ?? false;
    emit(
      state.copyWith(
        flights: updatedFlights,
        isFavFlightByS: !newValueForFavUnFavFlights,
      ),
    );
  }

  Future<bool> getCurrentLocation(BuildContext context) async {
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
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              status: CommonApiStatus.failure,
              isLoading: false,
              errorMessage:
                  'Location permissions are permanently denied.\n   Please enable them from settings.',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permissions are permanently denied.\n   Please enable them from settings.',
              ),
            ),
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            isLoading: false,
            errorMessage:
                'Location permissions are permanently denied.\n   Please enable them from settings.',
          ),
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permission'),
            content: const Text(
              'Location permissions are permanently denied.\n   Please enable them from settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            position: position,
            status: CommonApiStatus.success,
            isSuccess: true,
            isLoading: false,
          ),
        );
      }

      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
      return false;
    }
  }

  // ── DATA LOADING ───────────────────────────────────────────────────────────
  Future<void> loadFavoritesFlights(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      final favCallSigns = await SavedFlightRepository().getFavoriteCallSigns();
      debugPrint('Favorite CallSigns: $favCallSigns');
      favoriteFlights(favCallSigns);
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await loadFavoritesFlights(context);
        },
      );
    }
  }

  void favoriteFlights(Set<String> favCallSigns) {
    _favCallSigns = favCallSigns;
    if (state.flights == null || state.flights!.isEmpty) {
      debugPrint('Flights not loaded yet, storing favCallSigns');
      return;
    }
    _favoritesToFlights();
  }

  void onFlightsLoaded(List<FlightModel> flights, BuildContext context) {
    if (!isClosed) {
      // SUMMARY = 1
      // TRACK_FLIGHT = 2
      // EMPTY_REQUEST = 3
      submitFlightCreditApi(
        flights.isEmpty == true ? 3 : 2,
        flights.isEmpty == true ? 1 : flights.length * 8,
        context,
      );
      emit(state.copyWith(flights: flights));
      if (_favCallSigns != null) {
        _favoritesToFlights();
      }
    }
  }

  Future<void> fetchAircraftDetailsFromFlightsList(
    List<String> uniqueTypes,
    List<String> callSignListTypes,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final flightsDetails = await AircraftListDataRepository()
            .getListOfAllPlanes(
              aircraftIds: uniqueTypes,
              callSignListTypes: callSignListTypes,
            );

        if (flightsDetails.data.isNotEmpty) {
          await loadFavoritesFlights(context);
          final enrichedFlights = await mergeFlightsWithDetails(
            state.flights ?? [],
            flightsDetails.data,
          );

          if (!isClosed) {
            emit(
              state.copyWith(
                flights: enrichedFlights,
                status: CommonApiStatus.success,
                isSuccess: true,
                isLoading: false,
              ),
            );
          }
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            isSuccess: false,
            isLoading: false,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await fetchAircraftDetailsFromFlightsList(
            uniqueTypes,
            callSignListTypes,
            context,
          );
        },
      );
    }
  }

  // ── FLIGHT FETCHING ────────────────────────────────────────────────────────

  Future<void> fetchFlightsByBounds({
    required LatLngBounds bounds,
    required BuildContext context,
    required LatLng currentCenterLatLong,
    required int flightLimit,
    required int radiusNm,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final boundsString =
            "${bounds.northeast.latitude},${bounds.southwest.latitude},"
            "${bounds.southwest.longitude},${bounds.northeast.longitude}";

        print("boundsString-=-=$boundsString");

        final hasAircraftFilter =
            state.selectedAircraftIcaos != null &&
            state.selectedAircraftIcaos!.isNotEmpty;
        final hasCategoryFilter =
            state.selectedFlightCategories != null &&
            state.selectedFlightCategories!.isNotEmpty;

        final localKey = await SharedPrefsHelper.getMapKeyValuesForApi();
        if (localKey.isEmpty) {
          final responseKeyValue = await FlightRepository()
              .getMapKeyValueFromServer();
          if (responseKeyValue.data.fr24 != null &&
              responseKeyValue.data.fr24 != "") {
            await SharedPrefsHelper.seMapKeyValuesFromServer(
              responseKeyValue.data.fr24 ?? "",
            );
          }
        }

        final flights = await FlightRepository().getFlights(
          flightLimit: flightLimit,
          context: context,
          bounds: boundsString,
          aircraft: hasAircraftFilter
              ? state.selectedAircraftIcaos!.join(',')
              : null,
          categories: hasCategoryFilter
              ? state.selectedFlightCategories!
                    .map((cat) => _getCategoryCode(cat))
                    .join(',')
              : null,
        );

        final airportList = await AircraftStationListRepository()
            .getListOfAllAircraftStationAccordingToLatLong(
              longitude: currentCenterLatLong.longitude.toString(),
              latitude: currentCenterLatLong.latitude.toString(),
            );

        debugPrint("Flights fetched: ${flights.length}");
        debugPrint("Airport list count: ${airportList.data.length}");

        onFlightsLoaded(flights, context);

        if (!isClosed) {
          emit(
            state.copyWith(
              flights: flights,
              airports: airportList.data,
              status: CommonApiStatus.success,
              isSuccess: true,
              isLoading: false,
            ),
          );
        }
      } catch (e, stack) {
        debugPrint("Error fetching flights: $e");
        debugPrint(stack.toString());
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
            isLoading: false,
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await fetchFlightsByBounds(
            bounds: bounds,
            context: context,
            currentCenterLatLong: currentCenterLatLong,
            flightLimit: flightLimit,
            radiusNm: radiusNm,
          );
        },
      );
    }
  }

  Future<void> fetchFlightDetails({
    required String flightId,
    required BuildContext context,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final now = DateTime.now().toUtc();
        final from = now.subtract(const Duration(hours: 24));
        final formattedFrom = formatUtc(from);
        final formattedTo = formatUtc(now);

        final response = await FlightRepository().getFlightDetails(
          flightId: flightId,
          fromDateTime: formattedFrom,
          toDateTime: formattedTo,
          context: context,
        );

        if (response != null) {
          final flightDetail = response['flightDetail'] as FlightAircraftDetail;
          // SUMMARY = 1
          // TRACK_FLIGHT = 2
          // EMPTY_REQUEST = 3
          submitFlightCreditApi(1, 2, context);
          print("flightDetail.isFavorite-=-=-=${flightDetail.isFavorite}");
          clearSelectedFlightDetail();
          emit(
            state.copyWith(
              selectedFlightDetail: flightDetail,
              status: CommonApiStatus.success,
              isLoading: false,
              isFavFlightByS: flightDetail.isFavorite,
            ),
          );
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching flight details: ${e.toString()}'),
          ),
        );
        emit(state.copyWith(isLoading: false));
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await fetchFlightDetails(flightId: flightId, context: context);
        },
      );
    }
  }

  Future<void> refreshFlightPosition({
    required String flightNumber,
    required BuildContext context,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final response = await FlightRepository().getFlightPositions(
          flightNumber,
        );

        // SUMMARY = 1
        // TRACK_FLIGHT = 2
        // EMPTY_REQUEST = 3
        submitFlightCreditApi(
          response!.flights.isNotEmpty ? 2 : 3,
          response!.flights.isNotEmpty ? 8 : 1,
          context,
        );

        if (response?.flights != null && response!.flights.isNotEmpty) {
          final updatedFlight = response.flights.first;
          emit(
            state.copyWith(
              selectedFlight: updatedFlight,
              isLoading: false,
              status: CommonApiStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              status: CommonApiStatus.failure,
              errorMessage: "No flight position data found.",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
        SessionCommonTokenError.handleUnauthorizedError(context, e);
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await _fetchAndUpdateFlight(flightNumber, context);
        },
      );
    }
  }

  Future<void> submitFlightCreditApi(
    int type,
    int credit,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final response = await FlightRepository().postFlightCreditApi(
          type: type,
          credit: credit,
        );
        final flightDetail = response.detail;

        print("isFromTrackingClass-=-=-=$isFromTrackingClass");
        final bool success = await CreditManager().tryUseCredit(
          amount: credit.toDouble(),
          isComeFromTabbar: false,
          onError: (String message) async {
            if (_trackingTimer != null) {
              _trackingTimer?.cancel();
              _trackingTimer = null;
            }

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
                  FlightRepository().openAddOnPacksBottomSheet(
                    context,
                    AddOnPackType.creditsOnly,
                  );
                },
              );

              // AlertHelperForSubsPopup.showSubscriptionEndAlert(
              //   isFromTrackingClass: isFromTrackingClass,
              //   context: context,
              //   title: "Subscription Required",
              //   message: message,
              //   navigateTo: SubscriptionPlanDetailScreen(
              //     isComeFromSignup: true,
              //   ),
              //   onGoToFirstTab: () {
              //     RootTabbarscreen.globalKey.currentState?.onItemTapped(0);
              //   },
              // );
            });
          },
        );

        if (success) {
          if (kDebugMode) {
            print(flightDetail);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await submitFlightCreditApi(type, credit, context);
        },
      );
    }
  }

  // ── TRACKING ───────────────────────────────────────────────────────────────

  Future<void> startTrackingFlight(
    String flightId,
    BuildContext context,
  ) async {
    if (_trackingTimer != null && _trackingTimer!.isActive) {
      return;
    }
    if (!isClosed) emit(state.copyWith(isTracking: true));

    _fetchAndUpdateFlight(flightId, context);

    _trackingTimer = Timer.periodic(Duration(seconds: 60), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      _fetchAndUpdateFlight(flightId, context);
    });
  }

  void stopTrackingFlight({String? flightNumber, String? destination}) {
    if (_trackingTimer != null) {
      _trackingTimer?.cancel();
      _trackingTimer = null;
    }

    emit(state.copyWith(isTracking: false, isFlightLanded: false));

    if (!kIsWeb && flightNumber != null) {
      LocalNotificationHelper.show(
        title: "Flight landed",
        body: destination != null
            ? "Flight Number $flightNumber has landed at $destination."
            : "Flight Number $flightNumber has landed.",
        screenName: "trackFlight",
      );
    }
  }

  // ── PRIVATE HELPERS ────────────────────────────────────────────────────────

  void _favoritesToFlights() {
    if (_favCallSigns == null || state.flights == null) return;

    final updatedFlights = state.flights!.map((flight) {
      final isFav = _favCallSigns!.contains(flight.callSign);

      if (isFav) {
        debugPrint('FAV MATCHED CallSign => ${flight.callSign}');
      }

      return flight.copyWith(isFavorite: isFav);
    }).toList();

    if (!isClosed) {
      emit(state.copyWith(flights: updatedFlights));
    }
  }

  Future<void> _fetchAndUpdateFlight(
    String flightNumber,
    BuildContext context,
  ) async {
    if (isClosed) return;
    if (await InternetConnection().hasInternetAccess) {
      try {
        final position = state.position;
        if (position == null) {
          Future.delayed(Duration(seconds: 5), () {
            if (!isClosed) {
              _fetchAndUpdateFlight(flightNumber, context);
            }
          });
          return;
        }

        final response = await FlightRepository().getFlightPositions(
          flightNumber,
        );
        final flights = response?.flights as List<FlightModel>;
        // SUMMARY = 1
        // TRACK_FLIGHT = 2
        // EMPTY_REQUEST = 3
        submitFlightCreditApi(
          flights.isNotEmpty ? 2 : 3,
          flights.isNotEmpty ? 8 : 1,
          context,
        );

        if (flights.isNotEmpty && !isClosed) {
          final updatedFlight = flights.first;
          emit(
            state.copyWith(
              selectedFlight: updatedFlight,
              status: CommonApiStatus.success,
              isLoading: false,
              flights: state.flights,
            ),
          );
        } else if (flights.isEmpty) {
          emit(
            state.copyWith(
              status: CommonApiStatus.success,
              isLoading: false,
              flights: state.flights,
              isFlightLanded: true,
            ),
          );
        }
      } catch (e) {
        if (isClosed) return;
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: 'Error tracking flight: ${e.toString()}',
            isLoading: false,
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await _fetchAndUpdateFlight(flightNumber, context);
        },
      );
    }
  }

  Future<List<FlightModel>> mergeFlightsWithDetails(
    List<FlightModel> flights,
    List<AircraftModel> aircraftDetails,
  ) async {
    return flights.map((flight) {
      final matchingDetail = aircraftDetails.firstWhere(
        (detail) =>
            detail.icaoTypeCode.toUpperCase() == flight.type.toUpperCase(),
        orElse: () => AircraftModel(
          aircraftId: '',
          aircraftModel: '',
          isFavorite: flight.isFavorite,
          icaoTypeCode: '',
          image: '',
        ),
      );
      return flight.copyWith(aircraftDetails: matchingDetail);
    }).toList();
  }

  String formatUtc(DateTime dateTime) {
    return "${dateTime.toUtc().toIso8601String().split('.').first}Z";
  }

  String _getCategoryCode(String label) {
    switch (label) {
      case "Passenger":
        return "P";
      case "Cargo":
        return "C";
      case "Business jets":
        return "J";
      case "General aviation":
        return "T";
      case "Helicopters":
        return "H";
      case "Military and government":
        return "M";
      default:
        return "";
    }
  }
}
