// import 'package:avionics_internal/Constants/constantImages.dart';
// import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
// import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
// import '../../../../Constants/ConstantStrings.dart';
// import '../../../../Helpers/Games/GameInfoCard.dart';
// import '../GamesSubScreens/QuizSection/QuizQuestionScreen.dart';
//
// class GameDetailScreen extends StatefulWidget {
//   final String gameId;
//
//   const GameDetailScreen({super.key, required this.gameId});
//
//   @override
//   State<GameDetailScreen> createState() => _GameDetailScreenState();
// }
//
// class _GameDetailScreenState extends State<GameDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     AnalyticsService.instance.logVisibleScreen(FirebaseEvents.quizListScreen);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWeb = kIsWeb;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: "gameDetails.title",
//         centerTitle: false,
//         leftButton: IconButton(
//           icon: SvgPicture.asset(
//             CommonUi.setSvgImage(AssetsPath.backArrowButton),
//             fit: BoxFit.cover,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: isWeb ? 1500 : double.infinity),
//           child: Padding(
//             padding: EdgeInsets.all(isWeb ? screenWidth * 0.02 : 16),
//             child: GameDetailCard(
//               onStartGame: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => QuizQuestionScreen(
//                       sectionId: 0,
//                       sectionTitle: ConstantStrings.triviaTitle,
//                       gameId: "trivia",
//                     ),
//                   ),
//                 );
//                 AnalyticsService.instance.buttonPressed(
//                   FirebaseEvents.quizListButton,
//                   FirebaseEvents.blackBoxListScreen,
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
