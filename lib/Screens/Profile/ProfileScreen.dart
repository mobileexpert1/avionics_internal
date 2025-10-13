import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../bloc/Profile/DeleteProfile/delete_cubit.dart';
import '../../bloc/Profile/DeleteProfile/delete_state.dart';
import '../../bloc/Profile/Glossary/glossary_cubit.dart';
import '../../bloc/Profile/UnitSelection/unit_selection_cubit.dart';
import '../Onboarding/Subscription/AppleSubscription/AppleSubscriptionScreen.dart';
import 'Avtar/AvtarScreen.dart';
import 'Feedback/FeedbackScreen.dart';
import 'GameBadges/BadgesScreens.dart';
import 'Glossary/GlossaryScreen.dart';
import 'package:flutter/material.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import 'UnitSettings/UnitSettingsScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Constants/ConstantStrings.dart';
import 'ManageAccount/ManageAccountScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ContactSupportScreen/ContactSupportScreen.dart';
import 'ProfileSubsciption/ProfileSubsciptionScreen.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_state.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: ConstantStrings.profileTitle),
      body: BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
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
                      title: "Badges",
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.badgeIcon,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BadgesScreen(userWins: 10,totalPoints: 510,),
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
                                : ProfileSubscriptionScreen()),
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
                      title: "Units & Measurements",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => UnitSelectionCubit(context),
                              child: UnitSelectionScreen(),
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
                    "AvioflAI App ver 1.0",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
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
                    } else {
                      innerContext.read<DeleteCubit>().delete(context);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (isComeFromLogout == true
                ? "Are you sure you want to logout ?"
                : "Do you want to Delete account ?"),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.38,
                child: ElevatedButton(
                  onPressed: onYes,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent),
                    backgroundColor: const Color(0xFF3F3D51),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
              const SizedBox(width: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.38,
                child: OutlinedButton(
                  onPressed: onNo,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent),
                    backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Color(0xFF3F3D51), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
        if (showTopDivider == true)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE0E0E0),
            ),
          ),
        ...items,
        if (showBottomDivider == true)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE0E0E0),
            ),
          ),
      ],
    );
  }
}
