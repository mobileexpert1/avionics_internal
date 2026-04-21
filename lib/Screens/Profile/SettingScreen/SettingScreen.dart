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

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.settingScreen);
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

                  child: SettingsListItem(
                    leadingSvgAsset: CommonUi.setSvgImage(
                      AssetsPath.calculatorImage,
                    ),
                    title: "Avtar Image",
                    onTap: () {},
                  ),
                ),

                // USER Section
                SettingsListGroup(
                  headerTitle: "Manage Account",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.calculatorImage,
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
                        AssetsPath.conversionImage,
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
                        AssetsPath.unitMeasureAcc,
                      ),
                      title: "Logout",
                      onTap: () {
                        showDeleteConfirmation(context, true);
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.glossaryAcc,
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
                        AssetsPath.badgeIcon,
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
                        AssetsPath.conversionImage,
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
                        AssetsPath.savedIcon,
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
                        AssetsPath.badgeIcon,
                      ),
                      title: "Privacy Policy",
                      onTap: () {},
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.conversionImage,
                      ),
                      title: "Terms of Service",
                      onTap: () {},
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.savedIcon,
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
