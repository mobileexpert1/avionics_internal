class FilterOption1 {
  final String id;
  final String name;
  bool isSelected;

  FilterOption1({
    required this.id,
    required this.name,
    this.isSelected = true,
  });
  FilterOption1 copyWith({String? id, String? name, bool? isSelected}) {
    return FilterOption1(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FilterCategory1 {
  final String id;
  final String name;
  final List<FilterOption1> options;
  bool isExpanded;

  FilterCategory1({
    required this.id,
    required this.name,
    required this.options,
    this.isExpanded = true,
  });

  FilterCategory1 copyWith({
    String? id,
    String? name,
    List<FilterOption1>? options,
    bool? isExpanded,
  }) {
    return FilterCategory1(
      id: id ?? this.id,
      name: name ?? this.name,
      options: options ?? this.options,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
