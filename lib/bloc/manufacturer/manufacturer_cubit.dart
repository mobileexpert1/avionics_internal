import 'package:flutter_bloc/flutter_bloc.dart';
import 'manufacturer_state.dart';
import 'manufacturer_repository.dart';

class ManufacturerCubit extends Cubit<ManufacturerState> {
  final ManufacturerRepository repository;

  ManufacturerCubit({ManufacturerRepository? repo})
      : repository = repo ?? ManufacturerRepository(),
        super(ManufacturerState(manufacturers: []));

  Future<void> loadManufacturers({String? query}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final manufacturers = await repository.getManufacturers(query: query);
      emit(state.copyWith(manufacturers: manufacturers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(manufacturers: [], isLoading: false));
    }
  }
}
