import 'glossary_model.dart';

class GlossaryState {
  final Map<String, List<GlossaryItem>> glossaryData;
  final bool isLoading;

  const GlossaryState({
    required this.glossaryData,
    this.isLoading = false,
  });

  GlossaryState copyWith({
    Map<String, List<GlossaryItem>>? glossaryData,
    bool? isLoading,
  }) {
    return GlossaryState(
      glossaryData: glossaryData ?? this.glossaryData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}