import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'delete_state.dart';
import 'delete_repository.dart';

class DeleteCubit extends Cubit<DeleteState> {
  final DeleteRepository repository;

  DeleteCubit({DeleteRepository? deleteRepository})
      : repository = deleteRepository ?? DeleteRepository(),
        super(DeleteState());

  Future<void> delete(BuildContext context) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    try {
      await repository.deleteUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your Account Delete successfully.')),
      );

      Future.delayed(Duration(seconds: 2), () {
        emit(state.copyWith(isSuccess:true));
      });
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      ));
    }
  }
}
