import 'package:avionics_internal/Helpers/Games/tooltip_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Constants/constantImages.dart';

class LockGameCard extends StatefulWidget {
  final String title;
  final bool isLocked;
  final VoidCallback? onTap;
  final VoidCallback? onInfoTap;
  final List<String> infoMessage;

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
    final isWeb = kIsWeb;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.9),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // INFO ICON
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              key: _infoIconKey,
              onTap: () {
                showInfoTooltip(
                  context: context,
                  key: _infoIconKey,
                  message: widget.infoMessage.isNotEmpty
                      ? widget.infoMessage.map((item) => "• $item").toList()
                      : ["No info available"],
                  position: TooltipPosition.below,
                );
                widget.onInfoTap?.call();
              },
              child: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.infoIcon2),
                width: isWeb ? 22 : 20,
                height: isWeb ? 22 : 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWeb ? 20 : 16,
                fontWeight: FontWeight.bold,
                color: widget.isLocked ? Colors.grey : const Color(0xFF3F3D56),
              ),
            ),
          ),

          // WEB & MOBILE DIFFERENT MIDDLE SPACING

          // if (!isWeb) const Spacer(),
          //
          SizedBox(
            height: (widget.isLocked
                ? MediaQuery.of(context).size.width * 0.03
                : MediaQuery.of(context).size.width * 0.048),
          ),

          // LOCK ICON
          if (widget.isLocked)
            SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.LockIcon),
              height: isWeb ? 45 : 36,
              color: const Color(0xFF1E80F2),
            ),

          SizedBox(
            height: (widget.isLocked
                ? MediaQuery.of(context).size.width * 0.03
                : MediaQuery.of(context).size.width * 0.057),
          ),

          // PLAY BUTTON
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: widget.isLocked ? null : widget.onTap,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: widget.isLocked
                    ? Colors.grey.shade300
                    : const Color(0xFF3F3D56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Play game',
                style: TextStyle(
                  fontSize: isWeb ? 18 : 14,
                  color: widget.isLocked ? Colors.grey : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
