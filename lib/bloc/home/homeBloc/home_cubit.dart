import 'package:avionics_internal/Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'package:avionics_internal/bloc/home/homeBloc/home_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Helpers/CreditManager/CreditManager.dart';
import '../../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import 'home_state.dart';
import 'home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository = HomeRepository();
  final int _selectedIndex = 0;

  HomeCubit() : super(HomeInitial());

  int get selectedIndex => _selectedIndex;

  Future<UserDetails?> fetchHomeData(BuildContext context) async {
    emit(HomeLoading());
    try {
      final data = await repository.getHomeData();
      if (data.isActiveSubscription == false) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                SubscriptionPlanDetailScreen(isComeFromSignup: true),
          ),
          (_) => false,
        );
        return null;
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
      return data.userDetails;
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains("unauthorized") ||
          errorMessage.contains("401")) {
        if (!isClosed) {
          emit(HomeError("Session expired. Please login again."));
        }
      } else {
        if (!isClosed) {
          if (e.toString().contains("Handshake error")){
            emit(HomeError("Something went wrong. Please check after sometime."));
          }else{
            emit(HomeError(e.toString()));
          }
        }
      }
    }
    return null;
  }
}
