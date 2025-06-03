// lib/bloc/filter/filter_model.dart

/// Represents a single selectable option within a filter category.
class FilterOption {
  final String id;
  final String name;
  bool isSelected;

  FilterOption({required this.id, required this.name, this.isSelected = false});

  /// Creates a copy of this FilterOption instance with updated values.
  FilterOption copyWith({String? id, String? name, bool? isSelected}) {
    return FilterOption(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Represents a category of filters, containing a list of FilterOption.
class FilterCategory {
  final String id;
  final String name;
  final List<FilterOption> options;
  bool isExpanded; // Added to control expansion/collapse of the category

  FilterCategory({
    required this.id,
    required this.name,
    required this.options,
    this.isExpanded = true, // Default to expanded
  });

  /// Creates a copy of this FilterCategory instance with updated values.
  FilterCategory copyWith({
    String? id,
    String? name,
    List<FilterOption>? options,
    bool? isExpanded,
  }) {
    return FilterCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      options: options ?? this.options,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

