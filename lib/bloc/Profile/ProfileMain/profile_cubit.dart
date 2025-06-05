import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../SavedFlighDetails/savedFlight_model.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit() : super(ProfileScreenState(savedflight: []));

  void loadManufacturers() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

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

  void resetActionState() {
    emit(state.copyWith(
      isLoading: false, // Reset loading state for generic actions
      errorMessage: null,
      logoutSuccess: false,
      deleteAccountSuccess: false,
    ));
  }
}