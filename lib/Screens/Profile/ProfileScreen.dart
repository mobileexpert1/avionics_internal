import 'package:avionics_internal/Screens/Profile/SettingScreen/SettingScreen.dart';

import '../../Constants/AppColors.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import 'GameBadges/BadgesScreens.dart';
import 'Glossary/GlossaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Home/SavedFlights/SavedFlighScreen.dart';
import '../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../bloc/Profile/DeleteProfile/delete_state.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import 'ScientificCalculator/screens/calculator_home_main_screen.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_state.dart';
import 'package:avionics_internal/bloc/Profile/FormulaSection/formula_cubit.dart';
import 'package:avionics_internal/Screens/Profile/FormulaSection/FormulaScreen.dart';
import 'package:avionics_internal/bloc/Profile/ConversionSection/conversion_cubit.dart';
import 'package:avionics_internal/Screens/Profile/ConversionSection/ConversionScreen.dart';

import 'SettingsSectionHeader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return BlocProvider<DeleteCubit>(
      create: (_) => DeleteCubit(),
      child: ProfileScreen(),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.profileScreen);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            width: kIsWeb ? 1500 : double.infinity,
            alignment: Alignment.center,
            margin: kIsWeb
                ? const EdgeInsets.symmetric(horizontal: 50)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.manuFirstImage),
                        width: 90,
                        height: 90,
                      ),
                      SizedBox(height: 20),

                      Text(
                        "223",
                        style: AppTextStyles.bold(22).copyWith(
                          height: 1.0,
                          color: AppColors.primaryValueColour,
                        ),
                      ),
                    ],
                  ),
                ),

                // USER Section
                SettingsListGroup(
                  headerTitle: "Learning Tools",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.calculatorImage,
                      ),
                      title: "Calculator",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalculatorHomeMainScreen(),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.conversionImage,
                      ),
                      title: "Unit Conversions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => ConversionCubit(),
                              child: ConversionsScreen(),
                            ),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.unitMeasureAcc,
                      ),
                      title: "Formulas",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => FormulaCubit(),
                              child: FormulasScreen(),
                            ),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.glossaryAcc,
                      ),
                      title: "Glossary",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => GlossaryCubit(context),
                              child: const GlossaryScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // USER Section
                SettingsListGroup(
                  headerTitle: "Your Progress",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.badgeIcon,
                      ),
                      title: "Badges",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BadgesScreen(),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.conversionImage,
                      ),
                      title: "Progress / Stats",
                      onTap: () {},
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.savedIcon,
                      ),
                      title: "Saved",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SavedFlighScreen(showTabs: true),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isForHomeScreen: true,
        title: '',
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.homeLeftMainLogo),
            width: 120,
            height: 31,
            fit: BoxFit.cover,
          ),
          onPressed: () {},
        ),
        rightButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.homeRightSetting),
            width: 35,
            height: 31,
            fit: BoxFit.cover,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
        ),
      ),
      body: kIsWeb
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: content,
              ),
            )
          : content,
    );
  }

  Future<void> _clearAllDataAndRedirectToSplashScreen(
    BuildContext context,
  ) async {
    await SharedPrefsHelper.clearAll([], false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  void showDeleteConfirmation(
    BuildContext bottomSheetContext,
    isComeFromLogout,
  ) {
    showModalBottomSheet(
      context: bottomSheetContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider<DeleteCubit>(
          create: (_) => DeleteCubit(),
          child: BlocListener<DeleteCubit, DeleteState>(
            listener: (listenerContext, state) async {
              if (state.isSuccess) {
                Navigator.pop(bottomSheetContext);
                await _clearAllDataAndRedirectToSplashScreen(
                  bottomSheetContext,
                );
              } else if (state.errorMessage.isNotEmpty) {
                Navigator.pop(bottomSheetContext);
                ScaffoldMessenger.of(
                  bottomSheetContext,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            child: Builder(
              builder: (innerContext) {
                return InfoBottomSheet(
                  isComeFromLogout: isComeFromLogout,
                  onYes: () {
                    if (isComeFromLogout == true) {
                      AppSnackBar.custom(
                        context,
                        message: 'Logged out',
                        svgAsset: CommonUi.setSvgImage(AssetsPath.logoutIcon),
                      );
                      _clearAllDataAndRedirectToSplashScreen(context);
                      AnalyticsService.instance.buttonPressed(
                        FirebaseEvents.logoutPressedButton,
                        FirebaseEvents.profileScreen,
                      );
                    } else {
                      innerContext.read<DeleteCubit>().delete(context);
                      AnalyticsService.instance.buttonPressed(
                        FirebaseEvents.deleteAccountButton,
                        FirebaseEvents.profileScreen,
                      );
                    }
                  },
                  onNo: () => Navigator.pop(innerContext),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class InfoBottomSheet extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final bool isComeFromLogout;

  const InfoBottomSheet({
    super.key,
    required this.onYes,
    required this.onNo,
    required this.isComeFromLogout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 500
            ? 500
            : constraints.maxWidth;

        Widget content = Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isComeFromLogout
                    ? "Are you sure you want to logout?"
                    : "Do you want to delete your account?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onYes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F3D51),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: onNo,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAEAEA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: Color(0xFF3F3D51),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        // Web -> Center, Mobile -> Bottom
        return kIsWeb
            ? Center(child: content)
            : Align(alignment: Alignment.bottomCenter, child: content);
      },
    );
  }
}
