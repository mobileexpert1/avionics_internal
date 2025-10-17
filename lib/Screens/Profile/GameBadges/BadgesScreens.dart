// import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../Constants/constantImages.dart';
// import '../../../bloc/Profile/GameBadges/gameBadges_cubit.dart';
// import '../../../bloc/Profile/GameBadges/gameBadges_state.dart';
// import '../../../bloc/Profile/GameBadges/gameBadges_model.dart';
//
// class BadgesScreen extends StatelessWidget {
//   final int userWins;
//   final int totalPoints;
//
//   const BadgesScreen({
//     super.key,
//     required this.userWins,
//     required this.totalPoints,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//       BadgesCubit()..loadBadges(userWins: userWins, totalPoints: totalPoints),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           title: 'Badges',
//           leftButton: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         body: BlocBuilder<BadgesCubit, BadgesState>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
//               return Center(child: Text(state.errorMessage!));
//             }
//             if (state.badges.isEmpty) {
//               return const Center(child: Text("No badges available."));
//             }
//
//             return Column(
//               children: [
//                 const SizedBox(height: 6),
//                 _buildTabs(context, state),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 10,
//                       horizontal: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             SvgPicture.asset(
//                               CommonUi.setSvgImage(AssetsPath.bagdestarIcon),
//                               height: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               "Total Points Earned",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                                 color: Color(0xFF32377D),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "${state.totalPoints} points",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                             color: Color(0xFF32377D),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     itemCount: state.badges.length,
//                     gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                       childAspectRatio: 0.8,
//                     ),
//                     itemBuilder: (context, index) {
//                       final badge = state.badges[index];
//                       return _BadgeCard(badge: badge, onTap: () {
//                         _showBadgeDetails(context, badge);
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabs(BuildContext context, BadgesState state) {
//     final tabs = ["Quiz", "One Word", "Black Box", "Calculations"];
//     final selectedTab = state.selectedTab ?? tabs[0];
//
//     return SizedBox(
//       height: 45,
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         scrollDirection: Axis.horizontal,
//         itemCount: tabs.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 16),
//         itemBuilder: (context, index) {
//           final isSelected = tabs[index] == selectedTab;
//
//           return GestureDetector(
//             onTap: () {
//               context.read<BadgesCubit>().changeTab(tabs[index]);
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 25,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         tabs[index],
//                         style: TextStyle(
//                           fontWeight:
//                           isSelected ? FontWeight.w700 : FontWeight.w500,
//                           color: isSelected ? Colors.blue : Colors.grey,
//                           fontSize: 14,
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 250),
//                         curve: Curves.easeInOut,
//                         height: 2.5,
//                         width: isSelected
//                             ? (tabs[index].length * 8.0 + 10)
//                             : 0,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showBadgeDetails(BuildContext context, BadgeModel badge) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         contentPadding: const EdgeInsets.all(16),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: Image.asset(
//                     badge.image,
//                     height: 200,
//                     // width: double.infinity,
//                     fit: BoxFit.contain, // makes it fill top nicely
//                   ),
//                 ),
//                 if (!badge.isUnlocked)
//                   Positioned(
//                     top: 100,
//                     child: SvgPicture.asset(
//                       CommonUi.setSvgImage(AssetsPath.LockIcon),
//                       height: 40,
//                       width: 40,
//                       color: const Color(0xFF1E80F2),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               badge.title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               badge.isUnlocked ? "Badge Unlocked!" : "Badge locked!",
//               style: TextStyle(
//                 color: badge.isUnlocked ? Colors.black : Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             if (!badge.isUnlocked) ...[
//               const SizedBox(height: 16),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: LinearProgressIndicator(
//                   // value: badge.currentWins / badge.unlockAfterWins,
//                   value: badge.unlockAfterWins / badge.unlockAfterWins,
//                   minHeight: 10,
//                   backgroundColor: Colors.grey.shade200,
//                   color: Colors.blue,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//               Text(
//                 // "Current wins required to unlock ${badge.currentWins} of ${badge.unlockAfterWins}",
//                 "Current wins ${badge.unlockAfterWins} of ${badge.unlockAfterWins}",
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 // "${badge.unlockAfterWins - badge.currentWins} more wins required to unlock",
//                 "${badge.unlockAfterWins - badge.unlockAfterWins} more wins required to unlock",
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     CommonUi.setSvgImage(AssetsPath.Trophy),
//                     width: 16,
//                     height: 16,
//                     colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
//                   ),
//
//                   const SizedBox(width: 4),
//                   const Text(
//                     "Win: achieving >= 80% Score in a quiz",
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _BadgeCard extends StatelessWidget {
//   final BadgeModel badge;
//   final VoidCallback onTap;
//
//   const _BadgeCard({required this.badge, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                   child: Opacity(
//                     opacity: badge.isUnlocked ? 1 : 0.5,
//                     child: Image.asset(
//                       badge.image,
//                       height: 145,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(Icons.error, color: Colors.red);
//                       },
//                     ),
//                   ),
//                 ),
//                 if (!badge.isUnlocked)
//                   Positioned(
//                     top: 70,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: SvgPicture.asset(
//                         CommonUi.setSvgImage(AssetsPath.LockIcon),
//                         height: 30,
//                         width: 30,
//                         color: const Color(0xFF1E80F2),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 6),
//                   Text(
//                     badge.title,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                     decoration: BoxDecoration(
//                       color: badge.isUnlocked
//                           ? Colors.green.withOpacity(0.1)
//                           : Colors.blue.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           badge.isUnlocked ? Icons.check_circle : Icons.lock_outline,
//                           size: 16,
//                           color: badge.isUnlocked ? Colors.green : Colors.blue,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           badge.isUnlocked
//                               ? "Unlocked"
//                               : "Unlock after ${badge.unlockAfterWins} wins",
//                           style: TextStyle(
//                             color: badge.isUnlocked ? Colors.green : Colors.blue,
//                             fontSize: 11.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:universal_html/html.dart' as html;
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
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
      _fullScreenSubscription = html.document.onFullscreenChange.listen((event) {
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
      create: (_) => BadgesCubit()..loadBadges(userWins: widget.userWins, totalPoints: widget.totalPoints),
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
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              return Center(child: Text(state.errorMessage!));
            }
            if (state.badges.isEmpty) {
              return const Center(child: Text("No badges available."));
            }

            return Column(
              children: [
                _buildTabs(context, state),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.bagdestarIcon),
                              height: MediaQuery.of(context).size.height * 0.025,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                            Text(
                              "Total Points Earned",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                color: const Color(0xFF32377D),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${state.totalPoints} points",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.0375,
                            color: const Color(0xFF32377D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        itemCount: state.badges.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
                          mainAxisSpacing: MediaQuery.of(context).size.height * 0.015,
                          childAspectRatio: constraints.maxWidth > 600 ? 1.0 : 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final badge = state.badges[index];
                          return _BadgeCard(badge: badge, onTap: () {
                            _showBadgeDetails(context, badge);
                          });
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
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        itemBuilder: (context, index) {
          final isSelected = tabs[index] == selectedTab;

          return GestureDetector(
            onTap: () {
              context.read<BadgesCubit>().changeTab(tabs[index]);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tabs[index],
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.blue : Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    letterSpacing: 1.5,
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
          );
        },
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeModel badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        content: ConstrainedBox(
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
                    child: Image.asset(
                      badge.image,
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (!badge.isUnlocked)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.125,
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
                badge.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                badge.isUnlocked ? "Badge Unlocked!" : "Badge locked!",
                style: TextStyle(
                  color: badge.isUnlocked ? Colors.black : Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!badge.isUnlocked) ...[
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: badge.unlockAfterWins / badge.unlockAfterWins,
                    // value: badge.currentWins / badge.unlockAfterWins,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    color: Color(0xFF1E80F2),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  // "Current wins ${badge.currentWins} of ${badge.unlockAfterWins}",
                  "Current wins ${badge.unlockAfterWins} of ${badge.unlockAfterWins}",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  // "${badge.unlockAfterWins - badge.currentWins} more wins required to unlock",
                  "${badge.unlockAfterWins - badge.unlockAfterWins} more wins required to unlock",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
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
                      // colorFilter: const ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
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
              ],
            ],
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
                    opacity: badge.isUnlocked ? 1 : 0.5,
                    child: Image.asset(
                      badge.image,
                      height: MediaQuery.of(context).size.height * 0.18,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ),
                if (!badge.isUnlocked)
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0075),
                  Text(
                    badge.title,
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
                      color: badge.isUnlocked ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          badge.isUnlocked ? Icons.check_circle : Icons.lock_outline,
                          size: MediaQuery.of(context).size.width * 0.04,
                          color: badge.isUnlocked ? Colors.green : Colors.blue,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.0075),
                        Text(
                          badge.isUnlocked ? "Unlocked" : "Unlock after ${badge.unlockAfterWins} wins",
                          style: TextStyle(
                            color: badge.isUnlocked ? Colors.green : Colors.blue,
                            fontSize: MediaQuery.of(context).size.width * 0.02875,
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