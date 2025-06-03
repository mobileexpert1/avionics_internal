import 'manufacturer_model.dart';

class ManufacturerState {
  final List<Manufacturer> manufacturers;
  final bool isLoading;

  ManufacturerState({required this.manufacturers, this.isLoading = false});

  ManufacturerState copyWith({
    List<Manufacturer>? manufacturers,
    bool? isLoading,
  }) {
    return ManufacturerState(
      manufacturers: manufacturers ?? this.manufacturers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
