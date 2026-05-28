import 'dart:math' as math;

import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_cubit.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/AppColors.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import '../QuizSection/QuizLockScreen.dart';
import '../QuizSection/QuizQuestionScreen.dart';

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
    double getPadding() => isWeb ? screenWidth * 0.02 : 15;
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          centerTitle: false,
          title: ConstantStrings.calculationsTitle,
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
              child: BlocBuilder<CalculationCubit, CalculationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
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
                          "Sharpen your aviation math with real-time \nchallenges",
                          style: AppTextStyles.semiRegular(18).copyWith(
                            height: 1.3,
                            color: AppColors.primaryValueColour,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.games.length,
                          itemBuilder: (context, index) {
                            final calculationGameItem = state.games[index];
                            final isLast = index == state.games.length - 1;
                            return _CourseStepRow(
                              calculationGameItem: calculationGameItem,
                              isLast: isLast,
                              index: index,
                              onTap: () {
                                if (!calculationGameItem.isLocked) {
                                  AppNavigator.push(
                                    context,
                                    QuizQuestionScreen(
                                      sectionId: calculationGameItem.gameNumber,
                                      sectionTitle:
                                          ConstantStrings.calculationsTitle,
                                      gameId: "calculation",
                                    ),
                                    disableSwipeBack: true,
                                  );
                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.calculationsLockButton,
                                    FirebaseEvents.calculationsLockListScreen,
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

class _CourseStepRow extends StatefulWidget {
  final QuizPerItem calculationGameItem;
  final bool isLast;
  final int index;
  final VoidCallback? onTap;

  const _CourseStepRow({
    required this.calculationGameItem,
    required this.isLast,
    required this.index,
    this.onTap,
  });

  @override
  State<_CourseStepRow> createState() => _CourseStepRowState();
}

class _CourseStepRowState extends State<_CourseStepRow> {
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
    final bool lineIsDark = !widget.calculationGameItem.isLocked;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35,
          child: Column(
            children: [
              _StepIndicator(calculationGameItem: widget.calculationGameItem),
              if (!widget.isLast)
                CustomPaint(
                  size: Size(0, _cardHeight),
                  painter: _DashedLinePainter(isDark: lineIsDark),
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
          child: _CourseCard(
            key: _cardKey,
            calculationGameItem: widget.calculationGameItem,
            index: widget.index,
            onTap: widget.onTap ?? () {},
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatefulWidget {
  final QuizPerItem calculationGameItem;
  final int index;
  final VoidCallback onTap;

  const _CourseCard({
    super.key,
    required this.calculationGameItem,
    required this.index,
    required this.onTap,
  });

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
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
                offset: Offset(-13, 0),
                child: ArrowPopup(
                  isLocked: widget.calculationGameItem.isLocked,
                  infoDetails: widget.calculationGameItem.info.first,
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
    final bool isActive = !widget.calculationGameItem.isLocked;
    final images = returnCalculationImages(widget.calculationGameItem.title);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        // ← Pura card tappable
        onTap: _showPopup, // ← Card tap = popup show
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  isActive
                      ? CommonUi.setSvgImage(images[1])
                      : CommonUi.setSvgImage(images[0]),
                  width: 55,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                onPressed: _showPopup, // ← Icon tap = bhi popup
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.calculationGameItem.title,
                      style: AppTextStyles.bold(16).copyWith(
                        height: 1.2,
                        color: AppColors.primaryValueColour,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      returnCalculationDescription(
                        widget.calculationGameItem.title,
                      ),
                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(height: 1.6, color: AppColors.grayMedium),
                    ),
                  ],
                ),
              ),

              if (isActive)
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.backArrowButton),
                      fit: BoxFit.cover,
                      color: Colors.black,
                    ),
                    onPressed: _showPopup, // ← Arrow tap = bhi popup
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final QuizPerItem calculationGameItem;

  const _StepIndicator({required this.calculationGameItem});

  @override
  Widget build(BuildContext context) {
    if (!calculationGameItem.isLocked) {
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

class _DashedLinePainter extends CustomPainter {
  final bool isDark;

  const _DashedLinePainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final lineColor = isDark
        ? const Color(0xFF2D2D54)
        : const Color(0xFFCCCCDD);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    canvas.drawCircle(Offset(cx, 4), 3, dotPaint);

    const dashHeight = 6.0;
    const dashSpace = 4.0;
    double startY = 12.0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(cx, startY),
        Offset(cx, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
