class DeleteState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  DeleteState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  DeleteState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return DeleteState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
