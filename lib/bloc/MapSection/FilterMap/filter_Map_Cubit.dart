import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'filter_Map_State.dart';

class FilterMapMainCubit extends Cubit<FilterMapState> {
  FilterMapMainCubit() : super(FilterMapState.initial());

  void setInitialMapType(MapType type) {
    emit(state.copyWith(mapType: type));
  }

  void toggleCategoriesSection() {
    emit(state.copyWith(showCategories: !state.showCategories));
  }

  void toggleMapSection() {
    emit(state.copyWith(showMap: !state.showMap));
  }

  void toggleCategory(String category) {
    final updated = List<String>.from(state.selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    emit(state.copyWith(selectedCategories: updated));
  }

  void changeMapTypeByName(String val) {
    switch (val) {
      case 'Standard':
        emit(state.copyWith(mapType: MapType.normal));
        break;
      case 'Satellite':
        emit(state.copyWith(mapType: MapType.satellite));
        break;
      case 'Hybrid':
        emit(state.copyWith(mapType: MapType.hybrid));
        break;
    }
  }

  String getMapTypeName() {
    switch (state.mapType) {
      case MapType.normal:
        return "Standard";
      case MapType.satellite:
        return "Satellite";
      case MapType.hybrid:
        return "Hybrid";
      case MapType.none:
        return "Standard";
      case MapType.terrain:
        return "Standard";
    }
  }

  void toggleAircraftLabels() {
    emit(state.copyWith(showAircraftLabels: !state.showAircraftLabels));
  }

  // Reset all filters
  void resetFilter() {
    emit(
      state.copyWith(
        selectedCategories: [],
        showCategories: true,
        showMap: true,
        showAircraftLabels: true,
        mapType: MapType.normal,
      ),
    );
  }

  void setInitialCategories(List<String> categories) {
    emit(state.copyWith(selectedCategories: List.from(categories)));
  }
}
