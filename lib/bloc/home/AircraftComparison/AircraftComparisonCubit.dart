import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'AircraftComparisonRepository.dart';
import 'AircraftComparisonState.dart';

class AircraftComparisonCubit extends Cubit<AircraftState> {
  AircraftComparisonCubit() : super(const AircraftState(aircraftList: []));

  bool _isRequestInProgress = false;

  Future<void> loadAircraftModels({
    required BuildContext context,
    String? query,
    int? page,
    bool isLoadMore = false,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      if (_isRequestInProgress) return;

      _isRequestInProgress = true;

      final nextPage = page ?? (isLoadMore ? state.currentPage + 1 : 1);

      debugPrint('Loading Page => $nextPage  isLoadMore => $isLoadMore');

      if (isLoadMore) {
        emit(state.copyWith(isFetchingMore: true));
      } else {
        emit(
          state.copyWith(
            isLoading: true,
            currentPage: 1,
            aircraftList: query == null || query.isEmpty
                ? []
                : state.aircraftList,
          ),
        );
      }

      try {
        final paginated = await AircraftRepository().getCompareList(
          page: nextPage,
          query: query,
        );

        final updatedList = isLoadMore
            ? [...state.aircraftList, ...paginated.results]
            : paginated.results;

        final uniqueMap = {for (final item in updatedList) item.id: item};

        final uniqueList = uniqueMap.values.toList();

        uniqueList.sort(
          (a, b) => a.aircraftModel.toLowerCase().compareTo(
            b.aircraftModel.toLowerCase(),
          ),
        );

        _isRequestInProgress = false;
        emit(
          state.copyWith(
            aircraftList: uniqueList,
            currentPage: paginated.currentPage,
            hasNextPage: paginated.hasNext,
            isLoading: false,
            isFetchingMore: false,
          ),
        );
      } catch (e) {
        _isRequestInProgress = false;

        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(state.copyWith(isLoading: false, isFetchingMore: false));
      }
    } else {
      _isRequestInProgress = false;

      NoInternetDialog.show(
        context,
        onRetry: () async {
          await loadAircraftModels(
            query: query,
            page: page,
            isLoadMore: isLoadMore,
            context: context,
          );
        },
      );
    }
  }
}
