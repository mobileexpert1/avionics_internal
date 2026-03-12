import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:avionics_internal/Screens/Profile/ConversionSection/ConversionScreen.dart';
import 'package:avionics_internal/Screens/Profile/FormulaSection/FormulaScreen.dart';
import 'package:avionics_internal/Screens/Profile/GoogleEarthMap/GoogleEarthMap.dart';
import 'package:avionics_internal/Screens/Profile/TestColourScreen.dart';
import 'package:avionics_internal/Screens/Profile/VideoPlayer/VideoPlayerScreen.dart';
import 'package:avionics_internal/bloc/Profile/ConversionSection/conversion_cubit.dart';
import 'package:avionics_internal/bloc/Profile/FormulaSection/formula_cubit.dart';
import 'package:flutter/foundation.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../Helpers/push_notifications/LocalNotificationHelper.dart';
import '../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../bloc/Profile/DeleteProfile/delete_state.dart';
import '../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../Home/SavedFlights/SavedFlighScreen.dart';
import '../Onboarding/Subscription/AppleSubscription/AppleSubscriptionScreen.dart';
import 'Avtar/AvtarScreen.dart';
import 'Feedback/FeedbackScreen.dart';
import 'GameBadges/BadgesScreens.dart';
import 'Glossary/GlossaryScreen.dart';
import 'package:flutter/material.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Constants/ConstantStrings.dart';
import 'ManageAccount/ManageAccountScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ContactSupportScreen/ContactSupportScreen.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_state.dart';

import 'ScientificCalculator/screens/calculator_home_main_screen.dart';

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
            width: kIsWeb ? 1500 : double.infinity, // 💡 Box constraint for web
            alignment: Alignment.center,
            margin: kIsWeb
                ? const EdgeInsets.symmetric(horizontal: 50)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USER Section
                SettingsListGroup(
                  headerTitle: "USER",
                  items: [
                    SettingsListItem(
                      title: "Manage Your Account",
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.manageAccountAcc,
                      ),
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
                        AssetsPath.subsrcitAcc,
                      ),
                      leadingIconColor: Colors.blue,
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
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.savedIcon,
                      ),
                      title: "Test Colour Screen ",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestColourScreen(),
                          ),
                        );
                      },
                    ),

                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.savedIcon,
                      ),
                      title: "Google Earth Map Screen ",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoogleEarthMap(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // INTERFACE Section
                SettingsListGroup(
                  headerTitle: "INTERFACE",
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.avtarAcc,
                      ),
                      title: "Avatar",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvtarScreen(
                              isComeFromSignupScreen: false,
                              signupData: {},
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
                      title: "Conversions",
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
                  ],
                ),

                // REFERENCES Section
                SettingsListGroup(
                  headerTitle: "REFERENCES",
                  items: [
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

                // FEEDBACK Section
                SettingsListGroup(
                  headerTitle: "FEEDBACK",
                  showBottomDivider: false,
                  items: [
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.tutorialVideo,
                      ),
                      title: "Tutorial Screen",
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
                        AssetsPath.reviewsAcc,
                      ),
                      title: "Write Review",
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
                        AssetsPath.contactAcc,
                      ),
                      title: "Contact Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactSupportScreen(),
                          ),
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.deleteAcc,
                      ),
                      title: "Logout",
                      onTap: () {
                        showDeleteConfirmation(context, true);
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.deleteAccSvg,
                      ),
                      title: "Delete account",
                      onTap: () {
                        showDeleteConfirmation(context, false);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "AvioflAI App ver 1.0 (8)",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: ConstantStrings.profileTitle),
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

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const SettingsSectionHeader({Key? key, required this.title, this.textStyle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 10.0, 10.0),
      child: Text(
        title,
        style:
            textStyle ??
            TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
      ),
    );
  }
}

class SettingsListItem extends StatelessWidget {
  final String? leadingSvgAsset;
  final String title;
  final VoidCallback? onTap;
  final Color? leadingIconColor;

  const SettingsListItem({
    Key? key,
    this.leadingSvgAsset,
    required this.title,
    this.onTap,
    this.leadingIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            SvgPicture.asset(leadingSvgAsset!),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

class SettingsListGroup extends StatelessWidget {
  final String headerTitle;
  final TextStyle? headerTextStyle;
  final List<SettingsListItem> items;
  final bool showTopDivider;
  final bool showBottomDivider;

  const SettingsListGroup({
    Key? key,
    required this.headerTitle,
    this.headerTextStyle,
    required this.items,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: headerTitle, textStyle: headerTextStyle),
        if (showTopDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          ),
        ...items,
        if (showBottomDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          ),
      ],
    );
  }
}
