import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum CustomMapType {
  standard,
  satellite,
  hybrid,
  polygon, // new type
}

extension CustomMapTypeExtension on CustomMapType {
  MapType toGoogleMapType() {
    switch (this) {
      case CustomMapType.standard:
        return MapType.normal;
      case CustomMapType.satellite:
        return MapType.satellite;
      case CustomMapType.hybrid:
        return MapType.hybrid;
      case CustomMapType.polygon:
        return MapType
            .normal;
    }
  }
}

class FilterMapState extends Equatable {
  final List<String> selectedCategories;
  final bool showCategories;
  final bool showMap;
  final bool showAircraftLabels;
  final CustomMapType mapType;
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
    return FilterMapState(
      selectedCategories: const [],
      showCategories: true,
      showMap: true,
      showAircraftLabels: true,
      mapType: CustomMapType.standard,
      // default
      categories: const ["Commercial", "Cargo", "Business", "Other"],
    );
  }

  FilterMapState copyWith({
    List<String>? selectedCategories,
    bool? showCategories,
    bool? showMap,
    bool? showAircraftLabels,
    CustomMapType? mapType,
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
