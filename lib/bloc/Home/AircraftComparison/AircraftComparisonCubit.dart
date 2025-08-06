import 'package:flutter_bloc/flutter_bloc.dart';
import 'AircraftComparisonState.dart';
import 'AircraftModel.dart';

class AircraftComparisonCubit extends Cubit<AircraftComparisonState> {
  final List<AircraftModel> allModels = [
    AircraftModel(name: 'A-737-800', id: 'A731', manufacturer: 'Boeing'),
    AircraftModel(name: 'A-321', id: 'A322', manufacturer: 'Airbus'),
    AircraftModel(name: 'A-322', id: 'A323', manufacturer: 'Airbus'),
    AircraftModel(name: 'A-757-200', id: 'A754', manufacturer: 'Airbus'),
    AircraftModel(name: 'DHC-8-400', id: 'DH85', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH86', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH87', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH88', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH89', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH11', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH12', manufacturer: 'DH Canada'),
  ];

  AircraftComparisonCubit() : super(AircraftComparisonInitial());

  void loadModels({String? excludeName1, String? excludeName2}) {
    final filtered = allModels.where((model) {
      return model.name != excludeName1 && model.name != excludeName2;
    }).toList();

    emit(
      AircraftComparisonModelsUpdated(
        models: filtered,
        selectedModelBadges: {}, // Can be ignored in this context
      ),
    );
  }

  void filterModels(String query) {
    final filtered = allModels.where((model) {
      return model.name.toLowerCase().contains(query.toLowerCase()) ||
          model.id.toLowerCase().contains(query.toLowerCase()) ||
          model.manufacturer.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(
      AircraftComparisonModelsUpdated(
        models: filtered,
        selectedModelBadges: {},
      ),
    );
  }
}


// import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftRepository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
// import 'AircraftComparisonState.dart';
//
//
// class AircraftComparisonCubit extends Cubit<AircraftState> {
//   AircraftComparisonCubit(): super(const AircraftState(aircraftList: []));
//
//   Future<void> loadAircraftModels({
//     required BuildContext context,
//     String? query,
//     int page = 1,
//     bool isLoadMore = false,
//   }) async {
//     if (isLoadMore) {
//       emit(state.copyWith(isFetchingMore: true));
//     } else {
//       emit(state.copyWith(isLoading: true, currentPage: 1));
//     }
//
//     try {
//       final paginated = await AircraftRepository().getCompareList(
//         page: page,
//         query: query,
//       );
//
//       final updatedList = isLoadMore
//           ? [...state.aircraftList, ...paginated.results]
//           : paginated.results;
//
//       updatedList.sort(
//             (a, b) => a.aircraftModel.toLowerCase().compareTo(b.aircraftModel.toLowerCase()),
//       );
//
//       emit(
//         state.copyWith(
//           aircraftList: updatedList,
//           currentPage: paginated.currentPage,
//           hasNextPage: paginated.hasNext,
//           isLoading: false,
//           isFetchingMore: false,
//         ),
//       );
//     } catch (e) {
//       SessionCommonTokenError.handleUnauthorizedError(context, e);
//       emit(state.copyWith(isLoading: false, isFetchingMore: false));
//     }
//   }
// }

