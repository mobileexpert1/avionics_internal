import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Helpers/Games/LockedGameCard.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'QuizQuestionScreen.dart';

class QuizLockScreen extends StatelessWidget {
  const QuizLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit()..loadQuizTopics(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Quiz',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<QuizCubit, OneWordTopicState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }

                  if (state.games.isEmpty) {
                    return const Center(child: Text("No games available."));
                  }

                  return GridView.builder(
                    itemCount: state.games.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kIsWeb ? 4 : 2,       // optional small improvement
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final game = state.games[index];
                      return LockGameCard(
                        title: game.title,
                        isLocked: game.isLocked,
                        infoMessage: game.info,
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
                          }
                        },
                        onInfoTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
