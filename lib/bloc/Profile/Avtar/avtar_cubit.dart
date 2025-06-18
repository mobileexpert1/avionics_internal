import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Avtar/avtar_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import 'avtar_state.dart';

class AvtarCubit extends Cubit<AvtarState> {
  AvtarCubit() : super(const AvtarState());

  /// Save avatar and call API
  Future<void> selectAvatar(String userType) async {
    emit(
      state.copyWith(
        status: CommonApiStatus.submitting,
        selectedUserType: userType,
      ),
    );

    try {
      await AvtarRepository().setAvtarForProfile(userType: userType);

      await SharedPrefsHelper.setAvtarUserType(userType);

      emit(state.copyWith(status: CommonApiStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAvatarFromPrefs() async {
    final userType = await SharedPrefsHelper.getAvtarUserType();
    emit(
      state.copyWith(
        selectedUserType: userType,
        status: CommonApiStatus.initial, // Reset the status
        errorMessage: null,
      ),
    );
  }
}
