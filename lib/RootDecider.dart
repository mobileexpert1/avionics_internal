import 'package:avionics_internal/Home/RootTabbar/RootTabbarScreen.dart';
import 'package:flutter/material.dart';

import 'Constants/ApiClass/shared_prefs_helper.dart';
import 'Home/HomeScreen.dart';
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
          return isUserLoggedIn ? RootTabbarscreen() : StartExploringScreen();
        }
      },
    );
  }
}
