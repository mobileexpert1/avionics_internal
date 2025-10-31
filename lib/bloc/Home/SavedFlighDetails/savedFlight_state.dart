import 'package:equatable/equatable.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';

class SavedFlightState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;
  final List<dynamic> savedflight;
  final List<dynamic> favorites;

  const SavedFlightState({
    required this.isLoading,
    required this.isSuccess,
    required this.apiError,
    required this.status,
    required this.errorMessage,
    required this.savedflight,
    required this.favorites,
  });

  factory SavedFlightState.initial() {
    return SavedFlightState(
      isLoading: false,
      isSuccess: false,
      apiError: null,
      status: CommonApiStatus.initial,
      errorMessage: null,
      savedflight: const [],
      favorites: const [],
    );
  }

  SavedFlightState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
    List<dynamic>? savedflight,
    List<dynamic>? favorites,
  }) {
    return SavedFlightState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      savedflight: savedflight ?? this.savedflight,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    apiError,
    status,
    errorMessage,
    savedflight,
    favorites,
  ];
}
