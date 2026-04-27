// import 'package:equatable/equatable.dart';
// import 'filtter_model.dart';
//
// class FilterState1 extends Equatable {
//   final List<FilterCategory1> filterCategories;
//   final bool isApplied;
//   final bool isLoading;
//
//   const FilterState1({
//     required this.filterCategories,
//     this.isApplied = false,
//     this.isLoading = false,
//   });
//
//   FilterState1 copyWith({
//     List<FilterCategory1>? filterCategories,
//     bool? isApplied,
//     bool? isLoading,
//   }) {
//     return FilterState1(
//       filterCategories: filterCategories ?? this.filterCategories,
//       isApplied: isApplied ?? this.isApplied,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
//
//   @override
//   List<Object> get props => [filterCategories, isApplied, isLoading];
// }

import 'package:equatable/equatable.dart';
import 'filtter_model.dart';

class FilterState1 extends Equatable {
  final List<FilterCategory1> filterCategories;
  final bool isApplied;
  final bool isLoading;

  const FilterState1({
    this.filterCategories = const [],
    this.isApplied = false,
    this.isLoading = false,
  });

  FilterState1 copyWith({
    List<FilterCategory1>? filterCategories,
    bool? isApplied,
    bool? isLoading,
  }) {
    return FilterState1(
      filterCategories: filterCategories ?? this.filterCategories,
      isApplied: isApplied ?? this.isApplied,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [filterCategories, isApplied, isLoading];
}
