import 'package:flutter_svg/svg.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../Helpers/AppText.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/home/homeBloc/home_cubit.dart';
import '../Avtar/AvtarScreen.dart';
import '../ContactSupportScreen/ContactSupportScreen.dart';
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
  late HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.settingScreen);
    _setLocalData();

    homeCubit = HomeCubit();
    homeCubit.fetchHomeData(context);
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  Future<void> _setLocalData() async {
    final avatarUrl = await SharedPrefsHelper.getAvtarUserUrl();
    final avatarType = await SharedPrefsHelper.getAvtarUserType();

    if (!mounted) return;

    setState(() {
      userAvtarTypeUrl = avatarUrl ?? '';
      avatarTypeName = avatarType ?? '';
    });
  }

  /// ---------------- COMMON NAVIGATION ----------------
  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
        _navigate(
          context,
          AvtarScreen(
            isComeFromSignupScreen: false,
            isComeFromSettingScreen: true,
            signupData: {},
          ),
        );
        _setLocalData();
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
                          color: Colors.white,
                          placeholderBuilder: (_) => SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.manuFirstImage),
                          ),
                        )
                      : SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.manuFirstImage),
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
    final content = BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (_, state) {
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
                      title: "Subscription",
                      onTap: () => _navigate(
                        context,
                        AppleSubscriptionScreen(isComeFromSignup: false),
                      ),
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
                  ],
                ),

                /// -------- HELP --------
                SettingsListGroup(
                  headerTitle: "Help & Feedback",
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
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

  /// ---------------- LOGOUT ----------------
  Future<void> _clearAllDataAndRedirectToSplashScreen(
    BuildContext context,
  ) async {
    try {
      await Purchases.logOut();
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
                  isComeFromLogout: isComeFromLogout,
                  onYes: () {
                    if (isComeFromLogout) {
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
