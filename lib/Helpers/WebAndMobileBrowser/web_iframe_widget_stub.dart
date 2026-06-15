import 'package:flutter/material.dart';

class WebIframeWidget extends StatelessWidget {
  final String url;

  const WebIframeWidget({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}