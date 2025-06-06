import 'package:flutter_bloc/flutter_bloc.dart';
import 'AircraftComparisonState.dart';
import 'AircraftModel.dart';

class AircraftComparisonCubit extends Cubit<AircraftComparisonState> {
  List<AircraftModel> allModels = [
    AircraftModel(name: 'A-737-800', id: 'A737', manufacturer: 'Boeing'),
    AircraftModel(name: 'A-321', id: 'A321', manufacturer: 'Airbus'),
    AircraftModel(name: 'A-322', id: 'A322', manufacturer: 'Airbus'),
    AircraftModel(name: 'A-757-200', id: 'A757', manufacturer: 'Airbus'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
    AircraftModel(name: 'DHC-8-400', id: 'DH8D', manufacturer: 'DH Canada'),
  ];

  Set<String> selectedBadges = {};

  AircraftComparisonCubit() : super(AircraftComparisonInitial()) {
    emit(AircraftComparisonModelsUpdated(
      models: allModels,
      selectedModelBadges: selectedBadges,
    ));
  }

  void toggleSelection(String badge) {
    if (selectedBadges.contains(badge)) {
      selectedBadges.remove(badge);
    } else {
      if (selectedBadges.length >= 2) return;
      selectedBadges.add(badge);
    }

    emit(AircraftComparisonModelsUpdated(
      models: allModels,
      selectedModelBadges: selectedBadges,
    ));
  }

  void filterModels(String query) {
    final filtered = allModels
        .where((model) =>
    model.name.toLowerCase().contains(query.toLowerCase()) ||
        model.id.toLowerCase().contains(query.toLowerCase()) ||
        model.manufacturer.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(AircraftComparisonModelsUpdated(
      models: filtered,
      selectedModelBadges: selectedBadges,
    ));
  }
}
