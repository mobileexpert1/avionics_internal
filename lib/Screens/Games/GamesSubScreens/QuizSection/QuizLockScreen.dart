import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Helpers/Games/LockedGameCard.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'QuizQuestionScreen.dart';

class QuizLockScreen extends StatelessWidget {
  const QuizLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit()..loadQuizTopics(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Quiz',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<QuizCubit, OneWordTopicState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!)); // Error
              }

              if (state.games.isEmpty) {
                return const Center(child: Text("No games available."));
              }
              return GridView.builder(
                itemCount: state.games.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final game = state.games[index];
                  return LockGameCard(
                    title: game.title,
                    isLocked: game.isLocked,
                    infoMessage: game.info,
                    // infoMessage:
                    //     'The sky’s quiet lounge above the clouds,where ozone gets to work.',
                    onTap: () {
                      if (!game.isLocked) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizQuestionScreen(
                              sectionId: 1,
                              sectionTitle: ConstantStrings.aviationQuizTitle,
                              gameId: "quiz",
                            ),
                          ),
                        );
                        print('Playing ${game.title}');
                      }
                    },
                    onInfoTap: () {
                      if (game.isLocked) {
                        context.read<QuizCubit>().unlockGame(index);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
