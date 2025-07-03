// lib/repositories/chat_repository_impl.dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'chat_model.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl();                               // ❌ no singleton

  // ───────── stream of ChatMessage ─────────
  final _controller = StreamController<ChatMessage>.broadcast();
  @override
  Stream<ChatMessage> get messages => _controller.stream;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSub;

  String? _sessionId;
  String? _accessToken;
  Timer?  _pingTimer;                                 // keeps socket alive
  bool _closing = false;

  // ─────────────────────────────────────────
  @override
  Future<void> connect({required String accessToken}) async {
    _closing = false;                // reset flag on every fresh connect
    _accessToken = accessToken;

    // restore saved session-id if any
    final prefs   = await SharedPreferences.getInstance();
    _sessionId    = prefs.getString('wilco_session_id');

    final endpoint = _sessionId == null
        ? 'ws://192.168.14.4:8010/ai-engine/wilco/new-session?token=$accessToken'
        : 'ws://192.168.14.4:8010/ai-engine/wilco/session/$_sessionId?token=$accessToken';

    _channel = WebSocketChannel.connect(Uri.parse(endpoint));
    _socketSub = _channel!.stream.listen(
      _onData,
      onError: _onError,
      onDone:  _onDone,
      cancelOnError: true,
    );

    // optional 20-second ping so backend doesn’t idle-timeout
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      _channel?.sink.add(jsonEncode({'ping': true}));
    });
  }

  // ───────── send user message ─────────
  @override
  void send(String text) {
    final payload = jsonEncode({'query': text});
    _channel?.sink.add(payload);

    if (!_controller.isClosed) {
      _controller.add(ChatMessage(author: ChatAuthor.user, text: text));
    }
  }

  // ───────── graceful teardown ─────────
  @override
  Future<void> dispose() async {
    _closing = true;
    await _socketSub?.cancel();
    await _channel?.sink.close(status.normalClosure);
    _pingTimer?.cancel();
    // close the stream: OK because this repo lives exactly as long as the screen
    await _controller.close();
  }

  // ───────── private helpers ─────────
  void _onData(dynamic data) async {
    final decoded = jsonDecode(data as String);

    // save session-id once
    if ((_sessionId ?? '').isEmpty && decoded['session_id'] != null) {
      _sessionId = decoded['session_id'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wilco_session_id', _sessionId!);
    }

    final answer = decoded['answer'] as String?;
    if (answer != null && !_controller.isClosed) {
      _controller.add(ChatMessage(author: ChatAuthor.bot, text: answer));
    }
  }

  void _onError(Object error) {
    if (!_controller.isClosed) {
      _controller.add(ChatMessage(
          author: ChatAuthor.bot, text: '⚠️ Connection error: $error'));
    }
  }

  void _onDone() {
    if (_closing) return;            // we intentionally disposed

    if (!_controller.isClosed) {
      _controller.add(ChatMessage(
          author: ChatAuthor.bot, text: '⚠️ Disconnected. Rejoining…'));
    }

    // simple auto-reconnect
    Future.delayed(const Duration(seconds: 2), () {
      if (!_closing && _accessToken != null) {
        connect(accessToken: _accessToken!);
      }
    });
  }
}
