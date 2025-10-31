import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'formula_model.dart';

class FormulaState {
  final bool isLoading;
  final bool isSuccess;
  final List<FormulaModel> categories;
  final FormulaModel? selectedCategory;
  final String? errorMessage;
  final CommonApiStatus status;

  FormulaState({
    this.isLoading = false,
    this.isSuccess = false,
    this.categories = const [],
    this.selectedCategory,
    this.errorMessage,
    this.status = CommonApiStatus.initial,
  });

  FormulaState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<FormulaModel>? categories,
    FormulaModel? selectedCategory,
    String? errorMessage,
    CommonApiStatus? status,
  }) {
    return FormulaState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
