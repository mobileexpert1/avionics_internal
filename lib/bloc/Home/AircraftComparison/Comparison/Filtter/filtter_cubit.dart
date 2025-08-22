// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'filtter_model.dart';
// import 'filtter_state.dart';
//
// class ComparisonFilterCubit1 extends Cubit<FilterState1> {
//   ComparisonFilterCubit1() : super(const FilterState1(filterCategories: []));
//
//   void loadFiltersFromComparison1() {
//     final generalOptions = [
//       FilterOption1(id: 'icao_type_code', name: 'ICAO Type Code', isSelected: true),
//       FilterOption1(id: 'wake_turbulence', name: 'Wake Turbulence', isSelected: true),
//       FilterOption1(id: 'avionics', name: 'Avionics', isSelected: true),
//       FilterOption1(id: 'no_of_engines', name: 'Number of Engines', isSelected: true),
//       FilterOption1(id: 'engine_model', name: 'Engine Model', isSelected: true),
//       FilterOption1(id: 'engine_type', name: 'Engine Type', isSelected: true),
//     ];
//
//     final technicalOptions = [
//       FilterOption1(id: 'wingspan_m', name: 'Wingspan (m)', isSelected: true),
//       // FilterOption1(id: 'wingspan_ft', name: 'Wingspan (ft)', isSelected: true),
//       FilterOption1(id: 'length_m', name: 'Length (m)', isSelected: true),
//       // FilterOption1(id: 'length_ft', name: 'Length (ft)', isSelected: true),
//       FilterOption1(id: 'height_m', name: 'Height (m)', isSelected: true),
//       FilterOption1(id: 'max_Payload', name: 'Max Payload (kg)', isSelected: true),
//       FilterOption1(id: 'mtow', name: 'MTOW (kg)', isSelected: true),
//       FilterOption1(id: 'mlw', name: 'MLW (kg)', isSelected: true),
//
//
//     ];
//
//     final operationalOptions = [
//       FilterOption1(id: 'takeoff_speed_kts', name: 'Takeoff Speed (kts)', isSelected: true),
//       FilterOption1(id: 'service_ceiling_ft', name: 'Service Ceiling (ft)', isSelected: true),
//       FilterOption1(id: 'max_altitude_ft', name: 'Max Certified Altitude (ft)', isSelected: true),
//       FilterOption1(id: 'cruise_speed_kts', name: 'Cruise Speed (kts)', isSelected: true),
//       FilterOption1(id: 'cruise_mach', name: 'Cruise Mach', isSelected: true),
//       FilterOption1(id: 'ferry_range_nm', name: 'Ferry Range (nm)', isSelected: true),
//       FilterOption1(id: 'normal_range_nm', name: 'Normal Range (nm)', isSelected: true),
//       FilterOption1(id: 'normal_range_km', name: 'Normal Range (km)', isSelected: true),
//       FilterOption1(id: 'initial_rate_of_descent_fpm', name: 'Initial Rate of Descent (fpm)', isSelected: true),
//       FilterOption1(id: 'average_rate_of_descent_fpm', name: 'Average Rate of Descent (fpm)', isSelected: true),
//       FilterOption1(id: 'min_clean_speed_kts', name: 'Minimum Clean Speed (kts)', isSelected: true),
//       FilterOption1(id: 'approach_speed_kts', name: 'Approach Speed (kts)', isSelected: true),
//       FilterOption1(id: 'landing_speed_kts', name: 'Landing Speed (kts)', isSelected: true),
//       FilterOption1(id: 'landing_distance_m', name: 'Landing Distance (m)', isSelected: true),
//       FilterOption1(id: 'runway_required_m', name: 'Runway Length Required (m)', isSelected: true),
//       FilterOption1(id: 'stall_speed', name: 'Stall Speed', isSelected: true),
//     ];
//
//
//     emit(
//       FilterState1(
//         filterCategories: [
//           FilterCategory1(id: 'general', name: 'GENERAL', options: generalOptions),
//           FilterCategory1(id: 'technical_data', name: 'TECHNICAL DATA', options: technicalOptions),
//           FilterCategory1(id: 'operational_data', name: 'OPERATIONAL DATA', options: operationalOptions),
//         ],
//         isApplied: true,
//       ),
//     );
//   }
//
//   void toggleOption({
//     required String categoryId,
//     required String optionId,
//     required bool isSelected,
//   }) {
//     final updatedCategories = state.filterCategories.map((cat) {
//       if (cat.id == categoryId) {
//         final updatedOptions = cat.options.map((opt) {
//           if (opt.id == optionId) {
//             return opt.copyWith(isSelected: isSelected);
//           }
//           return opt;
//         }).toList();
//         return cat.copyWith(options: updatedOptions);
//       }
//       return cat;
//     }).toList();
//
//     emit(state.copyWith(filterCategories: updatedCategories));
//   }
//
//   void updateSelectedFilters(List<FilterCategory1> updatedFilters, {bool isApplied = false}) {
//     emit(state.copyWith(
//       filterCategories: updatedFilters,
//       isApplied: isApplied,
//     ));
//   }
//
//
//
//   // Apply the filter (mark isApplied true)
//   void applyFilter() {
//     emit(state.copyWith(isApplied: true));
//   }
//
//   // Reset all options to selected (optional)
//   void selectAll() {
//     final allSelectedCategories = state.filterCategories.map((category) {
//       final allSelectedOptions = category.options
//           .map((option) => FilterOption1(id: option.id, name: option.name, isSelected: true))
//           .toList();
//
//       return FilterCategory1(
//         id: category.id,
//         name: category.name,
//         options: allSelectedOptions,
//       );
//     }).toList();
//
//     emit(state.copyWith(filterCategories: allSelectedCategories));
//   }
//
//
//   void toggleCategoryExpansion(String categoryId) {
//     final updatedCategories = state.filterCategories.map((category) {
//       if (category.id == categoryId) {
//         return category.copyWith(isExpanded: !category.isExpanded);
//       }
//       return category;
//     }).toList();
//     emit(state.copyWith(filterCategories: updatedCategories));
//   }
//
//
//   void resetFilters() {
//     final resetCategories = state.filterCategories.map((category) {
//       final resetOptions = category.options.map((option) {
//         return option.copyWith(isSelected: true);
//       }).toList();
//       return category.copyWith(options: resetOptions);
//     }).toList();
//
//     emit(state.copyWith(filterCategories: resetCategories, isApplied: false));
//   }
//
//   void toggleFilterOption(String categoryId, String optionId) {
//     final updatedCategories = state.filterCategories.map((category) {
//       if (category.id == categoryId) {
//         final updatedOptions = category.options.map((option) {
//           if (option.id == optionId) {
//             return option.copyWith(isSelected: !option.isSelected);
//           }
//           return option;
//         }).toList();
//         return category.copyWith(options: updatedOptions);
//       }
//       return category;
//     }).toList();
//
//     emit(state.copyWith(filterCategories: updatedCategories));
//   }
//
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'filtter_model.dart';
import 'filtter_state.dart';

class ComparisonFilterCubit1 extends Cubit<FilterState1> {
  ComparisonFilterCubit1() : super(const FilterState1(filterCategories: []));

  void loadFiltersFromComparison1(
    bool isAlreadyProcessing,
    FilterState1? model,
  ) {
    if (isAlreadyProcessing == true) {
      if (model != null) {
        emit(model!);
      }
    } else {
      final generalOptions = [
        FilterOption1(
          id: 'icao_type_code',
          name: 'ICAO Type Code',
          isSelected: true,
        ),
        FilterOption1(
          id: 'wake_turbulence',
          name: 'Wake Turbulence',
          isSelected: true,
        ),
        FilterOption1(id: 'avionics', name: 'Avionics', isSelected: true),
        FilterOption1(
          id: 'no_of_engines',
          name: 'Number of Engines',
          isSelected: true,
        ),
        FilterOption1(
          id: 'engine_model',
          name: 'Engine Model',
          isSelected: true,
        ),
        FilterOption1(id: 'engine_type', name: 'Engine Type', isSelected: true),
      ];

      final technicalOptions = [
        FilterOption1(id: 'wingspan_m', name: 'Wingspan (m)', isSelected: true),
        FilterOption1(id: 'length_m', name: 'Length (m)', isSelected: true),
        FilterOption1(id: 'height_m', name: 'Height (m)', isSelected: true),
        FilterOption1(
          id: 'max_Payload',
          name: 'Max Payload (kg)',
          isSelected: true,
        ),
        FilterOption1(id: 'mtow', name: 'MTOW (kg)', isSelected: true),
        FilterOption1(id: 'mlw', name: 'MLW (kg)', isSelected: true),
      ];

      final operationalOptions = [
        FilterOption1(
          id: 'takeoff_speed_kts',
          name: 'Takeoff Speed (kts)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'service_ceiling_ft',
          name: 'Service Ceiling (ft)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'max_altitude_ft',
          name: 'Max Certified Altitude (ft)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'cruise_speed_kts',
          name: 'Cruise Speed (kts)',
          isSelected: true,
        ),
        FilterOption1(id: 'cruise_mach', name: 'Cruise Mach', isSelected: true),
        FilterOption1(
          id: 'ferry_range_nm',
          name: 'Ferry Range (nm)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'normal_range_nm',
          name: 'Normal Range (nm)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'normal_range_km',
          name: 'Normal Range (km)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'initial_rate_of_descent_fpm',
          name: 'Initial Rate of Descent (fpm)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'average_rate_of_descent_fpm',
          name: 'Average Rate of Descent (fpm)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'min_clean_speed_kts',
          name: 'Minimum Clean Speed (kts)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'approach_speed_kts',
          name: 'Approach Speed (kts)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'landing_speed_kts',
          name: 'Landing Speed (kts)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'landing_distance_m',
          name: 'Landing Distance (m)',
          isSelected: true,
        ),
        FilterOption1(
          id: 'runway_required_m',
          name: 'Runway Length Required (m)',
          isSelected: true,
        ),
        FilterOption1(id: 'stall_speed', name: 'Stall Speed', isSelected: true),
      ];

      emit(
        FilterState1(
          filterCategories: [
            FilterCategory1(
              id: 'general',
              name: 'GENERAL',
              options: generalOptions,
            ),
            FilterCategory1(
              id: 'technical_data',
              name: 'TECHNICAL DATA',
              options: technicalOptions,
            ),
            FilterCategory1(
              id: 'operational_data',
              name: 'OPERATIONAL DATA',
              options: operationalOptions,
            ),
          ],
          isApplied: false,
        ),
      );
    }
  }

  void toggleOption({
    required String categoryId,
    required String optionId,
    required bool isSelected,
  }) {
    final updatedCategories = state.filterCategories.map((cat) {
      if (cat.id == categoryId) {
        final updatedOptions = cat.options.map((opt) {
          if (opt.id == optionId) {
            return opt.copyWith(isSelected: isSelected);
          }
          return opt;
        }).toList();
        return cat.copyWith(options: updatedOptions);
      }
      return cat;
    }).toList();

    emit(
      FilterState1(
        filterCategories: updatedCategories,
        isApplied: state.isApplied,
      ),
    );
  }

  void updateSelectedFilters(List<FilterCategory1> updatedFilters, {bool isApplied = false}) {
    emit(
      FilterState1(
        filterCategories: updatedFilters.map((f) => f.copyWith()).toList(),
        isApplied: isApplied,
      ),
    );
  }

  void applyFilter() {
    emit(state.copyWith(isApplied: true));
  }

  void selectAll() {
    final allSelectedCategories = state.filterCategories.map((category) {
      final allSelectedOptions = category.options
          .map(
            (option) => FilterOption1(
              id: option.id,
              name: option.name,
              isSelected: true,
            ),
          )
          .toList();
      return FilterCategory1(
        id: category.id,
        name: category.name,
        options: allSelectedOptions,
      );
    }).toList();

    emit(
      FilterState1(
        filterCategories: allSelectedCategories,
        isApplied: state.isApplied,
      ),
    );
  }

  void toggleCategoryExpansion(String categoryId) {
    final updatedCategories = state.filterCategories.map((category) {
      if (category.id == categoryId) {
        return category.copyWith(isExpanded: !category.isExpanded);
      }
      return category;
    }).toList();
    emit(
      FilterState1(
        filterCategories: updatedCategories,
        isApplied: state.isApplied,
      ),
    );
  }

  void resetFilters() {
    final resetCategories = state.filterCategories.map((category) {
      final resetOptions = category.options.map((option) {
        return option.copyWith(isSelected: true);
      }).toList();
      return category.copyWith(options: resetOptions);
    }).toList();

    emit(FilterState1(filterCategories: resetCategories, isApplied: false));
  }

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

    emit(
      FilterState1(
        filterCategories: updatedCategories,
        isApplied: state.isApplied,
      ),
    );
  }
}
