import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'Constants/ApiClass/shared_prefs_helper.dart';
import 'Screens/Home/RootTabbar/RootTabbarScreen.dart';
import 'Screens/Onboarding/Splash/startExploringScreen.dart';

class RootDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: SharedPrefsHelper.getIsUserLogin(),
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
