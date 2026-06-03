import 'package:avionics_internal/Constants/AppColors.dart';
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
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import '../QuizSection/QuizLockScreen.dart';
import '../QuizSection/QuizQuestionScreen.dart';

class OneWordTopicScreen extends StatefulWidget {
  const OneWordTopicScreen({super.key});

  @override
  _OneWordTopicScreenState createState() => _OneWordTopicScreenState();
}

class _OneWordTopicScreenState extends State<OneWordTopicScreen> {
  late OneWordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OneWordCubit();
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
    double getPadding() => isWeb ? screenWidth * 0.02 : 16;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          centerTitle: false,
          title: 'Basic Topics',
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
                    "Pick Your Aviation Challenge \nChoose a topic and put your knowledge to the test",
                    style: AppTextStyles.semiRegular(
                      16,
                    ).copyWith(height: 1.2, color: AppColors.greyForTextfield),
                  ),

                  SizedBox(height: isWeb ? 20 : 16),

                  Expanded(
                    child: BlocBuilder<OneWordCubit, OneWordTopicState>(
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

                        return ListView.separated(
                          separatorBuilder: (_, _) =>
                              SizedBox(height: isWeb ? 16 : 12),
                          itemBuilder: (context, index) {
                            final game = state.games[index];

                            return _TopicCard(
                              title: game.title,
                              subtitle: getConstantDescriptionForBasic(
                                game.gameNumber,
                              ),
                              iconAsset: getAssetImageForBasic(game.gameNumber),
                              isWeb: isWeb,
                              onTap: () {
                                AppNavigator.push(
                                  context,
                                  QuizQuestionScreen(
                                    sectionId: game.gameNumber,
                                    sectionTitle: game.title,
                                    gameId: "one_word",
                                  ),
                                  disableSwipeBack: true,
                                );
                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.oneWordTopicListScreen,
                                  FirebaseEvents.oneWordTopicButton,
                                );
                              },
                              index: index,
                            );
                          },
                          itemCount: state.games.length,
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

class _TopicCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconAsset;
  final bool isWeb;
  final int index;
  final VoidCallback onTap;

  const _TopicCard({
    required this.title,
    required this.subtitle,
    required this.isWeb,
    required this.onTap,
    required this.iconAsset,
    required this.index,
  });

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard> {
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
                offset: Offset(
                  20,
                  widget.index == 4 || widget.index == 5 ? -100 : 0,
                ),
                child: ArrowPopup(
                  isLocked: false,
                  infoDetails: widget.subtitle,
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
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showPopup,
        child: Container(
          height: widget.isWeb ? 100 : 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(widget.isWeb ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: widget.isWeb ? 18 : 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),

                      if (widget.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),

                        Text(
                          widget.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: widget.isWeb ? 13 : 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Container(
                  width: widget.isWeb ? 80 : 75,
                  color: AppColors.primaryBlue,
                  child: Center(
                    child: SvgPicture.asset(
                      CommonUi.setSvgImage(widget.iconAsset),
                      width: widget.isWeb ? 36 : 40,
                      height: widget.isWeb ? 36 : 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
