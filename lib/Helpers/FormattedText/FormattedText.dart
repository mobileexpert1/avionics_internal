import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color normalColor;
  final Color boldColor;
  final FontWeight boldWeight;
  final double lineHeight;

  const FormattedText({
    Key? key,
    required this.text,
    this.fontSize = 14,
    this.normalColor = Colors.black87,
    this.boldColor = Colors.black,
    this.boldWeight = FontWeight.bold,
    this.lineHeight = 1.47,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      _buildFormattedText(text),
      textAlign: TextAlign.start,
    );
  }

  TextSpan _buildFormattedText(String text) {
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(r'(\*\*.*?\*\*|\*.*?\*)');
    final matches = exp.allMatches(text);

    int lastIndex = 0;

    TextStyle normalStyle = TextStyle(
      fontSize: fontSize,
      color: normalColor,
      height: lineHeight,
    );

    TextStyle boldStyle = TextStyle(
      fontSize: fontSize,
      color: boldColor,
      fontWeight: boldWeight,
      height: lineHeight,
    );

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: normalStyle,
          ),
        );
      }

      String cleanText = match.group(0)!.replaceAll(RegExp(r'\*'), '');

      spans.add(TextSpan(text: cleanText, style: boldStyle));

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: normalStyle));
    }

    return TextSpan(children: spans);
  }
}
