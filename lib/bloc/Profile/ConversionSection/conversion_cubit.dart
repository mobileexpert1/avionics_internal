import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'conversion_repository.dart';
import 'conversion_state.dart';

class ConversionCubit extends Cubit<ConversionState> {

  ConversionCubit() : super(ConversionState());

  Future<void> loadConversions() async {
    emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

    try {
      final conversions = await ConversionRepository().getAllConversions();

      emit(state.copyWith(
        categories: conversions,
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
