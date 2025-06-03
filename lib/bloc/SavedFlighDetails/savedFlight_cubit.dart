import 'package:flutter_bloc/flutter_bloc.dart';
import 'savedFlight_model.dart';
import 'savedFlight_state.dart';

class SavedFlightCubit extends Cubit<SavedFlightState> {
  SavedFlightCubit() : super(SavedFlightState(savedflight: []));

  void loadManufacturers() {
    emit(state.copyWith(isLoading: true));

    // Mock data
    final mockData = [
      SavedFlight(name: 'Antonov', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Airbus', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Aquila Aviation', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Adam Aircraft Industries', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Ayres', icon: 'ManuFirstImage'),
      SavedFlight(name: 'AVRO', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Aero Commander Aircraft', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Air Tractor', icon: 'ManuFirstImage'),
      SavedFlight(name: 'Agusta / AgustaWestland', icon: 'ManuFirstImage'),
      SavedFlight(name: 'American Air Corp', icon: 'ManuFirstImage'),
    ];

    emit(state.copyWith(savedflight: mockData, isLoading: false));
  }
}
