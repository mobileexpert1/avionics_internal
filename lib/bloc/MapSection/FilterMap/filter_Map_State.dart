// filter_Map_State.dart
import 'package:equatable/equatable.dart';

enum MapType { standard, satellite, hybrid }

class FilterMapState extends Equatable {
  final List<String> selectedCategories;
  final bool showCategories;
  final bool showMap;
  final bool showAircraftLabels;
  final MapType mapType;
  final List<String> categories;

  const FilterMapState({
    required this.selectedCategories,
    required this.showCategories,
    required this.showMap,
    required this.showAircraftLabels,
    required this.mapType,
    required this.categories,
  });

  factory FilterMapState.initial() {
    return const FilterMapState(
      selectedCategories: [],
      showCategories: true,
      showMap: true,
      showAircraftLabels: true,
      mapType: MapType.standard,
      categories: ["Commercial", "Cargo", "Business", "Other"],
    );
  }

  FilterMapState copyWith({
    List<String>? selectedCategories,
    bool? showCategories,
    bool? showMap,
    bool? showAircraftLabels,
    MapType? mapType,
    List<String>? categories,
  }) {
    return FilterMapState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      showCategories: showCategories ?? this.showCategories,
      showMap: showMap ?? this.showMap,
      showAircraftLabels: showAircraftLabels ?? this.showAircraftLabels,
      mapType: mapType ?? this.mapType,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategories,
    showCategories,
    showMap,
    showAircraftLabels,
    mapType,
    categories,
  ];
}

