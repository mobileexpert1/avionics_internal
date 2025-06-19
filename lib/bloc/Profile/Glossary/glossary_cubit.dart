import 'package:avionics_internal/bloc/Profile/Glossary/glossary_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'glossary_state.dart';

class GlossaryCubit extends Cubit<GlossaryState> {
  final GlossaryRepository repository =GlossaryRepository();
  GlossaryCubit() : super(const GlossaryState(glossaryData: {})) {
    loadGlossary();
  }

  Future<void> loadGlossary({String? query}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final glossaryData = await repository.getGlossaryData(query: query);
      emit(GlossaryState(glossaryData: glossaryData, isLoading: false));
    } catch (e) {
      emit(GlossaryState(glossaryData: {}, isLoading: false));
    }
  }
}
