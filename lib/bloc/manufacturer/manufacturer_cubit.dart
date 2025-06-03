import 'package:flutter_bloc/flutter_bloc.dart';
import 'manufacturer_model.dart';
import 'manufacturer_state.dart';

class ManufacturerCubit extends Cubit<ManufacturerState> {
  ManufacturerCubit() : super(ManufacturerState(manufacturers: []));

  void loadManufacturers() {
    emit(state.copyWith(isLoading: true));

    // Mock data
    final mockData = [
      Manufacturer(name: 'Antonov', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Airbus', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Aquila Aviation', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Adam Aircraft Industries', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Ayres', icon: 'ManuFirstImage'),
      Manufacturer(name: 'AVRO', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Aero Commander Aircraft', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Air Tractor', icon: 'ManuFirstImage'),
      Manufacturer(name: 'Agusta / AgustaWestland', icon: 'ManuFirstImage'),
      Manufacturer(name: 'American Air Corp', icon: 'ManuFirstImage'),
    ];

    emit(state.copyWith(manufacturers: mockData, isLoading: false));
  }
}
