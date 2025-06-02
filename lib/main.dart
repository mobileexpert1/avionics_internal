import 'package:avionics_internal/bloc/createNewPassword/createNewPassword_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Onboarding/splash_screen.dart';
import 'Subscription/SubscriptionScreen.dart';
import 'bloc/Subscription/subscription_cubit.dart';
import 'bloc/home/home_cubit.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/signup/signup_cubit.dart';
import 'package:avionics_internal/bloc/forgotPassword/forgot_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Avionica',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocProvider(
          create: (context) => SubscriptionCubit(),
          child: const SubscriptionScreen(),
        ),
      );
  }
}
