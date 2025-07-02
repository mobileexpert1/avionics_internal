import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'Constants/ApiClass/shared_prefs_helper.dart';
import 'Screens/Home/RootTabbar/RootTabbarScreen.dart';
import 'Screens/Onboarding/Splash/startExploringScreen.dart';

class RootDecider extends StatelessWidget {
  RootDecider({super.key});

  static final Future<bool?> _cachedLoginFuture =
  SharedPrefsHelper.getIsUserLogin();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: _cachedLoginFuture, // Only runs once
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          final isUserLoggedIn = snapshot.data ?? false;
          return isUserLoggedIn ? RootTabbarscreen() : LoginScreen();
        }
      },
    );
  }
}
