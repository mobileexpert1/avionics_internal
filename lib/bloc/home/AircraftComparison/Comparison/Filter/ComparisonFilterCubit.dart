import 'package:flutter_bloc/flutter_bloc.dart';

import 'ComparisonFilterModel.dart';
import 'ComparsionFilterState.dart';

class ComparisonFilterCubit1 extends Cubit<ComparisonFilterState> {
  ComparisonFilterCubit1()
    : super(const ComparisonFilterState(filterCategories: []));

  void loadFiltersFromComparison1(
    bool isAlreadyProcessing,
    ComparisonFilterState? model,
  ) {
    if (isAlreadyProcessing == true) {
      if (model != null) {
        emit(model);
      }
    } else {
      final generalOptions = [
        ComparisonFilterModel(
          id: 'icao_type_code',
          name: 'ICAO Type Code',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'wake_turbulence',
          name: 'Wake Turbulence',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'avionics',
          name: 'Avionics',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'no_of_engines',
          name: 'Number of Engines',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'engine_model',
          name: 'Engine Model',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'engine_type',
          name: 'Engine Type',
          isSelected: true,
        ),
      ];
      final technicalOptions = [
        ComparisonFilterModel(
          id: 'wingspan_m',
          name: 'Wingspan (m)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'length_m',
          name: 'Length (m)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'height_m',
          name: 'Height (m)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'max_Payload',
          name: 'Max Payload (kg)',
          isSelected: true,
        ),
        ComparisonFilterModel(id: 'mtow', name: 'MTOW (kg)', isSelected: true),
        ComparisonFilterModel(id: 'mlw', name: 'MLW (kg)', isSelected: true),
      ];
      final operationalOptions = [
        ComparisonFilterModel(
          id: 'takeoff_speed_kts',
          name: 'Takeoff Speed (kts)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'service_ceiling_ft',
          name: 'Service Ceiling (ft)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'max_altitude_ft',
          name: 'Max Certified Altitude (ft)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'cruise_speed_kts',
          name: 'Cruise Speed (kts)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'cruise_mach',
          name: 'Cruise Mach',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'ferry_range_nm',
          name: 'Ferry Range (nm)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'normal_range_nm',
          name: 'Normal Range (nm)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'normal_range_km',
          name: 'Normal Range (km)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'initial_rate_of_descent_fpm',
          name: 'Initial Rate of Descent (fpm)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'average_rate_of_descent_fpm',
          name: 'Average Rate of Descent (fpm)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'min_clean_speed_kts',
          name: 'Minimum Clean Speed (kts)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'approach_speed_kts',
          name: 'Approach Speed (kts)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'landing_speed_kts',
          name: 'Landing Speed (kts)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'landing_distance_m',
          name: 'Landing Distance (m)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'runway_required_m',
          name: 'Runway Length Required (m)',
          isSelected: true,
        ),
        ComparisonFilterModel(
          id: 'stall_speed',
          name: 'Stall Speed',
          isSelected: true,
        ),
      ];
      emit(
        ComparisonFilterState(
          filterCategories: [
            ComparisonFilterCategory(
              id: 'general',
              name: 'General',
              options: generalOptions,
            ),
            ComparisonFilterCategory(
              id: 'technical_data',
              name: 'Technical data',
              options: technicalOptions,
            ),
            ComparisonFilterCategory(
              id: 'operational_data',
              name: 'Operational Data',
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
      ComparisonFilterState(
        filterCategories: updatedCategories,
        isApplied: state.isApplied,
      ),
    );
  }

  void toggleSelectAll(bool selectAll) {
    final updatedCategories = state.filterCategories.map((category) {
      final updatedOptions = category.options
          .map((option) => option.copyWith(isSelected: selectAll))
          .toList();
      return category.copyWith(options: updatedOptions);
    }).toList();

    emit(state.copyWith(filterCategories: updatedCategories));
  }

  // filtter_cubit.dart
  void selectAllOptions(String categoryId, bool isSelected) {
    final updatedCategories = state.filterCategories.map((category) {
      if (category.id == categoryId) {
        final updatedOptions = category.options
            .map((option) => option.copyWith(isSelected: isSelected))
            .toList();
        return category.copyWith(options: updatedOptions);
      }
      return category;
    }).toList();

    emit(state.copyWith(filterCategories: updatedCategories));
  }

  void updateSelectedFilters(
    List<ComparisonFilterCategory> updatedFilters, {
    bool isApplied = false,
  }) {
    print("Previous:- $state.filterCategories");
    print("Previous:- $updatedFilters");
    emit(
      ComparisonFilterState(
        filterCategories: updatedFilters.map((f) => f.copyWith()).toList(),
        isApplied: isApplied,
      ),
    );
  }

  void applyFilter() {
    emit(state.copyWith(isApplied: true));
  }

  void selectAll() {
    final allSelectedFiltersCategories = state.filterCategories.map((category) {
      final allSelectedOptions = category.options
          .map(
            (option) => ComparisonFilterModel(
              id: option.id,
              name: option.name,
              isSelected: true,
            ),
          )
          .toList();
      return ComparisonFilterCategory(
        id: category.id,
        name: category.name,
        options: allSelectedOptions,
      );
    }).toList();

    emit(
      ComparisonFilterState(
        filterCategories: allSelectedFiltersCategories,
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
      ComparisonFilterState(
        filterCategories: updatedCategories,
        isApplied: state.isApplied,
      ),
    );
  }

  void resetFilters() {
    final resetCategories = state.filterCategories.map((category) {
      final resetOptions = category.options.map((option) {
        return option.copyWith(isSelected: false);
      }).toList();
      return category.copyWith(options: resetOptions);
    }).toList();

    emit(
      ComparisonFilterState(
        filterCategories: resetCategories,
        isApplied: false,
      ),
    );
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
      ComparisonFilterState(
        filterCategories: updatedCategories,
        isApplied: state.isApplied,
      ),
    );
  }
}
