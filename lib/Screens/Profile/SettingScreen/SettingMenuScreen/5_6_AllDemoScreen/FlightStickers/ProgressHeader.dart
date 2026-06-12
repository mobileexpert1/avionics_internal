import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int unlocked;
  final int total;

  const ProgressHeader({
    super.key,
    required this.unlocked,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : unlocked / total;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Sticker Unlock Progress",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                "$unlocked/$total",
                style: const TextStyle(
                  color: Color(0xff3B82F6),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              const planeSize = 30.0;
              const barHeight = 9.0;

              final planePosition = (constraints.maxWidth) * progress;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: barHeight,
                      width: planePosition + (planeSize / 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    left: planePosition + (progress == 1.0 ? -15 : 15),
                    top: (planeSize - 51) / 2,

                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: const Icon(
                        Icons.airplanemode_active,
                        size: planeSize,
                        color: Color(0xFF4A90D9),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
