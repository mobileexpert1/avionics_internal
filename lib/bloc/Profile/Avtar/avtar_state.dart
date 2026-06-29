import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';

import 'avtar_model.dart';

class AvtarState {
  final CommonApiStatus status;
  final String? selectedUserType;
  final String? selectedUserTypeUrl;
  final String? errorMessage;
  final List<AvatarModel> avatars;
  final bool loading;
  final int isComeFromSignup;

  const AvtarState({
    this.status = CommonApiStatus.initial,
    this.selectedUserType,
    this.selectedUserTypeUrl,
    this.errorMessage,
    this.avatars = const [],
    this.loading = false,
    this.isComeFromSignup = -1,
  });

  AvtarState copyWith({
    CommonApiStatus? status,
    String? selectedUserType,
    String? selectedUserTypeUrl,
    String? errorMessage,
    List<AvatarModel>? avatars,
    bool? loading,
    int? isComeFromSignup,
  }) {
    return AvtarState(
      status: status ?? this.status,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      selectedUserTypeUrl: selectedUserTypeUrl ?? this.selectedUserTypeUrl,
      errorMessage: errorMessage,
      avatars: avatars ?? this.avatars,
      loading: loading ?? this.loading,
      isComeFromSignup: isComeFromSignup ?? this.isComeFromSignup,
    );
  }
}
