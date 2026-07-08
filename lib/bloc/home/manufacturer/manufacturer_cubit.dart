import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'manufacturer_repository.dart';
import 'manufacturer_state.dart';

class ManufacturerCubit extends Cubit<ManufacturerState> {
  final ManufacturerRepository repository;

  ManufacturerCubit({ManufacturerRepository? repo})
    : repository = repo ?? ManufacturerRepository(),
      super(ManufacturerState(manufacturers: []));

  bool isFetching = false;

  Future<void> loadListOfManufacturers({
    String? query,
    required BuildContext context,
    int page = 1,
    bool isLoadMore = false,
  }) async {
    if (isFetching) return;
    isFetching = true;
    if (await InternetConnection().hasInternetAccess) {
      if (isLoadMore && state.currentPage >= state.totalPages) {
        return;
      }

      if (isLoadMore) {
        emit(state.copyWith(isFetchingMore: true));
      } else {
        emit(state.copyWith(isLoading: true, currentPage: 1, totalPages: 1));
      }

      final isHelicopter = state.selectedManufacturerCategories.contains(
        "HELICOPTERS (ROTOR CRAFTS)",
      );

      final isAirplane = state.selectedManufacturerCategories.contains(
        "AIRPLANES",
      );

      try {
        final paginated = await repository.getListOfManufacturers(
          query: query,
          page: page,
          helicopter: isHelicopter,
          airplane: isAirplane,
        );

        final merged = isLoadMore
            ? [...state.manufacturers, ...paginated.results]
            : paginated.results;

        final seen = <dynamic>{};
        final updatedList = merged.where((m) => seen.add(m.id)).toList();

        updatedList.sort(
          (a, b) => a.companyName.toLowerCase().compareTo(
            b.companyName.toLowerCase(),
          ),
        );

        emit(
          state.copyWith(
            manufacturers: updatedList,
            currentPage: paginated.currentPage,
            totalPages: paginated.totalPages,
            hasNextPage: paginated.hasNext,
            isLoading: false,
            isFetchingMore: false,
          ),
        );
        isFetching = false;
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(state.copyWith(isLoading: false, isFetchingMore: false));
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => loadListOfManufacturers(query: query, context: context),
      );
    }
  }

  Future<void> getParticularAirbusDetail({
    required String query,
    required BuildContext context,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(
        state.copyWith(
          isLoading: true,
          status: CommonApiStatus.initial,
          errorMessage: null,
          apiError: null,
          isSuccess: false,
          manufacturerDetail: null,
        ),
      );

      try {
        final response = await repository.getParticularAirbusDetail(
          query: query,
        );

        print(response);

        emit(
          state.copyWith(
            manufacturerDetail: response,
            isLoading: false,
            status: CommonApiStatus.success,
            isSuccess: true,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            manufacturerDetail: null,
            isLoading: false,
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
            isSuccess: false,
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () =>
            getParticularAirbusDetail(query: query, context: context),
      );
    }
  }

  Future<void> toggleCategory(String category, BuildContext context) async {
    final updated = List<String>.from(state.selectedManufacturerCategories);

    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }

    emit(state.copyWith(selectedManufacturerCategories: updated));
    await loadListOfManufacturers(context: context, page: 1);
  }

  void toggleCategoriesSection() {
    emit(state.copyWith(showCategories: !state.showCategories));
  }
}
