import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Constants/AppColors.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../../Helpers/AppNavigator.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';

import '../../bloc/home/homeBloc/home_cubit.dart';
import '../../bloc/Profile/ProfileMain/profile_cubit.dart';
import '../../bloc/Profile/ProfileMain/profile_state.dart';
import '../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../../bloc/Profile/FormulaSection/formula_cubit.dart';
import '../../bloc/Profile/ConversionSection/conversion_cubit.dart';

import '../Home/SavedFlights/SavedFlighScreen.dart';
import 'SettingsSectionHeader.dart';
import 'GameBadges/BadgesScreens.dart';
import 'Glossary/GlossaryScreen.dart';
import 'ScientificCalculator/screens/calculator_home_main_screen.dart';
import 'FormulaSection/FormulaScreen.dart';
import 'ConversionSection/ConversionScreen.dart';
import 'SettingScreen/SettingScreen.dart';

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeleteCubit(),
      child: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userAvtarTypeUrl = '';
  String userName = '';
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.profileScreen);
    homeCubit = HomeCubit();
    setLocalUserData();
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  Future<void> setLocalUserData() async {
    final userDetails = await homeCubit.fetchHomeData(context);
    if (userDetails != null) {
      setState(() {
        userAvtarTypeUrl = userDetails.userTypeUrl ?? '';
        userName = userDetails.firstName + userDetails.lastName;
      });
    }
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
                const SizedBox(height: 20),

                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue,
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: userAvtarTypeUrl.isNotEmpty
                                ? SvgPicture.network(
                                    userAvtarTypeUrl,
                                    color: Colors.white,
                                    fit: BoxFit.contain,
                                    placeholderBuilder: (_) => SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.manuFirstImage,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    CommonUi.setSvgImage(
                                      AssetsPath.manuFirstImage,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: AppTextStyles.bold(22).copyWith(
                          height: 1.0,
                          color: AppColors.primaryValueColour,
                        ),
                      ),
                    ],
                  ),
                ),

                SettingsListGroup(
                  headerTitle: "Learning Tools",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.calculatorProfile,
                      ),
                      title: "Calculator",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const CalculatorHomeMainScreen(),
                          disableSwipeBack: true,
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.conversionProfile,
                      ),
                      title: "Unit Conversions",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const ConversionsScreen(),
                          multiBlocProviders: [
                            BlocProvider(create: (_) => ConversionCubit()),
                          ],
                          disableSwipeBack: true,
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.formulasProfile,
                      ),
                      title: "Formulas",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const FormulasScreen(),
                          multiBlocProviders: [
                            BlocProvider(create: (_) => FormulaCubit()),
                          ],
                          disableSwipeBack: true,
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.glossaryProfile,
                      ),
                      title: "Glossary",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const GlossaryScreen(),
                          multiBlocProviders: [
                            BlocProvider(create: (_) => GlossaryCubit(context)),
                          ],
                          disableSwipeBack: true,
                        );
                      },
                    ),
                  ],
                ),

                SettingsListGroup(
                  headerTitle: "Your Progress",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.badgeProfile,
                      ),
                      title: "Badges",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const BadgesScreen(),
                          disableSwipeBack: true,
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.savedProfile,
                      ),
                      title: "Saved",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const SavedFlighScreen(showTabs: true),
                          disableSwipeBack: true,
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
          ),
          onPressed: () {},
        ),
        rightButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.homeRightSetting),
            width: 35,
            height: 31,
          ),
          onPressed: () async {
            final result = await AppNavigator.push(
              context,
              const SettingScreen(),
              disableSwipeBack: true,
            );
            if (result == true) {
              setLocalUserData();
            }
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
