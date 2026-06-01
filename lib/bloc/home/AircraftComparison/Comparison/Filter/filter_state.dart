import 'filter_model.dart';

class FilterState {
  final List<FilterCategory> filterCategories;
  final bool isLoading;
  final bool isApplied;

  FilterState({
    required this.filterCategories,
    this.isLoading = false,
    this.isApplied = false,
  });

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
