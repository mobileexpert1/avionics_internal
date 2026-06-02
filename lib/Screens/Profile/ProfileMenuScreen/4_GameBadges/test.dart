// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:universal_html/html.dart' as html;
//
// import '../../../Constants/constantImages.dart';
// import '../../../CustomFiles/CustomAppBar.dart';
// import '../../../Helpers/CacheManger/CachedImageFile.dart';
// import '../../../bloc/Profile/4_GameBadges/gameBadges_cubit.dart';
// import '../../../bloc/Profile/4_GameBadges/gameBadges_model.dart';
// import '../../../bloc/Profile/4_GameBadges/gameBadges_state.dart';
//
// class R {
//   // Width-based breakpoints
//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 600;
//
//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 600 &&
//           MediaQuery.of(context).size.width < 1024;
//
//   static bool isWeb(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 1024;
//
//   // Responsive values
//   static double h(BuildContext context, double mobile, double tab, double web) {
//     if (isWeb(context)) return web;
//     if (isTablet(context)) return tab;
//     return mobile;
//   }
//
//   static double w(BuildContext context, double mobile, double tab, double web) {
//     if (isWeb(context)) return web;
//     if (isTablet(context)) return tab;
//     return mobile;
//   }
// }
//
// class BadgesScreen extends StatefulWidget {
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
//   _BadgesScreenState createState() => _BadgesScreenState();
// }
//
// class _BadgesScreenState extends State<BadgesScreen> {
//   bool _isFullScreen = false;
//   StreamSubscription? _fullScreenSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (kIsWeb) {
//       _fullScreenSubscription =
//           html.document.onFullscreenChange.listen((event) {
//             setState(() {
//               _isFullScreen = html.document.fullscreenElement != null;
//             });
//           });
//     }
//   }
//
//   @override
//   void dispose() {
//     _fullScreenSubscription?.cancel();
//     super.dispose();
//   }
//
//   void _toggleFullScreen() {
//     if (!kIsWeb) return;
//
//     if (html.document.fullscreenElement == null) {
//       html.document.documentElement?.requestFullscreen();
//     } else {
//       html.document.exitFullscreen();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => BadgesCubit(context)
//         ..loadBadges(
//           selectedTab: "Quiz",
//           context: context,
//         ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           title: 'Badges',
//           leftButton: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           rightButton: kIsWeb
//               ? IconButton(
//             icon: Icon(
//               _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
//               color: Colors.black,
//             ),
//             onPressed: _toggleFullScreen,
//           )
//               : null,
//         ),
//         body: BlocBuilder<BadgesCubit, BadgesState>(
//           builder: (context, state) {
//             if (state.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return Column(
//               children: [
//                 const SizedBox(height: 10),
//                 _buildTabs(context, state),
//
//                 // ---------------- TOTAL POINTS CARD ----------------
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: R.w(context, 16, 50, 150),
//                     vertical: R.h(context, 8, 16, 20),
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       vertical: R.h(context, 10, 14, 18),
//                       horizontal: R.w(context, 14, 20, 30),
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                       BorderRadius.circular(R.w(context, 10, 14, 18)),
//                       border: Border.all(color: Colors.grey.shade200),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade200,
//                           blurRadius: 12,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             SvgPicture.asset(
//                               CommonUi.setSvgImage(AssetsPath.bagdestarIcon),
//                               height: R.h(context, 22, 26, 30),
//                             ),
//                             SizedBox(width: R.w(context, 10, 14, 20)),
//                             Text(
//                               "Total Points Earned",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: R.w(context, 14, 16, 18),
//                                 color: const Color(0xFF32377D),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "${state.totalPoints} points",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: R.w(context, 14, 16, 18),
//                             color: const Color(0xFF32377D),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // ---------------- GRID ----------------
//                 Expanded(
//                   child: state.badges.isEmpty
//                       ? const Center(child: Text("No badges available."))
//                       : LayoutBuilder(
//                     builder: (context, constraints) {
//                       final isWide = constraints.maxWidth > 700;
//
//                       final crossAxisCount = isWide ? 5 : 2;
//
//                       return GridView.builder(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: R.w(context, 12, 30, 150),
//                           vertical: R.h(context, 12, 16, 20),
//                         ),
//                         itemCount: state.badges.length,
//                         gridDelegate:
//                         SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           crossAxisSpacing:
//                           R.w(context, 10, 16, 20),
//                           mainAxisSpacing:
//                           R.h(context, 10, 16, 20),
//                           childAspectRatio: isWide ? 1.0 : 0.75,
//                         ),
//                         itemBuilder: (context, index) {
//                           final badge = state.badges[index];
//                           return _BadgeCard(
//                             badge: badge,
//                             onTap: () => _showBadgeDetails(
//                               context,
//                               badge,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // ---------------- TABS ----------------
//
//   Widget _buildTabs(BuildContext context, BadgesState state) {
//     final tabs = ["Quiz", "One Word", "Black Box", "Calculations"];
//     final selectedTab = state.selectedTab;
//
//     return SizedBox(
//       height: R.h(context, 48, 60, 70),
//       child: Center(
//         child: ListView.separated(
//           padding:
//           EdgeInsets.symmetric(horizontal: R.w(context, 20, 40, 140)),
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           itemCount: tabs.length,
//           separatorBuilder: (_, _) =>
//               SizedBox(width: R.w(context, 14, 20, 40)),
//           itemBuilder: (context, index) {
//             final isSelected = tabs[index] == selectedTab;
//
//             return GestureDetector(
//               onTap: () {
//                 context.read<BadgesCubit>().changeTab(
//                   tabs[index],
//                   context: context,
//                 );
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     tabs[index],
//                     style: TextStyle(
//                       fontWeight:
//                       isSelected ? FontWeight.w700 : FontWeight.w500,
//                       color: isSelected ? Colors.blue : Colors.grey,
//                       fontSize: R.w(context, 14, 16, 18),
//                     ),
//                   ),
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 250),
//                     height: 3,
//                     width: isSelected
//                         ? (tabs[index].length * R.w(context, 7, 9, 11))
//                         : 0,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // ---------------- DIALOG ----------------
//
//   void _showBadgeDetails(BuildContext context, BadgeModel badge) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.4),
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CachedAnyImage(
//                     imagePath:
//                     badge.icon?.isNotEmpty == true ? badge.icon! : CommonUi.setPngImage(AssetsPath.badgeimg),
//                     width: 260,
//                     height: 220,
//                     contentImage: BoxFit.contain,
//                   ),
//                   if (!badge.isEarned)
//                     Positioned(
//                       child: SvgPicture.asset(
//                         CommonUi.setSvgImage(AssetsPath.badgesLock),
//                         width: 50,
//                         height: 50,
//                         color: const Color(0xFF1C66C5),
//                       ),
//                     )
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               Text(
//                 badge.name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               Text(
//                 badge.isEarned ? "Badge Unlocked!" : "Badge Locked!",
//                 style: const TextStyle(fontSize: 16),
//               ),
//
//               if (!badge.isEarned) ...[
//                 const SizedBox(height: 15),
//
//                 LinearProgressIndicator(
//                   value: badge.totalWin / badge.wins,
//                   minHeight: 10,
//                   backgroundColor: Colors.grey.shade300,
//                   color: const Color(0xFF1E80F2),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Current wins", style: TextStyle(color: Colors.grey)),
//                     Text("${badge.totalWin} of ${badge.wins}",
//                         style: const TextStyle(fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 Text(
//                     "${badge.wins - badge.totalWin} more wins required to unlock",
//                     style: const TextStyle(
//                         color: Colors.grey, fontWeight: FontWeight.w600)),
//               ],
//
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ---------------- BADGE CARD (UPDATED RESPONSIVE) --------------------
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
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CachedAnyImage(
//                     imagePath: badge.icon?.isNotEmpty == true
//                         ? badge.icon!
//                         : CommonUi.setPngImage(AssetsPath.badgeimg),
//                     width: double.infinity,
//                     height: double.infinity,
//                     contentImage: BoxFit.contain,
//                   ),
//                   if (!badge.isEarned)
//                     SvgPicture.asset(
//                       CommonUi.setSvgImage(AssetsPath.badgesLock),
//                       width: 40,
//                       height: 40,
//                       color: const Color(0xFF1C66C5),
//                     ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             Text(
//               badge.name,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//
//             const SizedBox(height: 6),
//
//             Container(
//               padding:
//               const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: badge.isEarned
//                     ? Colors.green.withOpacity(0.1)
//                     : Colors.blue.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     badge.isEarned ? Icons.check_circle : Icons.lock_outline,
//                     size: 15,
//                     color: badge.isEarned ? Colors.green : Colors.blue,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     badge.isEarned
//                         ? "Unlocked"
//                         : "Unlock after ${badge.requireWin} wins",
//                     style: TextStyle(
//                       color: badge.isEarned ? Colors.green : Colors.blue,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }
