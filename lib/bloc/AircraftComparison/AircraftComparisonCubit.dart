import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AircraftComparisonState.dart';
import 'AircraftModel.dart';



class AircraftComparisonCubit extends Cubit<AircraftComparisonState> {
  AircraftComparisonCubit() : super(AircraftComparisonInitial());

  // List of all available aircraft models
  final List<AircraftModel> allModels = [
    AircraftModel(name: 'B-737-800', manufacturer: 'Boeing', id: 'B737'),
    AircraftModel(name: 'A-321', manufacturer: 'Airbus', id: 'A321'),
    AircraftModel(name: 'A-322', manufacturer: 'Airbus', id: 'A322'),
    AircraftModel(name: 'B-757-200', manufacturer: 'Airbus', id: 'B757'),
    AircraftModel(name: 'B-737-800', manufacturer: 'Boeing', id: 'B737'),
    AircraftModel(name: 'B-737-800', manufacturer: 'Boeing', id: 'B737'),
    AircraftModel(name: 'B-737-800', manufacturer: 'Boeing', id: 'B737'),
    AircraftModel(name: 'DHC-8-400', manufacturer: 'DH Canada', id: 'DHC8'),
    AircraftModel(name: 'DHC-8-400', manufacturer: 'DH Canada', id: 'DHC8'),
  ];

  // List of selected models for comparison
  List<AircraftModel> selectedModels = [];

  // Method to filter models based on search query
  void filterModels(String query) {
    if (query.isEmpty) {
      emit(AircraftComparisonModelsUpdated(allModels));
    } else {
      final filtered = allModels.where((model) {
        return model.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(AircraftComparisonModelsUpdated(filtered));
    }
  }

  // Method to toggle selection of an aircraft model for comparison
  void toggleSelection(AircraftModel model) {
    if (selectedModels.contains(model)) {
      selectedModels.remove(model);
    } else {
      if (selectedModels.length < 3) { // Limit to 3 models for comparison
        selectedModels.add(model);
      }
    }
    emit(AircraftComparisonSelectionUpdated(selectedModels));
  }
}
