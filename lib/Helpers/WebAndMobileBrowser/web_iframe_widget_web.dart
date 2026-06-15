import 'dart:ui_web' as ui;
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;

class WebIframeWidget extends StatefulWidget {
  final String url;

  const WebIframeWidget({
    super.key,
    required this.url,
  });

  @override
  State<WebIframeWidget> createState() => _WebIframeWidgetState();
}

class _WebIframeWidgetState extends State<WebIframeWidget> {
  late String _viewId;

  @override
  void initState() {
    super.initState();

    _viewId = 'iframe-view-${widget.url.hashCode}';

    ui.platformViewRegistry.registerViewFactory(
      _viewId,
          (int id) {
        return html.IFrameElement()
          ..src = widget.url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return const SizedBox.shrink();
    }

    return HtmlElementView(
      viewType: _viewId,
    );
  }
}