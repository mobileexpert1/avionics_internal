import 'package:equatable/equatable.dart';
import 'ComparisonFilterModel.dart';

class ComparisonFilterState extends Equatable {
  final List<ComparisonFilterCategory> filterCategories;
  final bool isApplied;
  final bool isLoading;

  const ComparisonFilterState({
    this.filterCategories = const [],
    this.isApplied = false,
    this.isLoading = false,
  });

  ComparisonFilterState copyWith({
    List<ComparisonFilterCategory>? filterCategories,
    bool? isApplied,
    bool? isLoading,
  }) {
    return ComparisonFilterState(
      filterCategories: filterCategories ?? this.filterCategories,
      isApplied: isApplied ?? this.isApplied,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [filterCategories, isApplied, isLoading];
}
