import 'package:equatable/equatable.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';

abstract class UnitSelectionState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final CommonApiStatus status;
  final String? errorMessage;

  const UnitSelectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, isSuccess, status, errorMessage];
}

class UnitSelectionInitial extends UnitSelectionState {
  final String speed;
  final String altitude;
  final String distance;
  final String temperature;


  const UnitSelectionInitial({
    required this.speed,
    required this.altitude,
    required this.distance,
    required this.temperature,
    bool isLoading = false,
    bool isSuccess = false,
    CommonApiStatus status = CommonApiStatus.initial,
    String? errorMessage,
  }) : super(
    isLoading: isLoading,
    isSuccess: isSuccess,
    status: status,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => super.props + [
    speed,
    altitude,
    distance,
    temperature,
  ];

  UnitSelectionInitial copyWith({
    String? speed,
    String? altitude,
    String? distance,
    String? temperature,
    bool? isLoading,
    bool? isSuccess,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return UnitSelectionInitial(
      speed: speed ?? this.speed,
      altitude: altitude ?? this.altitude,
      distance: distance ?? this.distance,
      temperature: temperature ?? this.temperature,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
