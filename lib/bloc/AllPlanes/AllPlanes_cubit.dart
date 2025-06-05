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
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
    ];


    emit(state.copyWith(AllPlanes: allplanesModel, isLoading: false));
  }
}
