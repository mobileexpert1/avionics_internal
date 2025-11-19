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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb;

    double getResponsiveFont(double mobile, double web) => isWeb ? web : mobile;
    double getButtonWidth() => isWeb ? screenWidth * 0.15 : 120;
    double getIconSize() => isWeb ? 60 : 40;
    double getPadding() => isWeb ? screenWidth * 0.02 : 8;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300, width: 0.8),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getPadding()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isWeb ? 30 : 20),
                  // Title
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getResponsiveFont(15, 22),
                      fontWeight: FontWeight.bold,
                      color: widget.isLocked ? Colors.grey : const Color(0xFF3F3D56),
                    ),
                  ),

                  SizedBox(height: isWeb ? 60 : 40),

                  // Play Button
                  ElevatedButton(
                    onPressed: widget.isLocked ? null : widget.onTap,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(getButtonWidth(), isWeb ? 50 : 40),
                      backgroundColor:
                      widget.isLocked ? Colors.grey.shade300 : const Color(0xFF3F3D56),
                      padding: EdgeInsets.symmetric(horizontal: isWeb ? 24 : 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Play game',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: getResponsiveFont(14, 18),
                        color: widget.isLocked ? Colors.grey : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LOCK ICON (if locked)
          if (widget.isLocked)
            Positioned(
              top: isWeb ? 60 : 46,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.LockIcon),
                  height: getIconSize(),
                  width: getIconSize(),
                  color: const Color(0xFF1E80F2),
                ),
              ),
            ),

          // INFO ICON (top-right)
          Positioned(
            top: isWeb ? 12 : 6,
            right: isWeb ? 12 : 6,
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
                if (widget.onInfoTap != null) widget.onInfoTap!();
              },
              child: Icon(
                Icons.info_outline_rounded,
                size: getResponsiveFont(18, 24),
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
