import 'dart:math' as math;

import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/BlackBox_Section/blackBox_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/MainGameExtraClasses/DashedLinePainter.dart';
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackbox_cubit.dart';
import '../../../../bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import '../QuizSection/QuizLockScreen.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;

    final isWeb = kIsWeb;
    double getPadding() => isWeb ? screenWidth * 0.02 : 10;
    return BlocProvider(
      create: (_) => blackboxCubit,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: CustomAppBar(
          title: 'Black Box',
          centerTitle: false,
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 10),
                        child: Text(
                          "Enhance your aviation investigation skills with interactive black box challenges.",
                          style: AppTextStyles.semiRegular(16).copyWith(
                            height: 1.3,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.games.length,
                          itemBuilder: (context, index) {
                            final blackBoxGameItem = state.games[index];
                            final isLast = index == state.games.length - 1;
                            return _BlackBoxStepRow(
                              blackBoxGameItem: blackBoxGameItem,
                              isLast: isLast,
                              index: index,
                              onTap: () {
                                if (!blackBoxGameItem.isLocked) {
                                  AppNavigator.push(
                                    context,
                                    OverviewAndClueDeckScreen(
                                      gameNo: blackBoxGameItem.gameNumber,
                                    ),
                                    disableSwipeBack: true,
                                  );

                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.quizListLockButton,
                                    FirebaseEvents.quizLockListScreen,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
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

class _BlackBoxStepRow extends StatefulWidget {
  final QuizPerItem blackBoxGameItem;
  final bool isLast;
  final int index;
  final VoidCallback? onTap;

  const _BlackBoxStepRow({
    required this.blackBoxGameItem,
    required this.isLast,
    required this.index,
    this.onTap,
  });

  @override
  State<_BlackBoxStepRow> createState() => _BlackBoxStepRowState();
}

class _BlackBoxStepRowState extends State<_BlackBoxStepRow> {
  final GlobalKey _cardKey = GlobalKey();
  double _cardHeight = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _cardKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _cardHeight = renderBox.size.height - 30;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool lineIsDark = !widget.blackBoxGameItem.isLocked;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35,
          child: Column(
            children: [
              _StepIndicator(blackBoxGameItem: widget.blackBoxGameItem),
              if (!widget.isLast)
                CustomPaint(
                  size: Size(0, _cardHeight),
                  painter: DashedLinePainter(isDark: lineIsDark),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: const Icon(
              Icons.play_arrow,
              size: 20,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        Expanded(
          child: _BlackBoxCard(
            key: _cardKey,
            blackBoxGameItem: widget.blackBoxGameItem,
            index: widget.index,
            onTap: widget.onTap ?? () {},
          ),
        ),
      ],
    );
  }
}

class _BlackBoxCard extends StatefulWidget {
  final QuizPerItem blackBoxGameItem;
  final int index;
  final VoidCallback onTap;

  const _BlackBoxCard({
    super.key,
    required this.blackBoxGameItem,
    required this.index,
    required this.onTap,
  });

  @override
  State<_BlackBoxCard> createState() => _BlackBoxCardState();
}

class _BlackBoxCardState extends State<_BlackBoxCard> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _hasInfo => widget.blackBoxGameItem.info.isNotEmpty;

  void _showPopup() {
    if (_overlayEntry != null || !_hasInfo) return;

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
                offset: const Offset(-0, -25),
                child: ArrowPopup(
                  isLocked: widget.blackBoxGameItem.isLocked,
                  infoDetails: widget.blackBoxGameItem.info.first,
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
    final bool isActive = !widget.blackBoxGameItem.isLocked;
    final images = returnCalculationAndBlackBoxImages(
      widget.blackBoxGameItem.title,
      true,
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _hasInfo ? _showPopup : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.blackBoxGameItem.title,
                      style: AppTextStyles.bold(16).copyWith(
                        height: 1.2,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      returnCalculationAndBlackBoxDescription(
                        widget.blackBoxGameItem.title,
                        true,
                      ),
                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(height: 1.4, color: AppColors.grayMedium),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _hasInfo ? _showPopup : null,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryDark
                              : AppColors.grayLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                CommonUi.setPngImage(images[0]),
                width: 110,
                height: 110,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final QuizPerItem blackBoxGameItem;

  const _StepIndicator({required this.blackBoxGameItem});

  @override
  Widget build(BuildContext context) {
    if (!blackBoxGameItem.isLocked) {
      return Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(top: 12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF2D2D54),
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    }

    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCCCCDD), width: 1.5),
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Color(0xFF9999AA),
        size: 18,
      ),
    );
  }
}
