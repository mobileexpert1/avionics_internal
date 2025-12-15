import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'formula_repository.dart';
import 'formula_state.dart';

class FormulaCubit extends Cubit<FormulaState> {
  FormulaCubit() : super(FormulaState());

  Future<void> loadFormulas() async {
    emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

    try {
      final formulas = await FormulaRepository().getAllFormulas();

      emit(state.copyWith(
        categories: formulas,
        isLoading: false,
        isSuccess: true,
        status: CommonApiStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
        status: CommonApiStatus.failure,
      ));
    }
  }
}
