import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ProfileMain/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/ConstantStrings.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../Onboarding/Splash/splash_screen.dart';
import 'Avtar/AvtarScreen.dart';
import 'ContactSupportScreen/ContactSupportScreen.dart';
import 'Feedback/FeedbackScreen.dart';
import 'Glossary/GlossaryScreen.dart';
import 'ManageAccount/ManageAccountScreen.dart';
import 'ProfileSubsciption/ProfileSubsciptionScreen.dart';
import 'UnitSettings/UnitSettingsScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
                  showTopDivider: false,
                  headerTitle: "USER",
                  headerTextStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
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
                            builder: (context) => ManageAccountScreen(
                              firstName: "John",
                              lastName: "Doe",
                              email: "john@example.com",
                            ),
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
                            builder: (context) => ProfileSubscriptionScreen(),
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
                            builder: (context) => AvtarScreen(),
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
                            builder: (context) => UnitSelectionScreen(),
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
                            builder: (context) => GlossaryScreen(),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ),
                        );
                      },
                    ),
                    SettingsListItem(
                      leadingSvgAsset: CommonUi.setSvgImage(
                        AssetsPath.deleteAcc,
                      ),
                      title: "Delete account",
                      onTap: () {
                        showDeleteConfirmation(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Avionica App ver 1.0",
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

  void showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => InfoBottomSheet(
        onYes: () {
          Navigator.pop(context);
          // Handle delete action here
        },
        onNo: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class InfoBottomSheet extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const InfoBottomSheet({super.key, required this.onYes, required this.onNo});

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
          const Text(
            "Do you want to Delete account",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
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

/// A custom widget for a single item in a settings list.
/// (This is your existing SettingsListItem, included for completeness)
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

/// A custom widget to group a section header with multiple settings list items.
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
