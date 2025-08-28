import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';

class AvtarState {
  final CommonApiStatus status;
  final String? selectedUserType;
  final String? errorMessage;

  const AvtarState({
    this.status = CommonApiStatus.initial,
    this.selectedUserType,
    this.errorMessage,
  });

  AvtarState copyWith({
    CommonApiStatus? status,
    String? selectedUserType,
    String? errorMessage,
  }) {
    return AvtarState(
      status: status ?? this.status,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      errorMessage: errorMessage,
    );
  }
}
