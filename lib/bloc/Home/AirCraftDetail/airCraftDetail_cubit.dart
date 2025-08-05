import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'airCraftDetail_repository.dart';
import 'airCraftDetail_state.dart';

class AirCraftDetailCubit extends Cubit<AirCartState> {
  final  repository = AirCraftRepository();

  AirCraftDetailCubit() : super(AirCartInitial());

  Future<void> fetchAirCraftData(BuildContext context , aircraftId) async {
    emit(AirCartLoading());
    try {
      final data = await AirCraftRepository.getAirCraftData(aircraftId);
      emit(
        AirCartLoaded(
          performance: data.results.performance,
          detail: data.detail,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(AirCartError(e.toString()));
    }
  }
}
