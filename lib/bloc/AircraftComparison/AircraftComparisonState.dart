import 'AircraftModel.dart';

abstract class AircraftComparisonState {}

class AircraftComparisonInitial extends AircraftComparisonState {}

class AircraftComparisonModelsUpdated extends AircraftComparisonState {
  final List<AircraftModel> models;
  final Set<String> selectedModelBadges;

  AircraftComparisonModelsUpdated(this.models, this.selectedModelBadges);
}

class AircraftComparisonSelectionUpdated extends AircraftComparisonState {
  final List<AircraftModel> selectedModels;

  AircraftComparisonSelectionUpdated(this.selectedModels);
}
