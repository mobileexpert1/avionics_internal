import 'package:avionics_internal/Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Screens/Onboarding/Subscription/AppleSubscription/AppleSubscriptionScreen.dart';
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
      if (data.isActiveSubscription == false) {
        await SharedPrefsHelper.saveApiFetchKeyFromSever(true);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => (defaultTargetPlatform == TargetPlatform.iOS
                ? AppleSubscriptionScreen(isComeFromSignup: true)
                : AppleSubscriptionScreen(
                    isComeFromSignup: true,
                    isComeFromSocialLogin: true,
                  )),
          ),
        );
        return;
      } else {
        await SharedPrefsHelper.saveApiFetchKeyFromSever(false);
        final top2Manufacturers = data.manufacturers.take(2).toList();
        emit(
          HomeLoaded(
            manufacturers: top2Manufacturers,
            flights: data.flights,
            favourites: data.favourites,
            detail: data.detail,
            isActiveSubscription: data.isActiveSubscription,
            selectedIndex: _selectedIndex,
          ),
        );
      }
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
          isActiveSubscription: currentState.isActiveSubscription,
          detail: currentState.detail,
        ),
      );
    } else {
      emit(HomeTabChanged(index));
    }
  }
}
