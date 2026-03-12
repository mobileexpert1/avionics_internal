import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Glossary/glossary_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'glossary_model.dart';
import 'glossary_state.dart';

class GlossaryCubit extends Cubit<GlossaryState> {
  final GlossaryRepository repository = GlossaryRepository();

  GlossaryCubit(BuildContext context) : super(GlossaryState(glossaryData: {})) {
    loadGlossary(context: context);
  }

  Future<void> loadGlossary({
    String? query,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final glossaryData = await repository.getGlossaryData(query: query);
      emit(
        GlossaryState(
          glossaryData: glossaryData,
          originalData: glossaryData,
          isLoading: false,
        ),
      );

      state.selectedLetter = "A";
      filterByLetter(letter: state.selectedLetter ?? "", context: context);
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        GlossaryState(
          glossaryData: {},
          originalData: {},
          isLoading: false,
          errorMessage: e.toString(),
          status: CommonApiStatus.failure,
        ),
      );
    }
  }

  Future<void> searchGlossary({
    required String query,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (query.isEmpty) {
        emit(
          state.copyWith(
            glossaryData: state.originalData,
            isLoading: false,
            status: CommonApiStatus.success,
          ),
        );
        return;
      }

      final Map<String, List<GlossaryItem>> result = {};

      state.originalData?.forEach((key, items) {
        final filteredItems = items.where((item) {
          return item.title.toLowerCase().contains(query.toLowerCase());
        }).toList();

        if (filteredItems.isNotEmpty) {
          result[key] = filteredItems;
        }
      });

      emit(
        state.copyWith(
          glossaryData: result,
          isLoading: false,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          glossaryData: {},
          isLoading: false,
          errorMessage: e.toString(),
          status: CommonApiStatus.failure,
        ),
      );
    }
  }

  Future<void> filterByLetter({
    required String letter,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (!state.originalData!.containsKey(letter)) {
        emit(
          state.copyWith(
            glossaryData: state.originalData,
            isLoading: false,
            status: CommonApiStatus.success,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          glossaryData: {letter: state.originalData![letter]!},
          isLoading: false,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          glossaryData: {},
          isLoading: false,
          errorMessage: e.toString(),
          status: CommonApiStatus.failure,
        ),
      );
    }
  }
}
