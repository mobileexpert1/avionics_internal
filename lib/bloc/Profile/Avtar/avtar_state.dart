import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';

import 'avtar_model.dart';

class AvtarState {
  final CommonApiStatus status;
  final String? selectedUserType;
  final String? errorMessage;
  final List<AvatarModel> avatars;

  const AvtarState({
    this.status = CommonApiStatus.initial,
    this.selectedUserType,
    this.errorMessage,
    this.avatars = const [],
  });

  AvtarState copyWith({
    CommonApiStatus? status,
    String? selectedUserType,
    String? errorMessage,
    List<AvatarModel>? avatars,
  }) {
    return AvtarState(
      status: status ?? this.status,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      errorMessage: errorMessage,
      avatars: avatars ?? this.avatars,
    );
  }
}
