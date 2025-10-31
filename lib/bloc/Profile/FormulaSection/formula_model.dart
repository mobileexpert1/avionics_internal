class FormulaModel {
  final String name;
  final List<FormulaItem> formulas;

  FormulaModel({
    required this.name,
    required this.formulas,
  });

  factory FormulaModel.fromJson(Map<String, dynamic> json) {
    return FormulaModel(
      name: json['name'] ?? '',
      formulas: (json['formulas'] as List<dynamic>)
          .map((item) => FormulaItem.fromJson(item))
          .toList(),
    );
  }
}

class FormulaItem {
  final String title;
  final String expression;

  FormulaItem({
    required this.title,
    required this.expression,
  });

  factory FormulaItem.fromJson(Map<String, dynamic> json) {
    return FormulaItem(
      title: json['title'] ?? '',
      expression: json['expression'] ?? '',
    );
  }
}
