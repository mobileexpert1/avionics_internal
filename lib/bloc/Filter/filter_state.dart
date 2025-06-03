// lib/bloc/filter/filter_state.dart

import 'filter_model.dart';

/// Represents the state of the Filter screen.
class FilterState {
  final List<FilterCategory> filterCategories;
  final bool isLoading;
  final bool isApplied; // To indicate if filters are applied

  FilterState({
    required this.filterCategories,
    this.isLoading = false,
    this.isApplied = false,
  });

  /// Creates a copy of this state with updated values.
  FilterState copyWith({
    List<FilterCategory>? filterCategories,
    bool? isLoading,
    bool? isApplied,
  }) {
    return FilterState(
      filterCategories: filterCategories ?? this.filterCategories,
      isLoading: isLoading ?? this.isLoading,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
