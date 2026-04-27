import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum CustomMapType { standard, satellite, hybrid, polygon }

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
        return MapType.normal;
    }
  }
}

class FilterMapState extends Equatable {
  final List<String> selectedCategories;
  final bool showNumberOfFlights;
  final bool showSearchInRadius;

  final bool showCategories;
  final bool showMap;
  final bool showAircraftLabels;
  final CustomMapType mapType;
  final List<String> categories;
  final int numberOfFlights;
  final int searchRadius;

  const FilterMapState({
    required this.showNumberOfFlights,
    required this.showSearchInRadius,
    required this.selectedCategories,
    required this.showCategories,
    required this.showMap,
    required this.showAircraftLabels,
    required this.mapType,
    required this.categories,
    required this.numberOfFlights,
    required this.searchRadius,
  });

  factory FilterMapState.initial() {
    return FilterMapState(
      showNumberOfFlights: false,
      showSearchInRadius: false,
      numberOfFlights: 1,
      searchRadius: 1,
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
    bool? showNumberOfFlights,
    bool? showSearchInRadius,
    int? numberOfFlights,
    int? searchRadius,

    List<String>? selectedCategories,
    bool? showCategories,
    bool? showMap,
    bool? showAircraftLabels,
    CustomMapType? mapType,
    List<String>? categories,
  }) {
    return FilterMapState(
      showNumberOfFlights: showNumberOfFlights ?? this.showNumberOfFlights,
      showSearchInRadius: showSearchInRadius ?? this.showSearchInRadius,

      numberOfFlights: numberOfFlights ?? this.numberOfFlights,
      searchRadius: searchRadius ?? this.searchRadius,
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
    showNumberOfFlights,
    showSearchInRadius,

    numberOfFlights,

    searchRadius,

    selectedCategories,

    showCategories,

    showMap,

    showAircraftLabels,

    mapType,

    categories,
  ];
}
