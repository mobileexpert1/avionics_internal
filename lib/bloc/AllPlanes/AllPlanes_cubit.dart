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
      AllplanesModel(name: 'A-319-neo', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-CJ319-neo', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320-neo', code: 'A20N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-320', code: 'A320', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-CJ320-neo', code: 'A20N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-321-neo', code: 'A21N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-300-600', code: 'A306', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-220-300', code: 'BCS3', image:CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-220-100', code: 'BCS1', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-400-M', code: 'A400', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-300-600-ST', code: 'A3ST', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-350-1000', code: 'A359', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-330-800', code: 'A338', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-340-200', code: 'A342', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
      AllplanesModel(name: 'A-319-neo', code: 'A19N', image: CommonUi.setPngImage(AssetsPath.aeroplaneComparison)),
    ];


    emit(state.copyWith(AllPlanes: allplanesModel, isLoading: false));
  }
}
