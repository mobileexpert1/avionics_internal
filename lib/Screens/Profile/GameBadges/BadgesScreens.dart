import 'dart:async';
import 'dart:ui';
import 'package:avionics_internal/Screens/Home/RootTabbar/RootDecider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universal_html/html.dart' as html;
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../bloc/Profile/GameBadges/gameBadges_cubit.dart';
import '../../../bloc/Profile/GameBadges/gameBadges_state.dart';
import '../../../bloc/Profile/GameBadges/gameBadges_model.dart';

class BadgesScreen extends StatefulWidget {
  final bool fromResultScreen;

  const BadgesScreen({super.key, this.fromResultScreen = false});

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

    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.badgesScreen);
  }

  @override
  void dispose() {
    _fullScreenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool ikweb =
        kIsWeb &&
        (MediaQuery.of(context).size.width > 600 ||
            MediaQuery.of(context).size.height > 600);

    return BlocProvider(
      create: (_) => BadgesCubit(context)
        ..loadBadges(
          //totalPoints: widget.totalPoints,
          selectedTab: "Quiz",
          context: context,
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Badges',
          centerTitle: false,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white,size: 30),
            onPressed: () {
              if (widget.fromResultScreen) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RootDecider()),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: BlocConsumer<BadgesCubit, BadgesState>(
          listener: (context, state) {
            if (state.status == CommonApiStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Something went wrong'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                const SizedBox(height: 10),
                _buildTabs(context, state),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width *
                        (ikweb ? 0.16 : 0.04),
                    vertical:
                        MediaQuery.of(context).size.height *
                        (ikweb ? 0.02 : 0.01),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height *
                          (ikweb ? 0.014 : 0.01),
                      horizontal:
                          MediaQuery.of(context).size.width *
                          (ikweb ? 0.03 : 0.02),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ikweb ? 16 : 10),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: ikweb ? 15 : 10,
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
                                  MediaQuery.of(context).size.height *
                                  (ikweb ? 0.03 : 0.025),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width *
                                  (ikweb ? 0.015 : 0.01),
                            ),
                            Text(
                              "Total Points Earned",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    MediaQuery.of(context).size.width *
                                    (ikweb ? 0.013 : 0.037),
                                color: const Color(0xFF32377D),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${state.totalPoints} points",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width *
                                (ikweb ? 0.013 : 0.037),
                            color: const Color(0xFF32377D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height:
                      MediaQuery.of(context).size.width *
                      (ikweb ? 0.015 : 0.01),
                ),

                /// Badge Grid Section
                Expanded(
                  child: state.badges.isEmpty
                      ? const Center(child: Text("No badges available."))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;
                            final crossAxisCount = isWide ? 5 : 2;

                            return GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width *
                                    (isWide ? 0.10 : 0.02),
                                vertical:
                                    MediaQuery.of(context).size.height *
                                    (isWide ? 0.02 : 0.01),
                              ),
                              itemCount: state.badges.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                        (isWide ? 0.03 : 0.015),
                                    mainAxisSpacing:
                                        MediaQuery.of(context).size.height *
                                        (isWide ? 0.025 : 0.015),
                                    childAspectRatio: isWide ? 1.0 : 0.75,
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
    final selectedTab = state.selectedTab;

    final bool ikweb =
        kIsWeb &&
        (MediaQuery.of(context).size.width > 600 ||
            MediaQuery.of(context).size.height > 600);

    return SizedBox(
      height: MediaQuery.of(context).size.height * (ikweb ? 0.07 : 0.06),
      child: Center(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal:
                MediaQuery.of(context).size.width * (ikweb ? 0.12 : 0.06),
          ),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: tabs.length,
          separatorBuilder: (_, _) => SizedBox(
            width: MediaQuery.of(context).size.width * (ikweb ? 0.09 : 0.02),
          ),
          itemBuilder: (context, index) {
            final isSelected = tabs[index] == selectedTab;
            return GestureDetector(
              onTap: () {
                context.read<BadgesCubit>().changeTab(
                  tabs[index],
                  context: context,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width *
                      (ikweb ? 0.015 : 0.010),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? Colors.blue : Colors.grey,
                        fontSize:
                            MediaQuery.of(context).size.width *
                            (ikweb ? 0.013 : 0.040),
                        letterSpacing: ikweb ? 1.2 : 1.0,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      height: ikweb ? 3.5 : 2.5,
                      width: isSelected
                          ? (tabs[index].length * (ikweb ? 10.0 : 8.0) + 10)
                          : 0,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        content: SingleChildScrollView(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: badge.isEarned ? 1 : 0.5,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 600,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        /// 🔵 Only the image is ColorFiltered
                        ColorFiltered(
                          colorFilter: badge.isEarned
                              ? const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.dst,
                                )
                              : ColorFilter.mode(
                                  Colors.white.withOpacity(0.2),
                                  BlendMode.srcATop,
                                ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: CachedAnyImage(
                              imagePath:
                                  (badge.icon != null && badge.icon!.isNotEmpty)
                                  ? badge.icon!
                                  : CommonUi.setPngImage(AssetsPath.badgeimg),
                              width: 250,
                              height: 200,
                              contentImage: BoxFit.contain,
                            ),
                          ),
                        ),

                        if (!badge.isEarned)
                          Positioned(
                            top: 90,
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.badgesLock),
                              width: 40,
                              height: 40,
                              color: const Color(0xFF1C66C5),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      badge.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      badge.isEarned ? "Badge Unlocked!" : "Badge Locked!",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),

                    if (!badge.isEarned) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: badge.totalWin / badge.wins,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          color: const Color(0xFF1E80F2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Current wins",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Text(
                            "${badge.totalWin} of ${badge.wins}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${badge.wins - badge.totalWin} more wins required to unlock",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.badgeTrophy),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              "Win: achieving >= 80% Score in a quiz",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
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
    final bool ikweb =
        kIsWeb &&
        (MediaQuery.of(context).size.width > 600 ||
            MediaQuery.of(context).size.height > 600);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: badge.isEarned ? 1 : 0.5,
            child: ColorFiltered(
              colorFilter: badge.isEarned
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                  : ColorFilter.mode(
                      Colors.white.withOpacity(0.2),
                      BlendMode.srcATop,
                    ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: CachedAnyImage(
                          imagePath: badge.icon?.isNotEmpty == true
                              ? badge.icon!
                              : CommonUi.setPngImage(AssetsPath.badgeimg),
                          width: double.infinity,
                          height: double.infinity,
                          contentImage: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      badge.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
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
                            size: 15,
                            color: badge.isEarned ? Colors.green : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            badge.isEarned
                                ? "Unlocked"
                                : "Unlock after ${badge.requireWin} wins",
                            style: TextStyle(
                              color: badge.isEarned
                                  ? Colors.green
                                  : Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          if (!badge.isEarned)
            Positioned.fill(
              child: Align(
                alignment: const Alignment(0, -0.22),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.badgesLock),
                  width: ikweb ? 45 : 35,
                  height: ikweb ? 45 : 35,
                  color: const Color(0xFF1C66C5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
