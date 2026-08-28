import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../../Helpers/AppNavigator.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_cubit.dart';
import '../../bloc/Profile/ConversionSection/conversion_cubit.dart';
import '../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../bloc/Profile/FormulaSection/formula_cubit.dart';
import '../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../../bloc/Profile/ProfileMain/profile_cubit.dart';
import '../../bloc/Profile/ProfileMain/profile_state.dart';
import '../../bloc/home/homeBloc/home_cubit.dart';
import '../Games/GamesSubScreens/JettingAroundTheWorld/JettingAroundBoardingPassesScreen.dart';
import 'ProfileMenuScreen/0_ScientificCalculator/screens/calculator_home_main_screen.dart';
import 'ProfileMenuScreen/1_UnitConversion/UnitConversionsScreen.dart';
import 'ProfileMenuScreen/2_FormulaSection/FormulaScreen.dart';
import 'ProfileMenuScreen/3_Glossary/GlossaryScreen.dart';
import 'ProfileMenuScreen/4_GameBadges/BadgesScreens.dart';
import 'ProfileMenuScreen/5_SavedFlights/SavedFlighScreen.dart';
import 'ProfileMenuScreen/7_AirplaneSection/AirplanePartsScreen.dart';
import 'ProfileMenuScreen/8_Sticker/AllMySticker/AllMyStickerScreen.dart';
import 'ProfileSettingsSectionHeader.dart';
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
  const ProfileScreen({super.key});

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
    setLocalData();
    homeCubit.fetchHomeData(context);
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  Future<void> setLocalData() async {
    final avatarUrl = await SharedPrefsHelper.getAvtarUserUrl();
    final name = await SharedPrefsHelper.getUserProfileName();

    if (!mounted) return;

    setState(() {
      userAvtarTypeUrl = avatarUrl;
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktopWeb = kIsWeb && width >= 900;
    Widget content = BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            // width: kIsWeb ? 1500 : double.infinity,
            // alignment: Alignment.center,
            // margin: kIsWeb
            //     ? const EdgeInsets.symmetric(horizontal: 50)
            //     : EdgeInsets.zero,
            width: isDesktopWeb ? 1500 : double.infinity,
            alignment: Alignment.center,
            margin: isDesktopWeb
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
                                    fit: BoxFit.contain,
                                    color:
                                        userAvtarTypeUrl.contains(
                                          "57ATSEPWhite.svg",
                                        )
                                        ? null
                                        : Colors.white,
                                    placeholderBuilder: (_) => SvgPicture.asset(
                                      CommonUi.setSvgImage(
                                        AssetsPath.manufacturerPlaceholder,
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    CommonUi.setSvgImage(
                                      AssetsPath.manufacturerPlaceholder,
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
                          const UnitConversionsScreen(),
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

                    // SettingsListItem(
                    //   leadingSvgAsset: CommonUi.setSvgImage(
                    //     AssetsPath.conversionProfile,
                    //   ),
                    //   title: "Unit Selection",
                    //   onTap: () {
                    //     AppNavigator.push(
                    //       context,
                    //       const UnitSelectionScreen(),
                    //       disableSwipeBack: true,
                    //     );
                    //   },
                    // ),
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
                      title: "My Badges",
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
                        AssetsPath.myAirplaneIcon,
                      ),
                      title: "My Airplane",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const AirplanePartsScreen(),
                          disableSwipeBack: true,
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.glossaryProfile,
                      ),
                      title: "My Stickers",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const AllMyStickerScreen(),
                          disableSwipeBack: true,
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.glossaryProfile,
                      ),
                      title: "My Boarding Passes",
                      onTap: () {
                        AppNavigator.push(
                          context,
                          const JettingAroundBoardingPassesScreen(
                            isComeFromResultScreen: false,
                          ),
                          multiBlocProviders: [
                            BlocProvider(
                              create: (_) => JettingBoardingPassCubit(),
                            ),
                          ],
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
              setLocalData();
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
