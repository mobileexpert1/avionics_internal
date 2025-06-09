// unit_selection_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'unit_selection_state.dart';

class UnitSelectionCubit extends Cubit<UnitSelectionState> {
  UnitSelectionCubit()
    : super(
        UnitSelectionState(
          speed: 'Kts',
          altitude: 'Feet',
          distance: 'Miles',
          temperature: 'Celsius',
        ),
      );

  void selectSpeed(String value) => emit(state.copyWith(speed: value));

  void selectAltitude(String value) => emit(state.copyWith(altitude: value));

  void selectDistance(String value) => emit(state.copyWith(distance: value));

  void selectTemperature(String value) =>
      emit(state.copyWith(temperature: value));
}
