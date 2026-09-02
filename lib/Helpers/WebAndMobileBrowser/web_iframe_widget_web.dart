import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

typedef WebIframeMessageCallback = void Function(dynamic data);

class WebIframeWidget extends StatefulWidget {
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
  State<WebIframeWidget> createState() => _WebIframeWidgetState();
}

class _WebIframeWidgetState extends State<WebIframeWidget> {
  static int _viewCounter = 0;

  late final String _viewId;

  web.HTMLIFrameElement? _iframeElement;

  JSFunction? _messageListener;

  @override
  void initState() {
    super.initState();

    _viewId = 'avionica-iframe-${_viewCounter++}';

    _registerIframe();

    _messageListener = ((web.Event event) {
      if (event is web.MessageEvent) {
        _handleMessage(event);
      }
    }).toJS;

    web.window.addEventListener('message', _messageListener!);
  }

  void _registerIframe() {
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = widget.url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.display = 'block'
        ..style.pointerEvents = widget.ignorePointer ? 'none' : 'auto'
        ..allowFullscreen = true;

      _iframeElement = iframe;

      iframe.addEventListener(
        'load',
        ((web.Event event) {
          debugPrint('[WebIframeWidget] iframe loaded: ${widget.url}');
        }).toJS,
      );

      return iframe;
    });
  }

  void _handleMessage(web.MessageEvent event) {
    debugPrint(
      '[WebIframeWidget] message received: '
      'data=${event.data} '
      'origin=${event.origin}',
    );

    const allowedIframeOrigin = 'https://avionica.csdevhub.com';

    if (event.origin != allowedIframeOrigin) {
      debugPrint(
        '[WebIframeWidget] Ignored message from unexpected origin: '
        '${event.origin}',
      );
      return;
    }

    dynamic data;

    try {
      data = event.data.dartify();
    } catch (_) {
      data = event.data;
    }

    debugPrint('[WebIframeWidget] Forwarding message to Flutter: $data');

    widget.onMessageReceived?.call(data);
  }

  @override
  void didUpdateWidget(covariant WebIframeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.ignorePointer != widget.ignorePointer) {
      _iframeElement?.style.pointerEvents = widget.ignorePointer
          ? 'none'
          : 'auto';
    }

    if (oldWidget.url != widget.url) {
      _iframeElement?.src = widget.url;
    }
  }

  @override
  void dispose() {
    final listener = _messageListener;

    if (listener != null) {
      web.window.removeEventListener('message', listener);
    }

    _iframeElement = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return const SizedBox.shrink();
    }

    return HtmlElementView(viewType: _viewId);
  }
}
