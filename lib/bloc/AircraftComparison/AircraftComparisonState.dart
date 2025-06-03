import 'package:flutter/cupertino.dart';
import 'AircraftModel.dart';

@immutable
abstract class AircraftComparisonState {}

class AircraftComparisonInitial extends AircraftComparisonState {}

class AircraftComparisonModelsUpdated extends AircraftComparisonState {
  final List<AircraftModel> models;

  AircraftComparisonModelsUpdated(this.models);
}

class AircraftComparisonSelectionUpdated extends AircraftComparisonState {
  final List<AircraftModel> selectedModels;

  AircraftComparisonSelectionUpdated(this.selectedModels);
}
