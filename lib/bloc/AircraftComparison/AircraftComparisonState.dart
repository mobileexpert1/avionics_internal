import 'AircraftModel.dart';

abstract class AircraftComparisonState {}

class AircraftComparisonInitial extends AircraftComparisonState {}

class AircraftComparisonModelsUpdated extends AircraftComparisonState {
  final List<AircraftModel> models;
  final Set<String> selectedModelBadges;

  AircraftComparisonModelsUpdated({
    required this.models,
    required this.selectedModelBadges,
  });
}






