import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'manufacturer_state.dart';
import 'manufacturer_repository.dart';

class ManufacturerCubit extends Cubit<ManufacturerState> {
  final ManufacturerRepository repository;

  ManufacturerCubit({ManufacturerRepository? repo})
    : repository = repo ?? ManufacturerRepository(),
      super(ManufacturerState(manufacturers: []));

  Future<void> loadListOfManufacturers({
    String? query,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final manufacturers = await repository.getListOfManufacturers(
        query: query,
      );

      manufacturers.sort((a, b) =>
          a.companyName.toLowerCase().compareTo(b.companyName.toLowerCase()));

      emit(state.copyWith(manufacturers: manufacturers, isLoading: false));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(manufacturers: [], isLoading: false));
    }
  }

  Future<void> getParticularAirbusDetail({
    required String query,
    required BuildContext context,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      status: CommonApiStatus.initial,
      errorMessage: null,
      apiError: null,
      isSuccess: false,
    ));

    try {
      final response = await repository.getParticularAirbusDetail(query: query);

      emit(state.copyWith(
        manufacturerDetail: response,
        isLoading: false,
        status: CommonApiStatus.success,
        isSuccess: true,
      ));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(state.copyWith(
        manufacturerDetail: null,
        isLoading: false,
        status: CommonApiStatus.failure,
        errorMessage: e.toString(),
        isSuccess: false,
      ));
    }
  }
}
