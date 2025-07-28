import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Helpers/Games/GameCard.dart';
import '../../../bloc/Games/MainGameSection/game_cubit.dart';
import '../../../bloc/Games/MainGameSection/game_state.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamesCubit()..loadGames(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Games'),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF35314B),
        body: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            if (state is GamesLoaded) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(context),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.games.length,
                  itemBuilder: (context, index) {
                    return GameCard(item: state.games[index]);
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
