import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CustomHeaderViewExpandable extends StatelessWidget {
  final bool isNeedToShowLeftRightBottomBorder;
  final bool isNeedToShowLeftImage;
  final IconButton? isLeftImage;
  final bool isExpanded;
  final String title;
  final Color headerColor;
  final Color arrowBackgroundColor;
  final Color arrowFrontColor;
  final bool isExpandedViewAvailable;
  final VoidCallback? onHeaderTap;
  final Widget? child;
  final TextStyle fontStyle;
  final TextAlign? textAlign;

  const CustomHeaderViewExpandable({
    super.key,
    required this.isNeedToShowLeftRightBottomBorder,
    required this.isNeedToShowLeftImage,
    required this.isExpanded,
    required this.title,
    required this.headerColor,
    required this.arrowBackgroundColor,
    required this.arrowFrontColor,
    required this.isExpandedViewAvailable,
    this.onHeaderTap,
    this.isLeftImage,
    this.child,
    this.textAlign,
    required this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNeedToShowLeftRightBottomBorder == true
              ? Colors.transparent
              : Colors.black12,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: isExpandedViewAvailable ? onHeaderTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isNeedToShowLeftImage
                        ? (kIsWeb ? 16 : 10)
                        : (kIsWeb ? 20 : 15),

                    vertical: isNeedToShowLeftImage
                        ? (kIsWeb ? 12 : 3)
                        : (kIsWeb ? 22 : 16),
                  ),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(12),
                      bottom: Radius.circular(isExpanded ? 0 : 12),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isNeedToShowLeftImage) ...[
                        isLeftImage!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: fontStyle,
                          textAlign: textAlign,
                        ),
                      ),
                      SizedBox(width: kIsWeb ? 70 : 50),
                    ],
                  ),
                ),

                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: kIsWeb ? 65 : 52,
                    decoration: BoxDecoration(
                      color: arrowBackgroundColor,
                      borderRadius: isExpanded
                          ? const BorderRadius.vertical(
                        top: Radius.circular(12),
                      )
                          : BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: arrowFrontColor,
                          size: kIsWeb ? 24 : 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          /// Expandable Custom View
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: isExpanded
                ? Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: child ?? const SizedBox(),
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

