import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Constants/constantImages.dart';
import '../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';
import '../AppTextStyles/AppTextStyles.dart';

class GameDetailCard extends StatelessWidget {
  final VoidCallback onStartGame;

  const GameDetailCard({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameDetailCubit, GameInfo>(
      builder: (context, game) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),

                game.iconWidget,

                const SizedBox(height: 14),

                Text(
                  game.title,
                  style: TextStyle(
                    fontSize: game.title.toLowerCase().contains("image") ? 23 : 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E3C55),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  game.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),

                const SizedBox(height: 20),


                if (!kIsWeb) ...[
                  // ---------------- MOBILE LAYOUT ----------------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.clock),
                        '40 seconds per question',
                      ),
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.Trophy),
                        '${game.questions} ${game.questionType}',
                      ),
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.Tik),
                        game.moduleType,
                      ),
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.Tik),
                        '+2 points for correct answers',
                      ),
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.Tik),
                        '+3 points for all correct answers',
                      ),
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.clock),
                        '+1 point if answered under 20s',
                      ),
                      buildInfo(
                        CommonUi.setSvgImage(AssetsPath.Trophy),
                        'Score 80% or more = 1 win',
                      ),
                      buildInfo(
                        CommonUi.setPngImage(AssetsPath.carFollowImage),
                        'Need a route to the right answer? Follow Me!',
                      ),
                    ],
                  ),
                ] else ...[
                  // ---------------- WEB LAYOUT (TWO COLUMNS) ----------------

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),

                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.clock),
                              '40 seconds per question',
                            ),
                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.Trophy),
                              '${game.questions} ${game.questionType}',
                            ),
                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.Tik),
                              game.moduleType,
                            ),

                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.Tik),
                              '+2 points for correct answers',
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.Tik),
                              '+3 points for all correct answers',
                            ),
                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.clock),
                              '+1 point if answered under 20s',
                            ),
                            buildInfo(
                              CommonUi.setSvgImage(AssetsPath.Trophy),
                              'Score 80% or more = 1 win',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                if (kIsWeb)
                Align(
                  alignment: Alignment.center,
                  child: buildInfo(
                    CommonUi.setPngImage(AssetsPath.carFollowImage),
                    'Need a route to the right answer? Follow Me!',
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width * 0.5
                        : double.infinity,
                    child: CustomBottomButton(
                      fontStyle: AppTextStyles.regular(21.46).copyWith(
                        height: 1.0,
                        color: Colors.white,
                      ),
                      title: "Start Game",
                      backgroundColor: AppColors.customBottomEnabledColour,
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      onPressed: onStartGame,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildInfo(String assetPath, String text) {
    final String path = assetPath.toLowerCase();
    final bool isSvg = path.endsWith('.svg');
    final bool isImg =
        path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSvg)
            SvgPicture.asset(assetPath, width: 20, height: 20)
          else if (isImg)
            Image.asset(assetPath, width: 22, height: 22)
          else
            const SizedBox(width: 20, height: 20),

          const SizedBox(width: 12),

          Flexible(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class GameDetailCardBlackBox extends StatelessWidget {
  final VoidCallback onStartGame;

  const GameDetailCardBlackBox({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameDetailCubit, GameInfo>(
      builder: (context, game) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 14),
                  game.iconWidget,
                  const SizedBox(height: 12),
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E3C55),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // ------------------ MOBILE / WEB INFO ------------------
                  if (!kIsWeb) ...[
                    // MOBILE: single column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.clock),
                          '60 seconds per question',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Trophy),
                          'Review factual clue cards and cockpit data',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Tik),
                          game.moduleType,
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Tik),
                          '+2/4 points for each correct answer',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Tik),
                          '+3 points for full-case accuracy',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Tik),
                          'Interpret sequences and identify causal factors',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Tik),
                          'Includes MCQs, sequencing, and multi-factor analysis',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Trophy),
                          'Score ≥80% to achieve Investigator Pass',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Trophy),
                          'Play more cases to unlock new badges and scenarios',
                        ),
                        buildInfo(
                          CommonUi.setPngImage(AssetsPath.carFollowImage),
                          'Need a route to the right answer? Follow Me!',
                        ),
                        buildInfo(
                          CommonUi.setSvgImage(AssetsPath.Tik),
                          'You’ll learn Real investigative reasoning, human-factor analysis, and system-failure interpretation—exactly as used in real crash investigations.',
                        ),
                      ],
                    ),
                  ] else ...[
                    // WEB: two columns
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.clock),
                                '60 seconds per question',
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Trophy),
                                'Review factual clue cards and cockpit data',
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Tik),
                                game.moduleType,
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Tik),
                                '+2/4 points for each correct answer',
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Tik),
                                '+3 points for full-case accuracy',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width * 0.1),

                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Tik),
                                'Interpret sequences and identify causal factors',
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Tik),
                                'Includes MCQs, sequencing, and multi-factor analysis',
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Trophy),
                                'Score ≥80% to achieve Investigator Pass',
                              ),
                              buildInfo(
                                CommonUi.setSvgImage(AssetsPath.Trophy),
                                'Play more cases to unlock new badges and scenarios',
                              ),
                              buildInfo(
                                CommonUi.setPngImage(AssetsPath.carFollowImage),
                                'Need a route to the right answer? Follow Me!',
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: kIsWeb ? 15 : 10),

                  if (kIsWeb)
                    Align(
                      alignment: Alignment.center,
                      child: buildInfo(
                        CommonUi.setSvgImage(AssetsPath.Tik),
                        'You’ll learn Real investigative reasoning, human-factor analysis, and system-failure interpretation—exactly as used in real crash investigations.',
                      ),
                    ),

                  const SizedBox(height: kIsWeb ? 15 : 10),

                  Center(
                    child: SizedBox(
                      width: kIsWeb
                          ? MediaQuery.of(context).size.width * 0.5
                          : double.infinity,
                      child: CustomBottomButton(
                        fontStyle: AppTextStyles.regular(21.46).copyWith(
                          height: 1.0,
                          color:  Colors.white
                              ,
                        ),
                        title: ConstantStrings.startGame,
                        backgroundColor: AppColors.customBottomEnabledColour,
                        textColor: Colors.white,
                        icon: const SizedBox(width: 0),
                        onPressed: onStartGame,
                      ),
                    ),
                  ),
                  const SizedBox(height: kIsWeb ? 15 : 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInfo(String assetPath, String text) {
    final String path = assetPath.toLowerCase();
    final bool isSvg = path.endsWith('.svg');
    final bool isImg =
        path.endsWith('.png') ||
            path.endsWith('.jpg') ||
            path.endsWith('.jpeg');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSvg)
            SvgPicture.asset(assetPath, width: 20, height: 20)
          else if (isImg)
            Image.asset(assetPath, width: 22, height: 22)
          else
            const SizedBox(width: 20, height: 20),

          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: kIsWeb ? 16 : 14),
            ),
          ),
        ],
      ),
    );
  }
}

