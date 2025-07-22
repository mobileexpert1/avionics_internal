import 'package:flutter_bloc/flutter_bloc.dart';
import 'savedFlight_model.dart';
import 'savedFlight_state.dart';

class SavedFlightCubit extends Cubit<SavedFlightState> {
  SavedFlightCubit() : super(SavedFlightState(savedflight: []));

  void loadManufacturers() {
    emit(state.copyWith(isLoading: true));

    // Mock data
    final mockData = [
      SavedFlightAndProfileSectionModel(name: 'Antonov', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Airbus', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Aquila Aviation', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Adam Aircraft Industries', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Ayres', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'AVRO', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Aero Commander Aircraft', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Air Tractor', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'Agusta / AgustaWestland', icon: 'ManuFirstImage'),
      SavedFlightAndProfileSectionModel(name: 'American Air Corp', icon: 'ManuFirstImage'),
    ];

    emit(state.copyWith(savedflight: mockData, isLoading: false));
  }
}
