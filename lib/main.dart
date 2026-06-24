import 'package:avionics_internal/Screens/Onboarding/Splash/splash_screen.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackbox_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_cubit.dart';
import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import 'package:avionics_internal/bloc/MapSection/flight_Map_Cubit.dart';
import 'package:avionics_internal/bloc/Profile/ChangePassword/changePassword_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Constants/ApiClass/shared_prefs_helper.dart';
import 'Database/db_helper.dart';
import 'Helpers/Firebase_Options.dart';
import 'Helpers/push_notifications/LocalNotificationHelper.dart';
import 'Helpers/push_notifications/firebase_message_handler.dart';
import 'Helpers/push_notifications/firebase_messaging_service.dart';
import 'Screens/Profile/ProfileMenuScreen/0_ScientificCalculator/providers/calculations.dart';
import 'Screens/Profile/ProfileMenuScreen/0_ScientificCalculator/providers/history.dart';
import 'Screens/Profile/SettingScreen/SettingMenuScreen/5_6_AllDemoScreen/FlightLog/AircraftCategoryCubit.dart';
import 'Screens/Profile/SettingScreen/SettingMenuScreen/5_6_AllDemoScreen/FlightStickers/StickerCubit.dart';
import 'bloc/Games/MainGameSection/game_cubit.dart';
import 'bloc/Home/AirCraftDetail/airCraftDetail_cubit.dart';
import 'bloc/Home/AircraftComparison/AircraftComparisonCubit.dart';
import 'bloc/Home/AircraftComparison/Comparison/ComparisonCubit.dart';
import 'bloc/Home/manufacturer/manufacturer_cubit.dart';
import 'bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_cubit.dart';
import 'bloc/Onboarding/Subscription/SubscriptionBuyPlan/SubscriptionBuyPlanCubit.dart';
import 'bloc/Onboarding/forgotPassword/forgot_cubit.dart';
import 'bloc/Onboarding/login/login_cubit.dart';
import 'bloc/Onboarding/signup/signup_cubit.dart';
import 'bloc/Profile/Avtar/avtar_cubit.dart';
import 'bloc/Profile/Glossary/glossary_cubit.dart';
import 'bloc/Profile/MySubscription/my_subscription_cubit.dart';
import 'bloc/Profile/UnitSelection/unit_selection_cubit.dart';
import 'bloc/Profile/createNewPassword/createNewPassword_cubit.dart';
import 'bloc/home/AircraftComparison/Comparison/Filter/ComparisonFilterCubit.dart';
import 'bloc/home/SavedFlighDetails/savedFlight_cubit.dart';
import 'bloc/home/chatSection/ChatHistory/chat_history_cubit.dart';
import 'bloc/home/homeBloc/home_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await LocalNotificationHelper.init();
  }
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
  );

  await FlutterUxcam.optIntoSchematicRecordings();

  FlutterUxcam.startWithKey(
    "atxeju4thavoohu-us",
  );


  print("UXCam Initialized----");

  FirebaseMessagingService().initialize(navigatorKey: navigatorKey);
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };
  }

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (!kIsWeb) {
    await printDbPath();
    await DBHelper.database;
  }
  SharedPrefsHelper.removeTempKeyBeforeLaunch();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        BlocProvider(create: (_) => SavedFlightCubit()),
        BlocProvider(create: (_) => AllPlanesCubit()),
        BlocProvider(create: (_) => AirCraftDetailCubit()),
        BlocProvider(create: (_) => ProfileScreenCubit()),
        BlocProvider(create: (_) => ManageaccCubit()),
        BlocProvider(create: (_) => ChangePasswordCubit()),
        BlocProvider(create: (_) => AircraftComparisonCubit()),
        BlocProvider(create: (_) => GlossaryCubit(context)),
        BlocProvider(create: (_) => UnitSelectionCubit(context)),
        BlocProvider(create: (_) => AvtarCubit()),
        BlocProvider(create: (_) => ComparisonCubit()),
        BlocProvider(create: (_) => ChatHistoryCubit()),
        BlocProvider(create: (_) => SubscriptionBuyPlanCubit()),
        BlocProvider(create: (_) => GamesCubit()),
        BlocProvider(create: (_) => QuizCubit()),
        BlocProvider(create: (_) => ComparisonFilterCubit1()),
        BlocProvider(create: (_) => MapSearchAircraftListCubit()),
        BlocProvider(create: (_) => BlackboxCubit()),
        BlocProvider(create: (_) => FlightMapCubit()),
        ChangeNotifierProvider(create: (_) => Calculations()),
        ChangeNotifierProvider(create: (_) => History()),
        BlocProvider(create: (_) => MySubscriptionCubit()),
        BlocProvider(create: (_) => StickerCubit()),
        BlocProvider(create: (_) => AircraftCategoryCubit()),

      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Avioflai',
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Outfit'),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
