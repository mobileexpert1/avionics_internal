

import 'package:avionics_internal/bloc/AllPlanes/AllPlanes_model.dart';

class AllplanesState {
  final List<AllplanesModel> AllPlanes;
  final bool isLoading;

  AllplanesState({required this.AllPlanes, this.isLoading = false});

  AllplanesState copyWith({
    List<AllplanesModel>? AllPlanes,
    bool? isLoading,
  }) {
    return AllplanesState(
      AllPlanes: AllPlanes ?? this.AllPlanes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
