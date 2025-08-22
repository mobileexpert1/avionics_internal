import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/LockedGameCard.dart';
import '../QuizSection/QuizQuestionScreen.dart';

class OneWordTopicScreen extends StatelessWidget {
  const OneWordTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnewordCubit()..loadOneWordTopics(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'One word game',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose your topic to begin the game",
                style: TextStyle(
                  height: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: BlocBuilder<OnewordCubit, OneWordTopicState>(
                  builder: (context, state) {
                    return GridView.builder(
                      itemCount: state.games.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 0,
                            childAspectRatio: 0.8,
                          ),
                      itemBuilder: (context, index) {
                        final game = state.games[index];
                        return LockGameCard(
                          title: game.title,
                          isLocked: false,
                          infoMessage: '''
• Structure and behaviour of the
   atmosphere
• METAR and TAF decoding
• Wind, pressure systems,
   temperature gradients
• Fronts,clouds,thunderstorms,
   turbulence
• Icing conditions, visibility, fog
• Weather radar and satellite
   interpretation
• Environmental awareness:
   noise abatement,emissions,
   contrail formation
''',
                          onTap: () {
                            if (!game.isLocked) {
                              print('Playing ${game.title}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizQuestionScreen(
                                    sectionId: game.gameNumber,
                                    sectionTitle: game.title, gameId: "one_word",
                                  ),
                                ),
                              );
                            }
                          },
                          onInfoTap: () {
                            if (game.isLocked) {
                              context.read<OnewordCubit>().unlockGame(index);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
