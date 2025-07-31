import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizQuestionScreen.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/LockedGameCard.dart';

class CalculationLockScreen extends StatelessWidget {
  const CalculationLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculationCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Calculations',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CalculationCubit, CalculationState>(
            builder: (context, state) {
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
                    infoMessage: '''This is your entry gate into aviation math Grab your mental calculator and convert like a true aviation whiz-Feet to kilometres,knots to Mach.''',
                    onTap: () {
                      if (!game.isLocked) {
                        // Navigate or play game
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const QuizQuestionScreen()),
                        // );
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
