import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Glossary/glossary_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'glossary_state.dart';

class GlossaryCubit extends Cubit<GlossaryState> {
  final GlossaryRepository repository = GlossaryRepository();

  GlossaryCubit(BuildContext context)
    : super(const GlossaryState(glossaryData: {})) {
    loadGlossary(context: context);
  }

  Future<void> loadGlossary({
    String? query,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final glossaryData = await repository.getGlossaryData(query: query);
      emit(GlossaryState(glossaryData: glossaryData, isLoading: false));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(GlossaryState(glossaryData: {}, isLoading: false,errorMessage: e.toString(),status: CommonApiStatus.failure));
    }
  }
}
