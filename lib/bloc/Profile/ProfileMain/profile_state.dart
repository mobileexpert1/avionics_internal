import '../../home/SavedFlighDetails/savedFlight_model.dart';

class ProfileScreenState  {
  // final List<SavedFlightAndProfileSectionModel> savedflight;
  final bool isLoading;

  const ProfileScreenState({
    // required this.savedflight,
    this.isLoading = false,
  });

  ProfileScreenState copyWith({
    // List<SavedFlightAndProfileSectionModel>? savedflight,
    bool? isLoading,
    bool? isProUser,
    String? errorMessage,
    bool? logoutSuccess,
    bool? deleteAccountSuccess,
  }) {
    return ProfileScreenState(
      // savedflight: savedflight ?? this.savedflight,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Object?> get props => [
    // savedflight,
    isLoading,
  ];
}