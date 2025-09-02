import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_Map_State.dart';

class FilterMapCubit extends Cubit<FilterMapState> {
  FilterMapCubit() : super(FilterMapState.initial());

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
        emit(state.copyWith(mapType: MapType.standard));
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
      case MapType.standard:
        return "Standard";
      case MapType.satellite:
        return "Satellite";
      case MapType.hybrid:
        return "Hybrid";
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
        showAircraftLabels: false,
        mapType: MapType.standard,
      ),
    );
  }
}

