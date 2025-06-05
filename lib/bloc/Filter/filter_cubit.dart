// lib/bloc/filter/filter_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_model.dart';
import 'filter_state.dart';

/// Cubit responsible for managing the state of the Filter screen.
class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState(filterCategories: []));

  /// Loads a list of mock filter data.
  void loadFilters() {
    emit(state.copyWith(isLoading: true));

    // Mock data based on the image, all categories initially expanded.
    final mockData = [
      FilterCategory(
        id: 'general',
        name: 'GENERAL',
        options: [
          FilterOption(id: 'icao_type_code', name: 'ICAO Type Code'),
          FilterOption(
            id: 'wake_turbulence_category',
            name: 'Wake Turbulence Category (L, M, H, Super)',
          ),
          FilterOption(
            id: 'avionics_system_name',
            name: 'Avionics System Name / Family',
          ),
          FilterOption(
            id: 'no_of_engines',
            name: 'No of Engines',
            isSelected: false,
          ),
          FilterOption(
            id: 'engine_manufacturer_model',
            name: 'Engine Manufacturer and Model',
            isSelected: false,
          ),
          FilterOption(
            id: 'engine_type',
            name: 'Engine Type',
            isSelected: false,
          ),
          FilterOption(
            id: 'engine_thrust',
            name: 'Engine Thrust (per engine, in kN or lbf)',
            isSelected: false,
          ),
          FilterOption(
            id: 'fuel_consumption',
            name: 'Fuel Consumption (kg/hr at cruise)',
            isSelected: false,
          ),
        ],
        isExpanded: true, // Initially expanded
      ),
      FilterCategory(
        id: 'technical_data',
        name: 'TECHNICAL DATA',
        options: [
          FilterOption(id: 'wingspan', name: 'Wingspan (m and ft)'),
          FilterOption(id: 'length', name: 'Length'),
          FilterOption(id: 'height', name: 'Height'),
          FilterOption(id: 'wingtip', name: 'Wingtip'),
          FilterOption(id: 'max_payload', name: 'Max Payload'),
          FilterOption(id: 'mtow', name: 'MTOW'),
        ],
        isExpanded: true, // Initially expanded
      ),
      FilterCategory(
        id: 'operational_data',
        name: 'OPERATIONAL DATA',
        options: [
          FilterOption(id: 'tco', name: 'TCO'),
          FilterOption(id: 'takeoff_speed', name: 'Takeoff Speed (kts)'),
          FilterOption(id: 'roc_avg', name: 'RoC Avg'),
          FilterOption(id: 'max_roc', name: 'Max RoC'),
          FilterOption(
            id: 'service_ceiling',
            name: 'Service Ceiling (ft / FL)',
            isSelected: true,
          ),
          FilterOption(
            id: 'max_certified_altitude',
            name: 'Max Certified Altitude (ft / FL)',
          ),
          FilterOption(id: 'cruise_speed', name: 'Cruise Speed (kts / Mach)'),
          FilterOption(
            id: 'maximum_speed',
            name: 'Maximum Speed (VMO/MMO in kts/Mach)',
          ),
          FilterOption(id: 'ferry_range', name: 'Ferry Range (if applicable)'),
          FilterOption(id: 'range', name: 'Range'),
          FilterOption(
            id: 'initial_rate_of_descent',
            name: 'Initial Rate of Descent (fpm)',
          ),
          FilterOption(
            id: 'average_rate_of_descent',
            name: '(Average) Rate of Descent (fpm)',
          ),
          FilterOption(
            id: 'minimum_clean_speed',
            name: 'Minimum Clean Speed (kts)',
          ),
          FilterOption(id: 'approach_speed', name: 'Approach Speed (kts)'),
          FilterOption(
            id: 'approach_category',
            name: 'Approach Category (CAT A/B/C/D)',
          ),
          FilterOption(id: 'landing_speed', name: 'Landing Speed (kts)'),
          FilterOption(id: 'landing_distance', name: 'Landing Distance (m)'),
          FilterOption(
            id: 'runway_length_required',
            name: 'Runway Length Required (m)',
          ),
          FilterOption(id: 'stall_speed', name: 'Stall Speed (if available)'),
        ],
        isExpanded: true, // Initially expanded
      ),
    ];

    emit(
      state.copyWith(
        filterCategories: mockData,
        isLoading: false,
        isApplied: false,
      ),
    );
  }

  /// Toggles the selection state of a specific filter option.
  void toggleFilterOption(String categoryId, String optionId) {
    final updatedCategories = state.filterCategories.map((category) {
      if (category.id == categoryId) {
        final updatedOptions = category.options.map((option) {
          if (option.id == optionId) {
            return option.copyWith(isSelected: !option.isSelected);
          }
          return option;
        }).toList();
        return category.copyWith(options: updatedOptions);
      }
      return category;
    }).toList();
    emit(state.copyWith(filterCategories: updatedCategories, isApplied: false));
  }

  /// Toggles the expanded state of a filter category.
  void toggleCategoryExpansion(String categoryId) {
    final updatedCategories = state.filterCategories.map((category) {
      if (category.id == categoryId) {
        return category.copyWith(isExpanded: !category.isExpanded);
      }
      return category;
    }).toList();
    emit(state.copyWith(filterCategories: updatedCategories));
  }

  /// Resets all filter options to unselected.
  void resetFilters() {
    final resetCategories = state.filterCategories.map((category) {
      final resetOptions = category.options.map((option) {
        return option.copyWith(isSelected: false);
      }).toList();
      return category.copyWith(
        options: resetOptions,
        isExpanded: true,
      ); // Reset expansion to true
    }).toList();
    emit(state.copyWith(filterCategories: resetCategories, isApplied: false));
  }

  /// Simulates applying the filters.
  void applyFilters() {
    // In a real application, you would pass the selected filters to a data layer
    // For this example, we just update the isApplied flag
    emit(state.copyWith(isApplied: true));
    // You might want to pop the screen or trigger a data refresh here
  }
}

