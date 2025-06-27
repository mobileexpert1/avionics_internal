import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/bloc/AllPlanes/AllPlanes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'AllPlanes_model.dart';



class AllplanesCubit extends Cubit<AllplanesState> {
  AllplanesCubit() : super(AllplanesState(AllPlanes: []));

  void loadAirbusModels() {
    emit(state.copyWith(isLoading: true));

    // Mock data
    final List<AllplanesModel> allplanesModel = [
      AllplanesModel(name: 'A-320-neo', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320-neo', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320-neo', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-CJ320-neo', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-321-neo', code: 'A310', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-300-neo', code: 'A530', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-220-600', code: 'A540', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-220-300', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320-neo', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
    ];

    emit(state.copyWith(AllPlanes: allplanesModel, isLoading: false));
  }
}
