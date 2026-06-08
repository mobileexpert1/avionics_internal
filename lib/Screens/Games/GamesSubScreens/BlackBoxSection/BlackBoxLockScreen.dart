import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Helpers/Games/LockedGameCard.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackBox_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackbox_cubit.dart';
import 'OverViewAndClueScreen.dart';

class BlackBoxLockScreen extends StatefulWidget {
  const BlackBoxLockScreen({super.key});

  @override
  State<BlackBoxLockScreen> createState() => _BlackBoxLockScreenState();
}

class _BlackBoxLockScreenState extends State<BlackBoxLockScreen> {
  late BlackboxCubit blackboxCubit;

  @override
  void initState() {
    super.initState();
    blackboxCubit = BlackboxCubit();
    blackboxCubit.loadBlackBoxTopics(context);
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.quizLockListScreen,
    );
  }

  @override
  void dispose() {
    blackboxCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => blackboxCubit,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: CustomAppBar(
          title: 'Black Box',
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<BlackboxCubit, BlackBoxState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(child: CircularProgressIndicator()),
                    );
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
                      crossAxisCount: kIsWeb ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: kIsWeb ? 0.78 : 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final game = state.games[index];

                      return LockGameCard(
                        title: game.title,
                        isLocked: game.isLocked,
                        infoMessage: game.info,
                        onTap: () {
                          if (!game.isLocked) {
                            AppNavigator.push(
                              context,
                              OverviewAndClueDeckScreen(
                                gameNo: game.gameNumber,
                              ),
                              disableSwipeBack: true,
                            );

                            AnalyticsService.instance.buttonPressed(
                              FirebaseEvents.quizListLockButton,
                              FirebaseEvents.quizLockListScreen,
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

