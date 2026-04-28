import 'package:flutter_svg/svg.dart';

import '../../../Helpers/AppText.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../Avtar/AvtarScreen.dart';
import '../Feedback/FeedbackScreen.dart';
import '../ManageAccount/ManageAccountScreen.dart';
import '../ProfileScreen.dart';
import '../SettingsSectionHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../Constants/AppColors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../Onboarding/Login/LoginScreen.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../bloc/Profile/ProfileMain/profile_state.dart';
import '../../../bloc/Profile/ProfileMain/profile_cubit.dart';
import '../../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../../bloc/Profile/DeleteProfile/delete_state.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Onboarding/Subscription/AppleSubscription/AppleSubscriptionScreen.dart';
import '../VideoPlayer/VideoPlayerScreen.dart';
import 'InfoBottomSheet.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userAvtarTypeUrl = '';
  String avatarTypeName = '';

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.settingScreen);
    setLocalData();
  }

  Future<void> setLocalData() async {
    final avatarUrl = await SharedPrefsHelper.getAvtarUserUrl();
    final avatarType = await SharedPrefsHelper.getAvtarUserType();

    setState(() {
      userAvtarTypeUrl = avatarUrl ?? '';
      avatarTypeName = avatarType ?? '';
    });
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
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 10.0),

                  child: Text(
                    "Manage Account",
                    style: AppTextStyles.bold(20).copyWith(
                      height: 1.0,
                      color: AppColors.primaryValueColour,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.dividerLineColourForComparison,
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvtarScreen(
                            isComeFromSignupScreen: false,
                            isComeFromSettingScreen: true,
                            signupData: {},
                          ),
                        ),
                      ).then((value) {
                        setLocalData();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 15.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
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
                                        color: Colors.white,
                                        placeholderBuilder: (context) =>
                                            SvgPicture.asset(
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
                          const SizedBox(width: 16),
                          if (userAvtarTypeUrl.isNotEmpty)
                            Expanded(
                              child: Text(
                                avatarTypeName
                                    .toUpperCase()
                                    .replaceAll("_", " ")
                                    .capitalize(),
                                style: AppTextStyles.regular(20).copyWith(
                                  height: 1.0,
                                  color: AppColors.primaryValueColour,
                                ),
                              ),
                            ),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // USER Section
                SettingsListGroup(
                  headerTitle: "",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.manageAccountProfile,
                      ),
                      title: "Personal Data",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageAccountScreen(),
                          ),
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.subscriptionProfile,
                      ),
                      title: "Subscription",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                (defaultTargetPlatform == TargetPlatform.iOS
                                ? AppleSubscriptionScreen(
                                    isComeFromSignup: false,
                                  )
                                : AppleSubscriptionScreen(
                                    isComeFromSignup: false,
                                  )),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.logoutProfile,
                      ),
                      title: "Logout",
                      onTap: () {
                        showDeleteConfirmation(context, true);
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.deleteProfile,
                      ),
                      title: "Delete Account",
                      onTap: () {
                        showDeleteConfirmation(context, false);
                      },
                    ),
                  ],
                ),

                // USER Section
                SettingsListGroup(
                  headerTitle: "Help & Feedback",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.tutorialVideoProfile,
                      ),
                      title: "Tutorial",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.reviewsProfile,
                      ),
                      title: "Review",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackScreen(),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.customerSupportProfile,
                      ),
                      title: "Customer Support",
                      onTap: () {},
                    ),
                  ],
                ),

                SettingsListGroup(
                  headerTitle: "Legal & App Info",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.privacyPolicyProfile,
                      ),
                      title: "Privacy Policy",
                      onTap: () {},
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.termsAndConditionsProfile,
                      ),
                      title: "Terms of Service",
                      onTap: () {},
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.aboutProfile,
                      ),
                      title: "About",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
                        svgAsset: CommonUi.setSvgImage(AssetsPath.signinIcon),
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
