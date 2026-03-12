import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'glossary_model.dart';

class GlossaryState {
  final Map<String, List<GlossaryItem>> glossaryData;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final CommonApiStatus status;

  final Map<String, List<GlossaryItem>>? originalData;
  String? selectedLetter;

  GlossaryState({
    required this.glossaryData,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.status = CommonApiStatus.initial,

    this.originalData,
    this.selectedLetter,
  });

  GlossaryState copyWith({
    Map<String, List<GlossaryItem>>? glossaryData,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    CommonApiStatus? status,

    Map<String, List<GlossaryItem>>? originalData,
    String? selectedLetter,
  }) {
    return GlossaryState(
      glossaryData: glossaryData ?? this.glossaryData,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,

      originalData: originalData ?? this.originalData,
      selectedLetter: selectedLetter ?? this.selectedLetter,
    );
  }
}
