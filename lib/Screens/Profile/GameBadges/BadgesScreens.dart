import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universal_html/html.dart' as html;
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../bloc/Profile/GameBadges/gameBadges_cubit.dart';
import '../../../bloc/Profile/GameBadges/gameBadges_state.dart';
import '../../../bloc/Profile/GameBadges/gameBadges_model.dart';

class BadgesScreen extends StatefulWidget {
  final int userWins;
  final int totalPoints;

  const BadgesScreen({
    super.key,
    required this.userWins,
    required this.totalPoints,
  });

  @override
  _BadgesScreenState createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  bool _isFullScreen = false;
  StreamSubscription? _fullScreenSubscription;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _fullScreenSubscription = html.document.onFullscreenChange.listen((
        event,
      ) {
        setState(() {
          _isFullScreen = html.document.fullscreenElement != null;
        });
      });
    }
  }

  @override
  void dispose() {
    _fullScreenSubscription?.cancel();
    super.dispose();
  }

  void _toggleFullScreen() {
    if (kIsWeb) {
      if (html.document.fullscreenElement == null) {
        html.document.documentElement?.requestFullscreen();
      } else {
        html.document.exitFullscreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BadgesCubit(context)
        ..loadBadges(
          userWins: widget.userWins,
          totalPoints: widget.totalPoints,
          selectedTab: "Quiz", context: context,
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Badges',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          rightButton: kIsWeb
              ? IconButton(
                  icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.black,
                  ),
                  onPressed: _toggleFullScreen,
                )
              : null,
        ),
        body: BlocBuilder<BadgesCubit, BadgesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                _buildTabs(context, state),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.bagdestarIcon),
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Text(
                              "Total Points Earned",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.037,
                                color: const Color(0xFF32377D),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          // "${state.response?.totalEarnPoint ?? 0} points",
                          "${state.totalPoints} points",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.037,
                            color: const Color(0xFF32377D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Badge content area
                Expanded(
                  child: state.badges.isEmpty
                      ? Center(child: Text("No badges available."))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = constraints.maxWidth > 600
                                ? 4
                                : 2;
                            return GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              itemCount: state.badges.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                        0.015,
                                    mainAxisSpacing:
                                        MediaQuery.of(context).size.height *
                                        0.015,
                                    childAspectRatio: constraints.maxWidth > 600
                                        ? 1.0
                                        : 0.8,
                                  ),
                              itemBuilder: (context, index) {
                                final badge = state.badges[index];
                                return _BadgeCard(
                                  badge: badge,
                                  onTap: () =>
                                      _showBadgeDetails(context, badge),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, BadgesState state) {
    final tabs = ["Quiz", "One Word", "Black Box", "Calculations"];
    final selectedTab = state.selectedTab ?? tabs[0];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.06,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        itemBuilder: (context, index) {
          final isSelected = tabs[index] == selectedTab;

          return GestureDetector(
            onTap: () {
              context.read<BadgesCubit>().changeTab(
                tabs[index],
                userWins: widget.userWins,
                totalPoints: widget.totalPoints, context: context,
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.010,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.040,
                      letterSpacing: 1.0,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: 2.5,
                    width: isSelected ? (tabs[index].length * 8.0 + 10) : 0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _showBadgeDetails(BuildContext context, BadgeModel badge) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.04,
        ),
        content: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: badge.isEarned ? 1 : 0.5, // 👈 same as card
          child: ColorFiltered(
            colorFilter: badge.isEarned
                ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                : ColorFilter.mode(
              Colors.white.withOpacity(0.2),
              BlendMode.srcATop,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.11,
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: CachedAnyImage(
                          imagePath: (badge.icon != null && badge.icon!.isNotEmpty)
                              ? badge.icon!
                              : CommonUi.setPngImage(AssetsPath.badgeimg),
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.height * 0.25,
                          contentImage: BoxFit.fill,
                        ),
                      ),
                      if (!badge.isEarned)
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.130,
                          child: SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.badgesLock),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.height * 0.05,
                            color: const Color(0xFF1C66C5),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    badge.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    badge.isEarned ? "Badge Unlocked!" : "Badge Locked!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  // 👇 Progress + Info shown only for locked badges
                  if (!badge.isEarned) ...[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: badge.totalWin / badge.wins,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        color: const Color(0xFF1E80F2),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current wins",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "${badge.totalWin} of ${badge.wins}",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      "${badge.wins - badge.totalWin} more wins required to unlock",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.badgeTrophy),
                          width: MediaQuery.of(context).size.width * 0.04,
                          height: MediaQuery.of(context).size.width * 0.04,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                        Text(
                          "Win: achieving >= 80% Score in a quiz",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const _BadgeCard({required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Opacity(
                    opacity: badge.isEarned ? 1 : 0.5,
                    child: Opacity(
                      opacity: badge.isEarned ? 1 : 0.5,
                      child: CachedAnyImage(
                        imagePath:
                            (badge.icon != null && badge.icon!.isNotEmpty)
                            ? badge.icon!
                            : CommonUi.setPngImage(AssetsPath.badgeimg),
                        width: kIsWeb
                            ? MediaQuery.of(context).size.width * 0.15
                            : MediaQuery.of(context).size.width * 0.3,
                        height: kIsWeb
                            ? MediaQuery.of(context).size.width * 0.18
                            : MediaQuery.of(context).size.height * 0.18,
                        contentImage: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                if (!badge.isEarned)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.09,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.badgesLock),
                        height: MediaQuery.of(context).size.height * 0.0375,
                        width: MediaQuery.of(context).size.height * 0.0375,
                        color: const Color(0xFF1C66C5),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.015,
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0075),
                  Text(
                    badge.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0075),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.0075,
                      horizontal: MediaQuery.of(context).size.width * 0.0125,
                    ),
                    decoration: BoxDecoration(
                      color: badge.isEarned
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          badge.isEarned
                              ? Icons.check_circle
                              : Icons.lock_outline,
                          size: MediaQuery.of(context).size.width * 0.04,
                          color: badge.isEarned ? Colors.green : Colors.blue,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0075,
                        ),
                        Text(
                          badge.isEarned
                              ? "Unlocked"
                              : "Unlock after ${badge.requireWin} wins",
                          style: TextStyle(
                            color: badge.isEarned ? Colors.green : Colors.blue,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.02875,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
