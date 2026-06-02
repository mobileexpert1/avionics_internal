import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LevelNodeModel {
  final int level;
  final Offset position;
  final bool isUnlocked;
  final bool isCompleted;
  final bool? isLeftSide;

  LevelNodeModel({
    required this.level,
    required this.position,
    required this.isUnlocked,
    required this.isCompleted,
    this.isLeftSide,
  });

  LevelNodeModel copyWith({bool? isUnlocked, bool? isCompleted}) {
    return LevelNodeModel(
      level: level,
      position: position,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      isLeftSide: isLeftSide ?? this.isLeftSide,
    );
  }
}

// ✅ FIX 1: cubicTo use kiya — proper S-curve banata hai screenshot jaisa
class AnimatedPathPainter extends CustomPainter {
  final List<Offset> points;
  final double progress;

  AnimatedPathPainter({required this.points, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1B5E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (points.isEmpty) return;

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : points[i + 1];

      const tension = 0.35;

      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension,
        p1.dy + (p2.dy - p0.dy) * tension,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension,
        p2.dy - (p3.dy - p1.dy) * tension,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    final metrics = path.computeMetrics().toList();
    for (final metric in metrics) {
      final extractPath = metric.extractPath(0, metric.length * progress);
      _drawDashedPath(canvas, extractPath, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 5.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final nextDistance = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedPathPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.points != points;
  }
}

class LevelNodeWidget extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isLeftSide;
  final VoidCallback onTap;

  const LevelNodeWidget({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isLeftSide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = isUnlocked || isCompleted;
    final Color bgColor = active
        ? const Color(0xFF1E1B5E)
        : Colors.grey.shade400;

    final icon =
        Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: const Icon(Icons.flight, color: Colors.white),
            )
            .animate(target: active ? 1 : 0)
            .scale(
              begin: const Offset(0.85, 0.85),
              end: const Offset(1.0, 1.0),
              duration: 700.ms,
              curve: Curves.easeOutBack,
            );

    final label = Text(
      'Level $level',
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    );

    return GestureDetector(
      onTap: active ? onTap : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: isLeftSide
            ? [label, const SizedBox(width: 8), icon] // text → icon
            : [icon, const SizedBox(width: 8), label], // icon → text
      ),
    );
  }
}

class PlaneWidget extends StatelessWidget {
  const PlaneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: const Icon(Icons.flight_takeoff, color: Color(0xFF1E1B5E)),
    );
  }
}

class ApiLevelModel {
  final int level;
  final bool isUnlocked;
  final bool isCompleted;

  ApiLevelModel({
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
  });

  factory ApiLevelModel.fromJson(Map<String, dynamic> json) {
    return ApiLevelModel(
      level: json['level'],
      isUnlocked: json['is_unlocked'],
      isCompleted: json['is_completed'],
    );
  }
}

class AnimatedLevelMapScreen extends StatefulWidget {
  const AnimatedLevelMapScreen({super.key});

  @override
  State<AnimatedLevelMapScreen> createState() => _AnimatedLevelMapScreenState();
}

class _AnimatedLevelMapScreenState extends State<AnimatedLevelMapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final ScrollController _scrollController = ScrollController();
  int currentSegment = 0;
  bool isPlaneVisible = false;
  List<LevelNodeModel> levels = [];

  static const double _levelSpacing = 130.0;
  static const double _topPadding = 120.0;
  static const double _bottomPadding = 160.0;

  double get _contentHeight =>
      (levels.isEmpty ? 0 : (levels.length - 1)) * _levelSpacing +
      _topPadding +
      _bottomPadding;

  List<LevelNodeModel> _buildLevels(
    List<ApiLevelModel> apiLevels,
    double screenWidth,
  ) {
    final double leftX = screenWidth * 0.25;
    final double rightX = screenWidth * 0.72;
    final int total = apiLevels.length;

    return apiLevels.asMap().entries.map((entry) {
      final int index = entry.key;
      final ApiLevelModel api = entry.value;

      final double y = _bottomPadding + (total - 1 - index) * _levelSpacing;
      final double x = index.isEven ? leftX : rightX;

      return LevelNodeModel(
        level: api.level,
        position: Offset(x, y),
        isUnlocked: api.isUnlocked,
        isCompleted: api.isCompleted,
      );
    }).toList();
  }

  Future<void> _loadLevels() async {
    final List<ApiLevelModel> apiResponse = [
      ApiLevelModel(level: 1, isUnlocked: true, isCompleted: true),
      ApiLevelModel(level: 2, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 3, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 4, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 5, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 6, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 7, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 8, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 9, isUnlocked: false, isCompleted: false),
      ApiLevelModel(level: 10, isUnlocked: false, isCompleted: false),
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      levels = _buildLevels(apiResponse, screenWidth);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Path _buildSegmentPath(List<Offset> points, int segmentIndex) {
    final p0 = segmentIndex > 0
        ? points[segmentIndex - 1]
        : points[segmentIndex];
    final p1 = points[segmentIndex];
    final p2 = points[segmentIndex + 1];
    final p3 = segmentIndex < points.length - 2
        ? points[segmentIndex + 2]
        : points[segmentIndex + 1];

    const tension = 0.35;
    final cp1 = Offset(
      p1.dx + (p2.dx - p0.dx) * tension,
      p1.dy + (p2.dy - p0.dy) * tension,
    );
    final cp2 = Offset(
      p2.dx - (p3.dx - p1.dx) * tension,
      p2.dy - (p3.dy - p1.dy) * tension,
    );

    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    return path;
  }

  Offset _getPositionOnPath(List<Offset> points, int segmentIndex, double t) {
    final path = _buildSegmentPath(points, segmentIndex);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return points[segmentIndex];

    final metric = metrics.first;
    final tangent = metric.getTangentForOffset(metric.length * t);
    return tangent?.position ?? points[segmentIndex];
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLevels());
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _moveToNext() {
    if (currentSegment >= levels.length - 1 || controller.isAnimating) return;

    setState(() => isPlaneVisible = true);

    controller.forward(from: 0).then((_) {
      setState(() {
        levels[currentSegment] = levels[currentSegment].copyWith(
          isCompleted: true,
        );
        currentSegment++;
        levels[currentSegment] = levels[currentSegment].copyWith(
          isUnlocked: true,
        );
        isPlaneVisible = false;
      });

      if (currentSegment <= 6) {
        _scrollController.animateTo(
          _scrollController.offset - _levelSpacing,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (levels.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final points = levels.map((e) => e.position).toList();
    final double contentHeight = _contentHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B5E),
        title: const Text('Demo SS', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: contentHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: AnimatedPathPainter(points: points, progress: 1.0),
                    size: Size.infinite,
                  ),

                  ...levels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final level = entry.value;
                    final bool isLeft = index.isEven;
                    return Positioned(
                      left: level.position.dx - (isLeft ? 65 : 18),
                      top: level.position.dy - 20,
                      child: LevelNodeWidget(
                        level: level.level,
                        isUnlocked: level.isUnlocked,
                        isCompleted: level.isCompleted,
                        isLeftSide: isLeft,
                        onTap: () => debugPrint("Tapped Level ${level.level}"),
                      ),
                    );
                  }),

                  if (isPlaneVisible)
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        final pos = _getPositionOnPath(
                          points,
                          currentSegment,
                          controller.value,
                        );
                        return Positioned(
                          left: pos.dx - 22,
                          top: pos.dy - 22,
                          child: const PlaneWidget(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: GestureDetector(
              onTap: _moveToNext,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 60,
                decoration: BoxDecoration(
                  color: currentSegment >= levels.length - 1
                      ? Colors.grey
                      : const Color(0xFF1E1B5E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    currentSegment >= levels.length - 1
                        ? 'Journey Complete! 🎉'
                        : 'Start your journey',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
