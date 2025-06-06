import 'package:avionics_internal/Onboarding/splash_screen.dart';
import 'package:avionics_internal/bloc/AircraftComparison/AircraftComparisonCubit.dart';
import 'package:avionics_internal/bloc/AircraftComparison/Comparison/ComparisonCubit.dart';
import 'package:avionics_internal/bloc/ChatBot/ChatCubit.dart';
import 'package:avionics_internal/bloc/Profile/ChangePassword/changePassword_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/bloc/Filter/filter_cubit.dart';
import 'package:avionics_internal/bloc/SavedFlighDetails/savedFlight_cubit.dart';
import 'package:avionics_internal/bloc/manufacturer/manufacturer_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'bloc/AirCraftDetail/airCraftDetail_cubit.dart';
import 'bloc/AllPlanes/AllPlanes_cubit.dart';
import 'bloc/Profile/Glossary/glossary_cubit.dart';
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
        BlocProvider(create: (_) => CreateNewPasswordCubit()),
        BlocProvider(create: (_) => ManufacturerCubit()),
        BlocProvider(create: (_) => FilterCubit()),
        BlocProvider(create: (_) => SavedFlightCubit()),
        BlocProvider(create: (_) => AllplanesCubit()),
        BlocProvider(create: (_) => AirCraftDetailCubit()),
        BlocProvider(create: (_) => ChatCubit()),
        BlocProvider(create: (_) => ProfileScreenCubit()),
        BlocProvider(create: (_) => ManageaccCubit()),
        BlocProvider(create: (_) => ChangePasswordCubit()),
        BlocProvider(create: (_) => AircraftComparisonCubit()),
        BlocProvider(create: (_) => GlossaryCubit()),
        BlocProvider(create: (_) => ComparisonCubit()),
      ],
      //Responsive test case
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Avionica',
            theme: ThemeData(primarySwatch: Colors.blue),
             home: SplashScreen(),
          );
        },
      ),
    );
  }
}
