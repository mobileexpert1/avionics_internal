class ProfileScreenState {
  final bool isLoading;

  const ProfileScreenState({this.isLoading = false});

  ProfileScreenState copyWith({
    bool? isLoading,
    bool? isProUser,
    String? errorMessage,
    bool? logoutSuccess,
    bool? deleteAccountSuccess,
  }) {
    return ProfileScreenState(isLoading: isLoading ?? this.isLoading);
  }

  List<Object?> get props => [isLoading];
}
