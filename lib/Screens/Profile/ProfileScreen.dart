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
                        AssetsPath.calculatorProfile,

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
                        AssetsPath.conversionProfile,
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
                        AssetsPath.formulasProfile,
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
                        AssetsPath.glossaryProfile,
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
                        AssetsPath.badgeProfile,
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
                        AssetsPath.progressProfile,
                      ),
                      title: "Progress / Stats",
                      onTap: () {},
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.savedProfile,
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
}
