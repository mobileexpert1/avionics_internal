import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../../bloc/Profile/DeleteProfile/delete_state.dart';
import '../../../bloc/Profile/ProfileMain/profile_cubit.dart';
import '../../../bloc/Profile/ProfileMain/profile_state.dart';
import '../../../bloc/home/homeBloc/home_cubit.dart';
import '../../Onboarding/Login/LoginScreen.dart';
import '../ProfileSettingsSectionHeader.dart';
import 'InfoBottomSheet.dart';
import 'SettingMenuScreen/0_Avtar/AvtarScreen.dart';
import 'SettingMenuScreen/10_13_AboutTermsPrivacyFaq/AboutTermsPrivacyScreen.dart';
import 'SettingMenuScreen/1_PersonalData/ManageAccountScreen.dart';
import 'SettingMenuScreen/2_MySubscription/MySubscriptionScreen.dart';
import 'SettingMenuScreen/5_6_AllDemoScreen/GoogleEarthMap/GoogleEarthMap.dart';
import 'SettingMenuScreen/7_TutorialScreen/VideoPlayerScreen.dart';
import 'SettingMenuScreen/8_Review/FeedbackScreen.dart';
import 'SettingMenuScreen/9_ContactSupport/ContactSupportScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});


  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userAvtarTypeUrl = '';
  String avatarTypeName = '';
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.settingScreen);
    homeCubit = HomeCubit();
    homeCubit.fetchHomeData(context);
    setLocalData();
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  Future<void> setLocalData() async {
    final avatarUrl = await SharedPrefsHelper.getAvtarUserUrl();
    final name = await SharedPrefsHelper.getAvtarUserType();

    if (!mounted) return;

    setState(() {
      userAvtarTypeUrl = avatarUrl;
      switch (name.toLowerCase()) {
        case 'student':
          avatarTypeName = "Student";
          break;
        case 'atco':
          avatarTypeName = "ATCO";
          break;
        case 'pilot':
          avatarTypeName = "Pilot";
          break;
        case 'enthusiast':
          avatarTypeName = "Enthusiast";
          break;
        case 'aircraft_engineer':
          avatarTypeName = "Aircraft Engineer";
          break;
        default:
          avatarTypeName = "ATSEP";
          break;
      }
    });
  }

  /// ---------------- COMMON NAVIGATION ----------------
  void _navigate(BuildContext context, Widget screen) {
    AppNavigator.push(context, screen, disableSwipeBack: true);
  }

  /// ---------------- COMMON TILE DECORATION ----------------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColors.dividerLineColourForComparison,
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// ---------------- AVATAR WIDGET ----------------
  Widget _avatarWidget() {
    return InkWell(
      onTap: () async {
        final result = await AppNavigator.push(
          context,
          AvtarScreen(
            isComeFromSignupScreen: false,
            isComeFromSettingScreen: true,
            signupData: {},
          ),
          disableSwipeBack: true,
        );

        if (result == true) {
          setLocalData();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: userAvtarTypeUrl.isNotEmpty
                      ? SvgPicture.network(
                          userAvtarTypeUrl,
                          fit: BoxFit.contain,
                          color: userAvtarTypeUrl.contains("57ATSEPWhite.svg")
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
            const SizedBox(width: 16),
            if (userAvtarTypeUrl.isNotEmpty)
              Expanded(
                child: Text(
                  avatarTypeName,
                  style: AppTextStyles.regular(
                    20,
                  ).copyWith(height: 1, color: AppColors.primaryValueColour),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktopWeb = kIsWeb && width >= 900;
    final content = BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (_, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            width: isDesktopWeb  ? 1500 : double.infinity,
            alignment: Alignment.center,
            margin: isDesktopWeb
                ? const EdgeInsets.symmetric(horizontal: 50)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -------- HEADER --------
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 0, 10),
                  child: Text(
                    "Manage Account",
                    style: AppTextStyles.bold(
                      20,
                    ).copyWith(height: 1, color: AppColors.primaryValueColour),
                  ),
                ),

                /// -------- AVATAR CARD --------
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: _cardDecoration(),
                  child: _avatarWidget(),
                ),

                /// -------- USER --------
                SettingsListGroup(
                  headerTitle: "",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.manageAccountProfile,
                      ),
                      title: "Personal Data",
                      onTap: () =>
                          _navigate(context, const ManageAccountScreen()),
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.subscriptionProfile,
                      ),
                      title: "My Subscription",
                      onTap: () => _navigate(context, MySubscriptionScreen()),
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.logoutProfile,
                      ),
                      title: "Logout",
                      onTap: () => showDeleteConfirmation(context, true),
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.deleteProfile,
                      ),
                      title: "Delete Account",
                      onTap: () => showDeleteConfirmation(context, false),
                    ),

                    // SettingsListItem(
                    //   leadingSvgAsset: CommonUi.setSvgImage(
                    //     AssetsPath.customerSupportProfile,
                    //   ),
                    //   title: "3D Animation",
                    //   onTap: () => _navigate(context, ModelTestScreen()),
                    // ),
                    // SettingsListItem(
                    //   leadingSvgAsset: CommonUi.setSvgImage(
                    //     AssetsPath.glossaryProfile,
                    //   ),
                    //   title: "Flight Stickers",
                    //   onTap: () {
                    //     AppNavigator.push(
                    //       context,
                    //       const AircraftCategoryScreen(),
                    //       disableSwipeBack: true,
                    //     );
                    //   },
                    // ),
                    //
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.manageAccountProfile,
                      ),
                      title: "Google Earth Map",
                      onTap: () => _navigate(context, GoogleEarthMap()),
                    ),
                  ],
                ),

                /// -------- HELP --------
                SettingsListGroup(
                  headerTitle: "Help & Review",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.tutorialVideoProfile,
                      ),
                      title: "Tutorial",
                      onTap: () => _navigate(context, VideoPlayerScreen()),
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.reviewsProfile,
                      ),
                      title: "Review",
                      onTap: () => _navigate(context, FeedbackScreen()),
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.customerSupportProfile,
                      ),
                      title: "Customer Support",
                      onTap: () => _navigate(context, ContactSupportScreen()),
                    ),
                  ],
                ),

                /// -------- LEGAL --------
                SettingsListGroup(
                  headerTitle: "Legal & App Info",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.privacyPolicyProfile,
                      ),
                      title: "Privacy Policy",
                      onTap: () {
                        _navigate(
                          context,
                          AboutTermsPrivacyScreen(urlForRequest: 0),
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.termsAndConditionsProfile,
                      ),
                      title: "Terms of Service",
                      onTap: () {
                        _navigate(
                          context,
                          AboutTermsPrivacyScreen(urlForRequest: 1),
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.aboutProfile,
                      ),
                      title: "About",
                      onTap: () {
                        _navigate(
                          context,
                          AboutTermsPrivacyScreen(urlForRequest: 2),
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.aboutProfile,
                      ),
                      title: "FAQ",
                      onTap: () {
                        _navigate(
                          context,
                          AboutTermsPrivacyScreen(urlForRequest: 3),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// -------- VERSION --------
                Center(
                  child: Text(
                    "AvioflAI App ver 1.0 (10)",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.settingScreen,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: isDesktopWeb
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: content,
              ),
            )
          : content,
    );
  }

  /// ---------------- LOGOUT ----------------
  Future<void> _clearAllDataAndRedirectToSplashScreen(
    BuildContext context,
  ) async {
    try {
      // try {
      //   final info = await Purchases.getCustomerInfo();
      //   if (info.originalAppUserId != "") {
      //     await Purchases.logOut();
      //   }
      // } catch (e) {
      //   debugPrint("RevenueCat not configured yet: $e");
      // }
      await SharedPrefsHelper.clearAll([], false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (_) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ---------------- DELETE / LOGOUT SHEET ----------------
  void showDeleteConfirmation(
    BuildContext bottomSheetContext,
    bool isComeFromLogout,
  ) {
    showModalBottomSheet(
      context: bottomSheetContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider(
          create: (_) => DeleteCubit(),
          child: BlocListener<DeleteCubit, DeleteState>(
            listener: (ctx, state) async {
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
                  isComeFromSubscription: false,
                  isComeFromLogout: isComeFromLogout,
                  onYes: () {
                    if (isComeFromLogout) {
                      AppSnackBar.custom(
                        context,
                        message: 'Logged out',
                        svgAsset: CommonUi.setSvgImage(
                          AssetsPath.signInIconForAlert,
                        ),
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
