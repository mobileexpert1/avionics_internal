import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/LockedGameCard.dart';
import '../QuizSection/QuizQuestionScreen.dart';

class OneWordTopicScreen extends StatefulWidget {
  const OneWordTopicScreen({super.key});

  @override
  _OneWordTopicScreenState createState() => _OneWordTopicScreenState();
}

class _OneWordTopicScreenState extends State<OneWordTopicScreen> {
  late OnewordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OnewordCubit();
    _cubit.loadOneWordTopics(context);
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.oneWordTopicListScreen,
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
          title: 'One word game',
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
              padding: EdgeInsets.all(getPadding()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your topic to begin the game",
                    style: TextStyle(
                      height: 2,
                      fontSize: getResponsiveFont(16, 22),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isWeb ? 20 : 14),
                  Expanded(
                    child: BlocBuilder<OnewordCubit, OneWordTopicState>(
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
                          return const Center(
                            child: Text("No games available."),
                          );
                        }

                        return GridView.builder(
                          itemCount: state.games.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getCrossAxisCount(),
                            crossAxisSpacing: isWeb ? 20 : 12,
                            mainAxisSpacing: isWeb ? 20 : 12,
                            childAspectRatio: getChildAspectRatio(),
                          ),
                          itemBuilder: (context, index) {
                            final game = state.games[index];

                            return LockGameCard(
                              title: game.title,
                              isLocked: false,
                              infoMessage: game.info,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuizQuestionScreen(
                                      sectionId: game.gameNumber,
                                      sectionTitle: game.title,
                                      gameId: "one_word",
                                    ),
                                  ),
                                );
                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.oneWordTopicListScreen,
                                  FirebaseEvents.oneWordTopicButton,
                                );
                              },
                              onInfoTap: () {},
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
        ),
      ),
    );
  }
}

