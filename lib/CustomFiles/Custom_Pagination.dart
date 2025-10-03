class PaginatedList<T> {
  final List<T> results;
  final int count;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedList({
    required this.results,
    required this.count,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedList.fromJson({
    required Map<String, dynamic> json,
    required T Function(Map<String, dynamic>) fromJson,
    required int currentPage,
  }) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];
    final totalPages = json['total_pages'] ?? 1;

    return PaginatedList<T>(
      results: resultsJson
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] ?? 0,
      totalPages: totalPages,
      currentPage: currentPage,
      hasNext: currentPage < totalPages,
      hasPrevious: currentPage > 1,
    );
  }

  PaginatedList<T> copyWith({
    List<T>? results,
    int? count,
    int? totalPages,
    int? currentPage,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return PaginatedList<T>(
      results: results ?? this.results,
      count: count ?? this.count,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}
