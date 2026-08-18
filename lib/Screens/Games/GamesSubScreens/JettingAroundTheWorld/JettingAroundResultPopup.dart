import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';

class JettingAroundResultPopup extends StatelessWidget {
  final bool isSuccess;
  final int currentStep;
  final int totalStep;
  final int earnedJettons;
  final VoidCallback onButtonTap;
  final VoidCallback onCrossButtonTap;

  const JettingAroundResultPopup({
    super.key,
    required this.isSuccess,
    required this.currentStep,
    required this.totalStep,
    required this.earnedJettons,
    required this.onButtonTap,
    required this.onCrossButtonTap,
  });

  Future<(String, String)> getJettingGameTitle() async {
    final currentCount = await SharedPrefsHelper.getJettingGamesCount();
    final currentTitle = getTheDynamicTitleAccordingToLevel(currentCount);
    final upcomingTitle = getTheDynamicTitleAccordingToLevel(currentCount + 1);
    return (
      currentTitle,
      upcomingTitle != "" ? upcomingTitle : "View Your Journey",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        height: MediaQuery.of(context).size.height / 1.5,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: FutureBuilder<(String, String)>(
          future: getJettingGameTitle(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentTitle = snapshot.data?.$1 ?? "";
            final upcomingTitle = snapshot.data?.$2 ?? "View Your Journey";

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSuccess) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onCrossButtonTap,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.gameInfoClose),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),

                Text(
                  isSuccess
                      ? "$currentTitle Successful."
                      : "Rejected $currentTitle.",
                  style: AppTextStyles.bold(
                    24,
                  ).copyWith(height: 1.0, color: AppColors.black),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  isSuccess
                      ? "$currentTitle cleared."
                      : "$currentTitle Minimums Not Met.",
                  style: AppTextStyles.medium(20).copyWith(
                    height: 1.0,
                    color: isSuccess
                        ? AppColors.greenColourForPlan
                        : AppColors.blackBoxColorForGame,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "$currentStep/$totalStep",
                  style: AppTextStyles.semiBold(
                    24,
                  ).copyWith(height: 1.0, color: AppColors.primaryDark),
                ),

                const SizedBox(height: 20),

                if (isSuccess)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffA4D43E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              CommonUi.setSvgImage(
                                AssetsPath.successJettingAround,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "You earned\n",
                                    style: AppTextStyles.medium(14).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "\n",
                                    style: AppTextStyles.bold(10).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "+$earnedJettons Jettons",
                                    style: AppTextStyles.bold(24).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          "Every expert was once a beginner.\nOne more try and you'll do even better!",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular(16).copyWith(
                            height: 1.4,
                            color: AppColors.greyForTextfield,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: SizedBox(
                    width: upcomingTitle.contains("Journey") ? 170 : 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onButtonTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isSuccess
                            ? upcomingTitle.contains("Journey")
                                  ? upcomingTitle
                                  : "Start $upcomingTitle"
                            : isSuccess
                            ? "Retry $upcomingTitle"
                            : "Retry $currentTitle",
                        style: AppTextStyles.regular(
                          14,
                        ).copyWith(height: 1.0, color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
