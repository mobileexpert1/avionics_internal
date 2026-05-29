class FilterOption {
  final String id;
  final String name;
  bool isSelected;

  FilterOption({required this.id, required this.name, this.isSelected = false});

  FilterOption copyWith({String? id, String? name, bool? isSelected}) {
    return FilterOption(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FilterCategory {
  final String id;
  final String name;
  final List<FilterOption> options;
  bool isExpanded;

  FilterCategory({
    required this.id,
    required this.name,
    required this.options,
    this.isExpanded = true,
  });

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

