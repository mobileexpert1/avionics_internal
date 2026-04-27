import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_Map_State.dart';

class FilterMapMainCubit extends Cubit<FilterMapState> {
  FilterMapMainCubit() : super(FilterMapState.initial());

  void updateFlights(int value) {
    emit(state.copyWith(numberOfFlights: value));
  }

  void updateRadius(int value) {
    emit(state.copyWith(searchRadius: value));
  }

  void setInitialMapType(CustomMapType type) {
    emit(state.copyWith(mapType: type));
  }

  void toggleCategoriesSection() {
    emit(state.copyWith(showCategories: !state.showCategories));
  }

  void toggleSearchInRadiusSection() {
    emit(state.copyWith(showSearchInRadius: !state.showSearchInRadius));
  }

  void togglesNumberOfFlightsSection() {
    emit(state.copyWith(showNumberOfFlights: !state.showNumberOfFlights));
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
        emit(state.copyWith(mapType: CustomMapType.standard));
        break;
      case 'Satellite':
        emit(state.copyWith(mapType: CustomMapType.satellite));
        break;
      case 'Hybrid':
        emit(state.copyWith(mapType: CustomMapType.hybrid));
        break;
      case 'FIR Borders':
        emit(state.copyWith(mapType: CustomMapType.polygon));
        break;
    }
  }

  String getMapTypeName() {
    switch (state.mapType) {
      case CustomMapType.standard:
        return "Standard";
      case CustomMapType.satellite:
        return "Satellite";
      case CustomMapType.hybrid:
        return "Hybrid";
      case CustomMapType.polygon:
        return "FIR Borders";
    }
  }

  void toggleAircraftLabels() {
    emit(state.copyWith(showAircraftLabels: !state.showAircraftLabels));
  }

  void resetFilter() {
    emit(
      state.copyWith(
        selectedCategories: [],
        showCategories: true,
        showMap: true,
        showAircraftLabels: true,
        mapType: CustomMapType.standard, // reset to default
      ),
    );
  }

  void setInitialCategories(List<String> categories) {
    emit(state.copyWith(selectedCategories: List.from(categories)));
  }
}
