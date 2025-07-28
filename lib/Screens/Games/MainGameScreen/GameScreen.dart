import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Helpers/Games/GameCard.dart';
import '../../../bloc/Games/MainGameSection/game_cubit.dart';
import '../../../bloc/Games/MainGameSection/game_state.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  int getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1400) return 6;
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  double getAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 1.1;
    if (width >= 900) return 1.0;
    if (width >= 600) return 0.95;
    return 0.85; // tighter for phones
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GamesCubit()..loadGames(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Games'),
        backgroundColor: const Color(0xFF35314B),
        body: BlocBuilder<GamesCubit, GamesState>(
          builder: (context, state) {
            if (state is GamesLoaded) {
              final crossAxisCount = getCrossAxisCount(context);
              final aspectRatio = getAspectRatio(context);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: GridView.builder(
                  itemCount: state.games.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: aspectRatio,
                  ),
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
