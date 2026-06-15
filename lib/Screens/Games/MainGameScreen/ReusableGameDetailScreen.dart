import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';
import '../../../bloc/Games/ReusableGameDetail/ReusableGameDetail.dart';

class ReusableGameDetailScreen extends StatelessWidget {
  final GameInfoModel gameInfo;
  final String buttonText;
  final VoidCallback onButtonTap;
  final VoidCallback? onBackTap;

  const ReusableGameDetailScreen({
    super.key,
    required this.gameInfo,
    required this.buttonText,
    required this.onButtonTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: gameInfo.title,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
          ),

          onPressed: onBackTap ?? () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth > 1500
                ? 1500
                : constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Game info",
                                  style: AppTextStyles.bold(
                                    18,
                                  ).copyWith(color: AppColors.black),
                                ),
                              ),

                              const SizedBox(height: 15),

                              ...gameInfo.infoItems.map(
                                (e) => ReusableInfoCard(
                                  model: ReusableGameInfoItemModel(
                                    iconName: e.asset,
                                    title: e.title,
                                    value: e.value,
                                    subtitle: e.subtitle,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              if (gameInfo.helpTitle != null)
                                HelpInfoCard(
                                  model: ReusableHelpCardModel(
                                    iconName: AssetsPath.carHelpLevelIcon,
                                    normalText: gameInfo.helpTitle!,
                                    highlightedText:
                                        gameInfo.helpHighlightedTitle ?? '',
                                    description: gameInfo.helpDescription ?? '',
                                  ),
                                ),

                              const SizedBox(height: 5),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  "Win Rule",
                                  style: AppTextStyles.bold(
                                    18,
                                  ).copyWith(color: AppColors.black),
                                ),
                              ),

                              const SizedBox(height: 15),

                              WinRuleProgressCard(
                                model: ReusableWinRuleProgressModel(
                                  progress: gameInfo.progress,
                                  title: gameInfo.winTitle,
                                  highlightedText: gameInfo.winHighlightedText,
                                  normalText: gameInfo.winNormalText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      Center(
                        child: SizedBox(
                          width: kIsWeb
                              ? MediaQuery.of(context).size.width * 0.5
                              : double.infinity,
                          height: 50,
                          child: ReusableBottomButton(
                            text: buttonText,
                            onTap: onButtonTap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReusableInfoCard extends StatelessWidget {
  final ReusableGameInfoItemModel model;

  const ReusableInfoCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),

      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            CommonUi.setSvgImage(model.iconName),
            fit: BoxFit.cover,
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 3,
            child: Text(
              model.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.semiRegular(
                14,
              ).copyWith(color: AppColors.grayMedium),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.value,
                  textAlign: TextAlign.end,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bold(
                    14,
                  ).copyWith(letterSpacing: 0.8, color: AppColors.black),
                ),

                if (model.subtitle != null) ...[
                  const SizedBox(height: 10),

                  Text(
                    model.subtitle!,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.semiRegular(
                      12,
                    ).copyWith(color: AppColors.grayMedium),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WinRuleProgressCard extends StatelessWidget {
  final ReusableWinRuleProgressModel model;

  const WinRuleProgressCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final progress = model.progress.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: model.onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: const Color(0xFFE3E3E3)),

          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.winnerLevelIcon),

                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      model.title,

                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(color: AppColors.grayMedium),
                    ),

                    const SizedBox(height: 10),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: model.highlightedText,

                            style: AppTextStyles.medium(
                              24,
                            ).copyWith(color: AppColors.primaryBlue),
                          ),

                          TextSpan(
                            text: model.normalText,

                            style: AppTextStyles.medium(
                              16,
                            ).copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;

                final thumbPosition = barWidth * progress;

                return SizedBox(
                  height: 58,

                  child: Stack(
                    clipBehavior: Clip.none,

                    children: [
                      Positioned(
                        top: 28,

                        child: Container(
                          width: barWidth,
                          height: 24,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),

                            gradient: LinearGradient(
                              colors: [
                                AppColors.greenColourForPlan,
                                AppColors.greenColourForPlan,
                                Colors.grey,
                                Colors.grey,
                              ],

                              stops: [0.0, progress, progress, 1.0],
                            ),
                          ),

                          child: Container(
                            margin: const EdgeInsets.all(3),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),

                              color: AppColors.grayMedium,

                              border: Border.all(
                                color: progress >= 1.0
                                    ? AppColors.greenColourForPlan
                                    : AppColors.white,

                                width: 1.5,
                              ),
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),

                              child: Stack(
                                children: [
                                  Container(
                                    width: thumbPosition,

                                    decoration: const BoxDecoration(
                                      color: AppColors.greenColourForPlan,
                                    ),
                                  ),

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),

                                      child: Row(
                                        children: List.generate(
                                          24,
                                          (index) => Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                  ),

                                              height: 1.5,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    right: 0,
                                    top: 1,
                                    bottom: 1,

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,

                                      children: List.generate(
                                        5,
                                        (index) => Container(
                                          width: 12,
                                          height: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: thumbPosition + 1,
                        top: 12,

                        child: Container(
                          width: 2,
                          height: 42,
                          color: const Color(0xFF27214B),
                        ),
                      ),

                      Positioned(
                        left: thumbPosition - 8,
                        top: -2,

                        child: Text(
                          '${(progress * 100).toStringAsFixed(0)}%',

                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF27214B),
                          ),
                        ),
                      ),

                      Positioned(
                        left: thumbPosition - 7,
                        top: 30,

                        child: Container(
                          height: 18,
                          width: 18,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: progress >= 1.0
                                ? AppColors.greenColourForPlan
                                : const Color(0xFF4B93D8),

                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HelpInfoCard extends StatelessWidget {
  final ReusableHelpCardModel model;

  const HelpInfoCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: const Color(0xFFE3E3E3)),

          boxShadow: [
            BoxShadow(
              blurRadius: 8,

              color: Colors.black.withValues(alpha: 0.15),

              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            SvgPicture.asset(
              CommonUi.setSvgImage(model.iconName),
              fit: BoxFit.cover,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: model.normalText,

                          style: AppTextStyles.regular(
                            14,
                          ).copyWith(color: AppColors.black),
                        ),

                        TextSpan(
                          text: model.highlightedText,
                          style: AppTextStyles.bold(14).copyWith(
                            color: AppColors.extraDarkYellow,
                            letterSpacing: 1.0,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    model.description,

                    style: AppTextStyles.regular(
                      12,
                    ).copyWith(color: AppColors.grayMedium),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableBottomButton extends StatelessWidget {
  final String text;

  final VoidCallback onTap;

  final Color? backgroundColor;

  final Color? textColor;

  const ReusableBottomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF23235A),

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.semiBold(
            18,
          ).copyWith(height: 1.0, color: AppColors.white),
        ),
      ),
    );
  }
}
