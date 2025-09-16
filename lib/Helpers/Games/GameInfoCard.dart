import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Constants/constantImages.dart';
import '../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';

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
            padding: const EdgeInsets.all(20),
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
                Text(game.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color(0xFF3E3C55))),
                const SizedBox(height: 4),
                Text(game.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 16),
                buildInfo(CommonUi.setSvgImage(AssetsPath.clock), '40 seconds per question'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Trophy), '${game.questions} ${game.questionType}'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), game.moduleType),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), '+2 points for correct answers'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), '+3 points for all correct answers'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.clock), '+1 point if answered under 20s'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Trophy), 'Score 80% or more = 1 win'),
                buildInfo(CommonUi.setPngImage(AssetsPath.carFollowImage), 'Need a route to the right answer? Follow Me!'),
                const SizedBox(height: 24),
                CustomBottomButton(
                  title: ConstantStrings.startGame,
                  backgroundColor: AppColors.customBottomEnabledColour,
                  textColor: Colors.white,
                  icon: const SizedBox(width: 0),
                  onPressed: onStartGame,
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
    final bool isPngOrJpg = path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (isSvg)
            SvgPicture.asset(assetPath, width: 20, height: 20)
          else if (isPngOrJpg)
            Image.asset(assetPath, width: 22, height: 22)
          else
            const SizedBox(width: 20, height: 20), // fallback widget if unknown
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
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
                Text(game.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color(0xFF3E3C55))),
                const SizedBox(height: 4),
                Text(game.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 16),
                buildInfo(CommonUi.setSvgImage(AssetsPath.clock), 'No time limitation'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Trophy), '${game.questions} ${game.questionType}'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), game.moduleType),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), '+2 points for correct answers'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), '+3 points for all correct answers'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Tik), 'Include MCQ, sequence based and \nmultiple answer questions'),
                buildInfo(CommonUi.setSvgImage(AssetsPath.Trophy), 'Score 80% or more = 1 win'),
                buildInfo(CommonUi.setPngImage(AssetsPath.carFollowImage), 'Need a route to the right answer? Follow Me!'),
                const SizedBox(height: 20),
                CustomBottomButton(
                  title: ConstantStrings.startGame,
                  backgroundColor: AppColors.customBottomEnabledColour,
                  textColor: Colors.white,
                  icon: const SizedBox(width: 0),
                  onPressed: onStartGame,
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
    final bool isPngOrJpg = path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (isSvg)
            SvgPicture.asset(assetPath, width: 20, height: 20)
          else if (isPngOrJpg)
            Image.asset(assetPath, width: 22, height: 22)
          else
            const SizedBox(width: 20, height: 20), // fallback widget if unknown
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}