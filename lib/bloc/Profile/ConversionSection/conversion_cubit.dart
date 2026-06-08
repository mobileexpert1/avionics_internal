import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'conversion_repository.dart';
import 'conversion_state.dart';

class ConversionCubit extends Cubit<ConversionState> {
  ConversionCubit() : super(ConversionState());

  Future<void> loadConversions(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

      try {
        final conversions = await ConversionRepository().getAllConversions();

        emit(
          state.copyWith(
            categories: conversions,
            isLoading: false,
            isSuccess: true,
            status: CommonApiStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    } else {
      NoInternetDialog.show(context, onRetry: () => loadConversions(context));
    }
  }
}
