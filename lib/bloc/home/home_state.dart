import 'home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ManufacturerHome> manufacturers;
  final List<Flight> flights;
  final List<Favourite> favourites;
  final int selectedIndex;

  HomeLoaded({
    required this.manufacturers,
    required this.flights,
    required this.favourites,
    this.selectedIndex = 0,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeTabChanged extends HomeState {
  final int index;
  HomeTabChanged(this.index);
}
