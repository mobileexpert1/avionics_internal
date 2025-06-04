import 'package:flutter_bloc/flutter_bloc.dart';
import 'AircraftComparisonState.dart';
import 'AircraftModel.dart';

class AircraftComparisonCubit extends Cubit<AircraftComparisonState> {
  List<AircraftModel> _models = [];
  Set<String> _selectedBadges = {};
  List<AircraftModel> _filteredModels = [];

  AircraftComparisonCubit({required List allModels}) : super(AircraftComparisonModelsUpdated([], {}));

  void loadAllModels(List<AircraftModel> models) {
    _models = models;
    _filteredModels = List.from(_models);
    emit(AircraftComparisonModelsUpdated(_filteredModels, _selectedBadges));
  }

  void filterModels(String query) {
    if (query.isEmpty) {
      _filteredModels = List.from(_models);
    } else {
      _filteredModels = _models
          .where((model) =>
          model.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(AircraftComparisonModelsUpdated(_filteredModels, _selectedBadges));
  }

  void toggleSelection(String badge) {
    if (_selectedBadges.contains(badge)) {
      _selectedBadges.remove(badge);
    } else {
      if (_selectedBadges.length >= 2) return; // limit selection to 2
      _selectedBadges.add(badge);
    }
    emit(AircraftComparisonModelsUpdated(_filteredModels, _selectedBadges));
  }
}
