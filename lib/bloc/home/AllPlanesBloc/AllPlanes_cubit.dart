import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_model.dart';
import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_reposistory.dart';
import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';

class AllPlanesCubit extends Cubit<AllPlanesState> {
  AllPlanesCubit() : super(const AllPlanesState(listoFAircraftModels: []));

  Future<void> loadListOAllAirbusModels({
    String? query,
    required String selectedAirbusId,
    required BuildContext context,
    int page = 1,
    bool isLoadMore = false,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      if (query == "" || query == null) {
        if (isLoadMore) {
          emit(state.copyWith(isFetchingMore: true));
        } else {
          emit(state.copyWith(isLoading: true, currentPage: 1));
        }
      }

      try {
        final paginated = await AllPlanesReposistory().getListOfAllPlanes(
          query: query,
          page: page,
          selectedAirbusId: selectedAirbusId,
        );

        final updatedList = isLoadMore
            ? [...state.listoFAircraftModels, ...paginated.results]
            : paginated.results;

        updatedList.sort(
          (a, b) => a.model.toLowerCase().compareTo(b.model.toLowerCase()),
        );

        emit(
          state.copyWith(
            listoFAircraftModels: updatedList,
            currentPage: paginated.currentPage,
            hasNextPage: paginated.hasNext,
            isLoading: false,
            isFetchingMore: false,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(state.copyWith(isLoading: false, isFetchingMore: false));
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await loadListOAllAirbusModels(
            query: query,
            selectedAirbusId: selectedAirbusId,
            context: context,
            page: page,
            isLoadMore: isLoadMore,
          );
        },
      );
    }
  }

  Future<void> planFavOrUnfav(String aircraftId, BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(status: CommonApiStatus.submitting));
      try {
        await AllPlanesReposistory().setFavOrUnfavPlanFromList(
          aircraftId: aircraftId,
        );
        emit(state.copyWith(status: CommonApiStatus.success));
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await planFavOrUnfav(aircraftId, context);
        },
      );
    }
  }

  Future<void> planFavOrUnfav1(
    String aircraftId,
    String callSign,
    String flightId,
    String flightNumber,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      updateFlightFavoriteByCallSign(callSign);
      emit(state.copyWith(status: CommonApiStatus.submitting));

      try {
        await AllPlanesReposistory().setFavOrUnfavPlanFromList1(
          aircraftId: aircraftId,
          callSign: callSign,
          flightId: flightId,
          flightNumber: flightNumber,
        );
        updateFlightFavoriteByCallSign(callSign);
        emit(state.copyWith(status: CommonApiStatus.success));
      } catch (e) {
        updateFlightFavoriteByCallSign(callSign);
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await planFavOrUnfav1(
            aircraftId,
            callSign,
            flightId,
            flightNumber,
            context,
          );
        },
      );
    }
  }

  void toggleFavorite(String id, BuildContext context, bool isSaved) {
    final updatedList = state.listoFAircraftModels.map((model) {
      if (model.id == id) {
        return AircraftListModel(
          id: model.id,
          model: model.model,
          isFavorite: !model.isFavorite,
          image: model.image,
          ICAOCode: model.ICAOCode,
          isSaved: !isSaved,
        );
      }
      return model;
    }).toList();

    planFavOrUnfav(id, context);
    emit(state.copyWith(listoFAircraftModels: updatedList));
  }

  void updateFlightFavoriteByCallSign(String callSign) {
    final updatedFlights = state.flights?.map((flight) {
      if (flight.callSign == callSign) {
        return flight.copyWith(
          aircraftDetails: flight.aircraftDetails?.copyWith(
            isFavorite: !(flight.aircraftDetails?.isFavorite ?? false),
          ),
        );
      }
      return flight;
    }).toList();

    emit(state.copyWith(flights: updatedFlights));
  }
}
