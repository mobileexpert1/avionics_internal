import 'package:avionics_internal/Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Screens/Onboarding/Login/LoginScreen.dart';
import 'home_state.dart';
import 'home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository = HomeRepository();
  int _selectedIndex = 0;

  HomeCubit() : super(HomeInitial());

  int get selectedIndex => _selectedIndex;

  Future<void> fetchHomeData(BuildContext context) async {
    emit(HomeLoading());

    try {
      final data = await repository.getHomeData();

      emit(
        HomeLoaded(
          manufacturers: data.manufacturers,
          flights: data.flights,
          favourites: data.favourites,
          selectedIndex: _selectedIndex,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(HomeError(e.toString()));
    }
  }

  void setTabIndex(int index) {
    _selectedIndex = index;

    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(
        HomeLoaded(
          manufacturers: currentState.manufacturers,
          flights: currentState.flights,
          favourites: currentState.favourites,
          selectedIndex: index,
        ),
      );
    } else {
      emit(HomeTabChanged(index));
    }
  }
}
