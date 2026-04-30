import 'package:avionics_internal/Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Helpers/CreditManager/CreditManager.dart';
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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => (defaultTargetPlatform == TargetPlatform.iOS
                ? AppleSubscriptionScreen(isComeFromSignup: true)
                : AppleSubscriptionScreen(
              isComeFromSignup: true,
              isComeFromSocialLogin: true,
            )),
          ),
              (route) => false,
        );
        return;
      } else {
        final top2Manufacturers = data.manufacturers.take(2).toList();
        if (data.currentPlan != null) {
          CreditManager().initialize(data.currentPlan!);
        }
        emit(
          HomeLoaded(
            manufacturers: top2Manufacturers,
            flights: data.flights,
            favourites: data.favourites,
            detail: data.detail,
            isActiveSubscription: data.isActiveSubscription,
            currentPlan: data.currentPlan,
            selectedIndex: _selectedIndex,
          ),
        );
      }
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains("unauthorized") ||
          errorMessage.contains("401")) {
        emit(HomeError("Session expired. Please login again."));
      } else {
        emit(HomeError(e.toString()));
      }
    }
  }
}
