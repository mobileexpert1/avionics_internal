import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CustomHeaderViewExpandable.dart';
import '../../../../bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import '../../../Profile/SettingScreen/SettingScreen.dart';
import 'QuizQuestionScreen.dart';

class QuizLockScreen extends StatefulWidget {
  const QuizLockScreen({super.key});

  @override
  State<QuizLockScreen> createState() => _QuizLockScreenState();
}

class _QuizLockScreenState extends State<QuizLockScreen> {
  late QuizCubit quizCubit;

  @override
  void initState() {
    super.initState();
    quizCubit = QuizCubit();
    quizCubit.loadQuizTopics(context);
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.quizLockListScreen,
    );
  }

  @override
  void dispose() {
    quizCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => quizCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Aviation Quiz',
          centerTitle: false,
          leftButton: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          rightButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.homeRightSetting),
              width: 35,
              height: 31,
              fit: BoxFit.cover,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            },
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
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

                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: SingleChildScrollView(
                    child: Transform.translate(
                      offset: Offset(0, -35),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(state.games.length, (index) {
                          final game = state.games[index];
                          return AtmosLayer(
                            infoDetails: game.info.first,
                            index: index,
                            title: game.title,
                            isLocked: game.isLocked,
                            onTap: () {
                              if (!game.isLocked) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuizQuestionScreen(
                                      sectionId: game.gameNumber,
                                      sectionTitle:
                                          ConstantStrings.aviationQuizTitle,
                                      gameId: "quiz",
                                    ),
                                  ),
                                );

                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.quizListLockButton,
                                  FirebaseEvents.quizLockListScreen,
                                );
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

double getHeight(int index) {
  switch (index) {
    case 0:
      return 130;
    case 1:
      return 130;
    case 2:
      return 135;
    case 3:
      return 120;
    default:
      return 120;
  }
}

class AtmosLayer extends StatefulWidget {
  final String title;
  final String infoDetails;
  final bool isLocked;
  final VoidCallback onTap;
  final int index;

  const AtmosLayer({
    super.key,
    required this.title,
    required this.infoDetails,
    required this.isLocked,
    required this.onTap,
    required this.index,
  });

  @override
  State<AtmosLayer> createState() => _AtmosLayerState();
}

class _AtmosLayerState extends State<AtmosLayer> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showPopup() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _hidePopup,
                ),
              ),

              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(-135, widget.index == 4 ? -80 : -15),
                child: ArrowPopup(
                  isLocked: widget.isLocked,
                  infoDetails: widget.infoDetails,
                  onStart: () {
                    _hidePopup();
                    widget.onTap();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetName = AtmosphereAssets.getAsset(widget.title);

    return SizedBox(
      height: getHeight(widget.index),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              CommonUi.setSvgImage(assetName),
              fit: BoxFit.contain,
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title),
                const SizedBox(height: 10),
                CompositedTransformTarget(
                  link: _layerLink,
                  child: GestureDetector(
                    onTap: _showPopup,
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: widget.isLocked
                            ? AppColors.grayLight
                            : AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: widget.isLocked ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowPopup extends StatelessWidget {
  final VoidCallback onStart;
  final String infoDetails;
  final bool isLocked;

  const ArrowPopup({
    super.key,
    required this.onStart,
    required this.infoDetails,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.separatorColourAppBar,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              infoDetails,
              textAlign: TextAlign.left,
              style: AppTextStyles.regular(
                16,
              ).copyWith(height: 1.0, color: AppColors.grayMedium),
            ),

            //const SizedBox(height: 12),

            // Text(
            //   "The beginning of your journey.",
            //   textAlign: TextAlign.left,
            //   style: AppTextStyles.bold(
            //     16,
            //   ).copyWith(height: 1.0, color: AppColors.primaryValueColour),
            // ),
            //
            const SizedBox(height: 25),
            CustomHeaderViewExpandable(
              isNeedToShowLeftRightBottomBorder: false,
              isNeedToShowLeftImage: true,
              isExpanded: false,
              title: "START GAME",
              headerColor: AppColors.primaryDark,
              arrowBackgroundColor: isLocked
                  ? AppColors.white
                  : AppColors.extraDarkYellow,
              arrowFrontColor: Colors.black,
              isExpandedViewAvailable: true,
              fontStyle: AppTextStyles.regular(16).copyWith(
                height: 1.0,
                color: AppColors.whiteWithExpandableTitle,
              ),
              isLeftImage: IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.quizLockArrow),
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
              onHeaderTap: isLocked ? null : onStart,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
