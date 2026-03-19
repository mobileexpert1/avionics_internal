class HistoryItem {
  HistoryItem({
    required this.operation,
    required this.result,
    required this.createdAt,
  });

  final String operation;
  final String result;
  final DateTime createdAt;

  Map<String, dynamic> get toMap => {
    'operation': operation,
    'result': result,
    'createdAt': createdAt.toIso8601String(),
  };

  static HistoryItem fromMap(Map historyItemAsMap) => HistoryItem(
    operation: historyItemAsMap['operation'],
    result: historyItemAsMap['result'],
    createdAt: historyItemAsMap['createdAt'] != null
        ? DateTime.parse(historyItemAsMap['createdAt'])
        : DateTime.now(),
  );

  @override
  String toString() {
    return 'HistoryItem(operation: $operation , result: $result, createdAt: $createdAt)';
  }
}