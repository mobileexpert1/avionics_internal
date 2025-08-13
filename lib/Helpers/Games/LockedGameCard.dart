import 'package:avionics_internal/Helpers/Games/tooltip_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Constants/constantImages.dart';

class LockGameCard extends StatefulWidget {
  final String title;
  final bool isLocked;
  final VoidCallback? onTap;
  final VoidCallback? onInfoTap;
  final String infoMessage;

  const LockGameCard({
    super.key,
    required this.title,
    required this.isLocked,
    required this.infoMessage,
    this.onTap,
    this.onInfoTap,
  });

  @override
  State<LockGameCard> createState() => _LockGameCardState();
}

class _LockGameCardState extends State<LockGameCard> {
  final GlobalKey _infoIconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.isLocked ? null : widget.onTap,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300, width: 0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.isLocked
                        ? Colors.grey
                        : const Color(0xFF3F3D56),
                  ),
                ),
                const SizedBox(height: 46),
                ElevatedButton(
                  onPressed: widget.isLocked ? null : widget.onTap,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40), // Ensures proper width & height
                    backgroundColor: widget.isLocked
                        ? Colors.grey.shade300
                        : const Color(0xFF3F3D56),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Play game',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isLocked ? Colors.grey : Colors.white,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        if (widget.isLocked)
          Positioned(
            top: 60,
            left: 0,
            right: 5,
            child: Center(
              child: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.LockIcon),
                height: 50,
                width: 50,
                color: const Color(0xFF1E80F2),
              ),
            ),
          ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            key: _infoIconKey,
            onTap: () {
              showInfoTooltip(
                context: context,
                key: _infoIconKey,
                message: widget.infoMessage,
                position:  TooltipPosition.below,
              );
            },
            child: const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
