import 'package:equatable/equatable.dart';

class ComparisonFilterModel extends Equatable {
  final String id;
  final String name;
  final bool isSelected;

  const ComparisonFilterModel({
    required this.id,
    required this.name,
    this.isSelected = true,
  });

  ComparisonFilterModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return ComparisonFilterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, name, isSelected];
}

class ComparisonFilterCategory extends Equatable {
  final String id;
  final String name;
  final List<ComparisonFilterModel> options;
  final bool isExpanded;

  const ComparisonFilterCategory({
    required this.id,
    required this.name,
    required this.options,
    this.isExpanded = true,
  });

  ComparisonFilterCategory copyWith({
    String? id,
    String? name,
    List<ComparisonFilterModel>? options,
    bool? isExpanded,
  }) {
    return ComparisonFilterCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      options: options ?? this.options,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [id, name, options, isExpanded];
}
