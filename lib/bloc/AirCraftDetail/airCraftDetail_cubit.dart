import 'package:flutter_bloc/flutter_bloc.dart';

import 'airCraftDetail_state.dart';


class AirCraftDetailCubit extends Cubit<AirCraftDetailState> {
  AirCraftDetailCubit() : super(AirCraftDetailInitial());

  void toggleTechnicalData(bool isVisible) {
    if (isVisible) {
      emit(TechnicalDataVisible());
    } else {
      emit(TechnicalDataHidden());
    }
  }
}