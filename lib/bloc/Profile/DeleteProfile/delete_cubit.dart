import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_state.dart';
import 'delete_repository.dart';

class DeleteCubit extends Cubit<DeleteState> {
  final DeleteRepository repository;

  DeleteCubit({DeleteRepository? deleteRepository})
      : repository = deleteRepository ?? DeleteRepository(),
        super(DeleteState());

  Future<void> delete(String token) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    try {
      final success = await repository.deleteUser(token: token);

      if (success) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Account deletion failed.',
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred: ${e.toString()}',
        isSuccess: false,
      ));
    }
  }
}
