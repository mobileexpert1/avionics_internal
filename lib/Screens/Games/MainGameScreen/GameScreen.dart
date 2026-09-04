import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/MainGameExtraClasses/AllLinesPainter.dart';
import '../../../Helpers/MainGameExtraClasses/DoubleCenterLinePainter.dart';
import '../../../bloc/Games/MainGameSection/game_cubit.dart';
import '../../../bloc/Games/MainGameSection/game_model.dart';
import '../../../bloc/Games/MainGameSection/game_state.dart';
import '../../Profile/SettingScreen/SettingScreen.dart';
import 'BaseScreenForAllLevelDescriptions.dart';

class GamesScreen extends StatefulWidget {
  static const String routeName = '/games';

  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late GamesCubit _gamesCubit;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _gamesCubit = GamesCubit();
    _gamesCubit.loadGames();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.gamesScreen);
    scrollToAboveScreen();
  }

  Future<void> scrollToAboveScreen() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (scrollController.hasClients) {
      final target = (scrollController.position.maxScrollExtent - 30).clamp(
        0.0,
        scrollController.position.maxScrollExtent,
      );

      scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 1300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _gamesCubit.close();
    super.dispose();
  }

  /// ---------------- COMMON NAVIGATION ----------------
  void _navigate(BuildContext context, Widget screen) {
    AppNavigator.push(context, screen, disableSwipeBack: true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight =
        MediaQuery.sizeOf(context).height +
        (kIsWeb
            ? screenWidth > 500
                  ? 100
                  : 50
            : 50);
    return BlocProvider.value(
      value: _gamesCubit,
      child: Scaffold(
        appBar: CustomAppBar(
          isForHomeScreen: true,
          title: '',
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.homeLeftMainLogo),
              width: 120,
              height: 31,
              fit: BoxFit.cover,
            ),
            onPressed: () {},
          ),
          rightButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.homeRightSetting),
              width: 35,
              height: 31,
              fit: BoxFit.cover,
            ),
            onPressed: () async {
              AppNavigator.push(
                context,
                SettingScreen(),
                disableSwipeBack: true,
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            if (state is GamesLoaded) {
              return Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boxWidth = constraints.maxWidth;
                    final boxCx = boxWidth / 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 25,
                            left: -100,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: const BoxDecoration(
                                  color: AppColors.citiusAltiusColorForGame,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 300,
                            left: 0,
                            right: -70,
                            child: Center(
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color: AppColors.citiusAltiusColorForGame,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 190,
                            left: -170,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color: AppColors.citiusAltiusColorForGame,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 185,
                            left: 0,
                            right: -180,
                            child: Center(
                              child: Container(
                                width: 80,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: AppColors.greenColourForPlan,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: SizedBox(
                              height: screenHeight,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 390,
                                    left: boxCx - 5,
                                    width: 8,
                                    bottom: 0,
                                    child: CustomPaint(
                                      painter: DoubleCenterLinePainter(),
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: AllLinesPainter(
                                        screenWidth: boxWidth,
                                      ),
                                    ),
                                  ),

                                  ...List.generate(state.games.length, (index) {
                                    final row = state.games[index];

                                    return Stack(
                                      children: [
                                        if (row.left != null)
                                          Positioned(
                                            top: row.left!.topValue,
                                            left: (kIsWeb
                                                ? screenWidth > 500
                                                      ? 200
                                                      : 30
                                                : 30),

                                            child: GameCard(
                                              model: row.left!,
                                              onTap: (_) {
                                                _navigate(
                                                  context,
                                                  BaseScreenForAllLevelDescriptions(
                                                    gameId: row.left!.id,
                                                  ),
                                                );
                                              },
                                              screenWidth: screenWidth,
                                            ),
                                          ),

                                        if (row.right != null)
                                          Positioned(
                                            top: row.right!.topValue,
                                            right: (kIsWeb
                                                ? screenWidth > 500
                                                      ? 200
                                                      : 30
                                                : 30),
                                            child: GameCard(
                                              model: row.right!,
                                              onTap: (_) {
                                                _navigate(
                                                  context,
                                                  BaseScreenForAllLevelDescriptions(
                                                    gameId: row.right!.id,
                                                  ),
                                                );
                                              },
                                              screenWidth: screenWidth,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          if (kIsWeb || screenWidth > 500) ...[
                            Positioned(
                              bottom: -20,
                              left: 0,
                              right: 0,
                              child: SizedBox(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Transform.flip(
                                              flipX: true,
                                              child: Image.asset(
                                                CommonUi.setPngImage(
                                                  AssetsPath.cloudsRightForGame,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Transform.flip(
                                              flipX: false,
                                              child: Image.asset(
                                                CommonUi.setPngImage(
                                                  AssetsPath.cloudsRightForGame,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: screenWidth > 500 ? 300 : 160,
                                        child: Container(
                                          color: Colors.white,
                                          child: Image.asset(
                                            CommonUi.setPngImage(
                                              AssetsPath.towerImageForWebGame,
                                            ),
                                            alignment: Alignment.bottomCenter,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (!kIsWeb || screenWidth < 500) ...[
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 160,
                              child: IgnorePointer(
                                child: Container(
                                  color: Colors.white,
                                  child: Image.asset(
                                    CommonUi.setPngImage(
                                      AssetsPath.towerImageForGame,
                                    ),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameCardModel model;
  final Function(String id) onTap;
  final double screenWidth;

  const GameCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call(model.id);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width:
                  MediaQuery.of(context).size.width /
                  (kIsWeb
                      ? screenWidth > 500
                            ? 5
                            : 3
                      : 3),
              height: kIsWeb
                  ? screenWidth > 500
                        ? 100
                        : 65
                  : 65,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: model.color, width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(14, 14),
                      painter: CornerPainter(color: model.color),
                    ),
                  ),

                  Center(
                    child: Text(
                      model.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.medium(
                        (kIsWeb
                            ? screenWidth > 500
                                  ? 24
                                  : 14
                            : 14),
                      ).copyWith(height: 1.2, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
