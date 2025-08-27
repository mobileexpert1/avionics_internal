import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizQuestionScreen.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/LockedGameCard.dart';

class CalculationLockScreen extends StatelessWidget {
  const CalculationLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculationCubit()..loadCalculationLocks(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: ConstantStrings.calculationsTitle,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CalculationCubit, CalculationState>(
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
                    onTap: () {
                      if (!game.isLocked) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizQuestionScreen(
                              sectionId:game.gameNumber,
                              sectionTitle: ConstantStrings.calculationsTitle, gameId: "calculation",
                            ),
                          ),
                        );
                        print('Playing ${game.title}');
                      }
                    },
                    onInfoTap: () {
                      if (game.isLocked) {
                        context.read<CalculationCubit>().unlockGame(index);
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
