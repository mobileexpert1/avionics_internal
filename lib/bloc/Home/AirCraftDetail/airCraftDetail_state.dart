import 'airCraftDetail_model.dart';

abstract class AirCartState {}

class AirCartInitial extends AirCartState {}

class AirCartLoading extends AirCartState {}
class AirCartLoaded extends AirCartState {
  final Performance performance;
  final String detail;
  AirCartLoaded({
    required this.performance,
    required this.detail,
  });
}
class AirCartError extends AirCartState {
  final String message;
  AirCartError(this.message);
}
class AirCartTabChanged extends AirCartState {
  final int index;
  AirCartTabChanged(this.index);
}
 