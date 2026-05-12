import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/constantImages.dart';

class ChatAnalyzingIndicator extends StatefulWidget {
  const ChatAnalyzingIndicator({super.key});

  @override
  State<ChatAnalyzingIndicator> createState() => _AnalyzingIndicatorState();
}

class _AnalyzingIndicatorState extends State<ChatAnalyzingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    duration: const Duration(milliseconds: 1200), 
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildBotAvatarOrUser() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 2),
      child: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.wilcoChatBoat),
        height: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        // 0→1→2→3→0→1→2→3 (perfectly equal 300ms each)
        final step = (_ctrl.value * 4).floor() % 4;

        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBotAvatarOrUser(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final isActive = index < step;

                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? const Color(0xFFE0B12F)
                              : const Color(0xFF2D235A),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
