import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/BlackBoxSection/BlackboxScreen.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/CalculationSection/CalculationScreen.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/OneWordSection/OneWordScreen.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/Games/GameCard.dart';
import '../../../bloc/Games/MainGameSection/game_cubit.dart';
import '../../../bloc/Games/MainGameSection/game_state.dart';
import '../GamesSubScreens/AircraftEncyclopaedia/AircraftEncyclopaediaDetailScreen.dart';
import '../GamesSubScreens/ImageBasedQuestion/ImageBasedDetailScreen.dart';
import '../GamesSubScreens/TriviaSection/TriviaDetailScreen.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late GamesCubit _gamesCubit;

  @override
  void initState() {
    super.initState();
    _gamesCubit = GamesCubit();
    _gamesCubit.loadGames();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.gamesScreen);
  }

  @override
  void dispose() {
    _gamesCubit.close();
    super.dispose();
  }

  int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1400) return 4;
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    return 2; // Mobile
  }

  /// ---------------- COMMON NAVIGATION ----------------
  void _navigate(BuildContext context, Widget screen) {
    AppNavigator.push(context, screen, disableSwipeBack: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _gamesCubit,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Games'),
        backgroundColor: const Color(0xFF35314B),
        body: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            if (state is GamesLoaded) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCrossAxisCount(context),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: state.games.length,
                      itemBuilder: (context, index) {
                        final game = state.games[index];
                        return GameCard(
                          item: game,
                          onTap: () {
                            switch (game.id) {
                              case 'quiz':
                                _navigate(
                                  context,
                                  QuizDetailScreen(gameId: game.id),
                                );

                                break;
                              case 'one_word':
                                _navigate(
                                  context,
                                  OneWordDetailScreen(gameId: game.id),
                                );
                                break;

                              case 'black_box':
                                _navigate(
                                  context,
                                  BlackBoxStartScreen(gameId: game.id),
                                );

                                break;

                              case 'calculation':
                                _navigate(
                                  context,
                                  CalculationDetailScreen(gameId: game.id),
                                );
                                break;

                              case 'imageBased':
                                _navigate(
                                  context,
                                  ImageBasedDetailScreen(gameId: game.id),
                                );

                              case 'trivia':
                                _navigate(
                                  context,
                                  TriviaDetailScreen(gameId: game.id),
                                );
                                break;
                                case 'aircraftEncyclopaedia':
                                _navigate(
                                  context,
                                  AircraftEncyclopaediaDetailScreen(),
                                );
                                break;
                              default:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Screen not available for ${game.title}',
                                    ),
                                  ),
                                );
                            }
                          },
                        );
                      },
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
}
