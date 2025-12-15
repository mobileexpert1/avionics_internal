import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizQuestionScreen.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/LockedGameCard.dart';

class CalculationLockScreen extends StatefulWidget {
  const CalculationLockScreen({super.key});

  @override
  State<CalculationLockScreen> createState() => _CalculationLockScreenState();
}

class _CalculationLockScreenState extends State<CalculationLockScreen> {
  late CalculationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CalculationCubit();
    _cubit.loadCalculationLocks();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.calculationsLockListScreen,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb;

    double getResponsiveFont(double mobile, double web) => isWeb ? web : mobile;
    double getPadding() => isWeb ? screenWidth * 0.02 : 16;
    int getCrossAxisCount() => isWeb ? 4 : 2;
    double getChildAspectRatio() => isWeb ? 0.9 : 0.8;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: ConstantStrings.calculationsTitle,
          leftButton: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: isWeb ? 28 : 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: EdgeInsets.all(getPadding()),
              child: BlocBuilder<CalculationCubit, CalculationState>(
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
                      crossAxisCount: getCrossAxisCount(),
                      crossAxisSpacing: isWeb ? 20 : 12,
                      mainAxisSpacing: isWeb ? 20 : 12,
                      childAspectRatio: getChildAspectRatio(),
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
                                  sectionId: game.gameNumber,
                                  sectionTitle:
                                      ConstantStrings.calculationsTitle,
                                  gameId: "calculation",
                                ),
                              ),
                            );
                            AnalyticsService.instance.buttonPressed(
                              FirebaseEvents.calculationsLockButton,
                              FirebaseEvents.calculationsLockListScreen,
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
