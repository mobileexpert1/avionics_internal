import 'savedFlight_model.dart';

class SavedFlightState {
  final List<SavedFlight> savedflight;
  final bool isLoading;

SavedFlightState({required this.savedflight, this.isLoading = false});

SavedFlightState copyWith({
    List<SavedFlight>? savedflight,
    bool? isLoading,
  }) {
    return SavedFlightState(
      savedflight: savedflight ?? this.savedflight,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
