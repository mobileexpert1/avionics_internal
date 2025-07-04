import 'package:flutter_bloc/flutter_bloc.dart';
import 'AircraftComparisonState.dart';
import 'AircraftModel.dart';

class AircraftComparisonCubit extends Cubit<AircraftComparisonState> {
  List<AircraftModel> allModels = [
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

  Set<String> selectedBadges = {};

  AircraftComparisonCubit() : super(AircraftComparisonInitial()) {
    emit(
      AircraftComparisonModelsUpdated(
        models: allModels,
        selectedModelBadges: selectedBadges,
      ),
    );
  }

  bool toggleSelection(String badge) {
    if (selectedBadges.contains(badge)) {
      selectedBadges.remove(badge);
    } else {
      if (selectedBadges.length >= 2) return false;
      selectedBadges.add(badge);
    }

    emit(
      AircraftComparisonModelsUpdated(
        models: allModels,
        selectedModelBadges: selectedBadges,
      ),
    );

    return selectedBadges.length == 2;
  }

  void filterModels(String query) {
    final filtered = allModels
        .where(
          (model) =>
              model.name.toLowerCase().contains(query.toLowerCase()) ||
              model.id.toLowerCase().contains(query.toLowerCase()) ||
              model.manufacturer.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    emit(
      AircraftComparisonModelsUpdated(
        models: filtered,
        selectedModelBadges: selectedBadges,
      ),
    );
  }
}
