import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Games/MainGameSection/game_cubit.dart';
import '../../../bloc/Games/MainGameSection/game_model.dart';
import '../../../bloc/Games/MainGameSection/game_state.dart';
import '../GamesSubScreens/AircraftEncyclopaedia/AircraftEncyclopaediaDetailScreen.dart';
import '../GamesSubScreens/BlackBoxSection/BlackboxScreen.dart';
import '../GamesSubScreens/CalculationSection/CalculationScreen.dart';
import '../GamesSubScreens/ImageBasedQuestion/ImageBasedDetailScreen.dart';
import '../GamesSubScreens/OneWordSection/OneWordScreen.dart';
import '../GamesSubScreens/QuizSection/QuizScreen.dart';
import '../GamesSubScreens/TriviaSection/TriviaDetailScreen.dart';
import '../MainGameExtraClasses/AllLinesPainter.dart';
import '../MainGameExtraClasses/DoubleCenterLinePainter.dart';

class GamesScreen extends StatefulWidget {
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
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
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
    final sw = MediaQuery.of(context).size.width;
    final cx = sw / 2;
    final screenHeight = MediaQuery.sizeOf(context).height - 10;

    return BlocProvider.value(
      value: _gamesCubit,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Games'),
        backgroundColor: Colors.white,
        body: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            if (state is GamesLoaded) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1500),
                  child: Padding(
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

                        SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Stack(
                                      children: [
                                        Positioned(
                                          top: 365,
                                          left: cx - 5,
                                          width: 8,
                                          bottom: 0,
                                          child: CustomPaint(
                                            painter: DoubleCenterLinePainter(),
                                          ),
                                        ),

                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: AllLinesPainter(
                                              screenWidth: sw,
                                            ),
                                          ),
                                        ),

                                        ...List.generate(state.games.length, (
                                          index,
                                        ) {
                                          final row = state.games[index];
                                          return Stack(
                                            children: [
                                              if (row.left != null)
                                                Positioned(
                                                  top: row.left!.topValue,
                                                  left: 30,
                                                  child: GameCard(
                                                    model: row.left!,
                                                    onTap: (id) {
                                                      onGameTap(
                                                        context,
                                                        row.left!,
                                                      );
                                                    },
                                                  ),
                                                ),

                                              if (row.right != null)
                                                Positioned(
                                                  top: row.right!.topValue,
                                                  right: 30,
                                                  child: GameCard(
                                                    model: row.right!,
                                                    onTap: (id) {
                                                      onGameTap(
                                                        context,
                                                        row.right!,
                                                      );
                                                    },
                                                  ),
                                                ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                              color: Colors.white,
                              child: Image.asset(
                                CommonUi.setPngImage(
                                  AssetsPath.towerImageForGame,
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 100,
                          left: 0,
                          right: -180,

                          child: Center(
                            child: Container(
                              width: 100,
                              height: 90,
                              decoration: const BoxDecoration(
                                color: AppColors.greenColourForPlan,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 150,
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
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void onGameTap(BuildContext context, GameCardModel game) {
    final routes = {
      'quiz': QuizDetailScreen(gameId: game.id),
      'one_word': OneWordDetailScreen(gameId: game.id),
      'black_box': BlackBoxStartScreen(gameId: game.id),
      'calculation': CalculationDetailScreen(gameId: game.id),
      'imageBased': ImageBasedDetailScreen(gameId: game.id),
      'trivia': TriviaDetailScreen(gameId: game.id),
      'aircraftEncyclopaedia': AircraftEncyclopaediaDetailScreen(),
    };

    final screen = routes[game.id];

    if (screen != null) {
      _navigate(context, screen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screen not available for ${game.title}')),
      );
    }
  }
}

class GameCard extends StatelessWidget {
  final GameCardModel model;
  final Function(String id) onTap;

  const GameCard({super.key, required this.model, required this.onTap});

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
              width: 110,
              height: 55,
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
                      size: const Size(15, 15),
                      painter: CornerPainter(color: model.color),
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        model.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.medium(
                          14,
                        ).copyWith(height: 1.1, color: AppColors.black),
                      ),
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
