import 'package:flutter/widgets.dart';

typedef WebIframeMessageCallback = void Function(
    dynamic data,
    );

class WebIframeWidget extends StatelessWidget {
  final String url;
  final WebIframeMessageCallback? onMessageReceived;
  final bool ignorePointer;

  const WebIframeWidget({
    super.key,
    required this.url,
    this.onMessageReceived,
    this.ignorePointer = false,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}