import 'package:flutter_bloc/flutter_bloc.dart';
import 'ManufacturerDetailState.dart';

class ManufacturerDetailCubit extends Cubit<ManufacturerDetailState> {
  ManufacturerDetailCubit() : super(ManufacturerDetailState());

  void toggleGeneralInfo() => emit(state.copyWith(showGeneralInfo: !state.showGeneralInfo));
  void toggleAbout() => emit(state.copyWith(showAbout: !state.showAbout));
  void toggleHistory() => emit(state.copyWith(showHistory: !state.showHistory));
  void toggleProducts() => emit(state.copyWith(showProducts: !state.showProducts));
}
