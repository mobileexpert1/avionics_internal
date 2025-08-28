import 'package:flutter/material.dart';
import 'InfoClick.dart';

OverlayEntry? _activeTooltip;

void showInfoTooltip({
  required BuildContext context,
  required GlobalKey key,
  required List<String> message,
  TooltipPosition position = TooltipPosition.below,
}) {
  _activeTooltip?.remove();
  _activeTooltip = null;

  final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);
  final screenSize = MediaQuery.of(context).size;

  const tooltipWidth = 260.0;
  const tooltipHeight = 80.0;

  double left = offset.dx;
  double top = offset.dy;

  switch (position) {
    case TooltipPosition.above:
      left = offset.dx - (tooltipWidth / 2) + (size.width / 2);
      top = offset.dy - tooltipHeight - 10;
      break;
    case TooltipPosition.below:
      left = offset.dx - (tooltipWidth / 2) + (size.width / 2);
      top = offset.dy + size.height + 10;
      break;
    case TooltipPosition.left:
      left = offset.dx - tooltipWidth - 10;
      top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
      break;
    case TooltipPosition.right:
      left = offset.dx + size.width + 10;
      top = offset.dy + (size.height / 2) - (tooltipHeight / 2);
      break;
  }

  // Clamp values to prevent overflow
  left = left.clamp(10.0, screenSize.width - tooltipWidth - 10.0);
  top = top.clamp(10.0, screenSize.height - tooltipHeight - 10.0);

  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (_) => Positioned(
      left: left,
      top: top,
      child: Material(
        color: Colors.transparent,
        child: InfoTooltip(message: message.join('\n')),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  _activeTooltip = overlayEntry;

  // Auto-hide after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    if (_activeTooltip == overlayEntry) {
      _activeTooltip?.remove();
      _activeTooltip = null;
    }
  });
}


enum TooltipPosition { above, below, left, right }
