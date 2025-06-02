import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Onboarding/splash_screen.dart';
import 'bloc/home/home_cubit.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/signup/signup_cubit.dart';
import 'package:avionics_internal/bloc/forgotPassword/forgot_cubit.dart';
import 'package:avionics_internal/bloc/createNewPassword/createNewPassword_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignupCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => ForgotCubit()),
        BlocProvider(create: (_) => CreatenNewPasswordCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Avionica',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
      ),
    );
  }
}
