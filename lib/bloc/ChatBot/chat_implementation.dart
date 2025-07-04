import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'chat_model.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl();
  final _controller = StreamController<ChatMessage>.broadcast();
  @override
  Stream<ChatMessage> get messages => _controller.stream;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSub;

  String? _sessionId;
  String? _accessToken;
  bool    _closing = false;
  int     _retries    = 0;
  String? _lastSystem;

  @override
  Future<void> connect({required String accessToken}) async {
    _closing     = false;
    _accessToken = accessToken;
    _retries     = 0;

    final prefs = await SharedPreferences.getInstance();
    _sessionId  = prefs.getString('wilco_session_id');

    return _openSocket();
  }

  @override
  void send(String text) {
    _channel?.sink.add(jsonEncode({'query': text}));
    _controller.add(ChatMessage(author: ChatAuthor.user, text: text));
  }

  @override
  Future<void> dispose() async {
    _closing = true;
    await _socketSub?.cancel();
    await _channel?.sink.close(status.normalClosure);
    await _controller.close();
  }

  Future<void> _openSocket() async {
    final endpoint = _sessionId == null
        ? 'ws://192.168.14.4:8010/ai-engine/wilco/new-session?token=$_accessToken'
        : 'ws://192.168.14.4:8010/ai-engine/wilco/session/$_sessionId?token=$_accessToken';

    _channel = IOWebSocketChannel.connect(
      Uri.parse(endpoint),
      pingInterval: const Duration(seconds: 25),
    );

    _socketSub = _channel!.stream.listen(
      _onData,
      onError: _onError,
      onDone:  _onDone,
      cancelOnError: true,
    );
  }

  void _onData(dynamic data) async {
    final decoded = jsonDecode(data as String);

    if ((_sessionId ?? '').isEmpty && decoded['session_id'] != null) {
      _sessionId = decoded['session_id'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wilco_session_id', _sessionId!);
    }

    final answer = decoded['answer'] as String?;
    if (answer != null) {
      _controller.add(ChatMessage(author: ChatAuthor.bot, text: answer));
    }
  }

  void _onError(Object error) {
    _pushSystem('⚠️ Connection error: $error');
  }

  void _onDone() {
    if (_closing) return;

    _pushSystem('⚠️ Disconnected. Re‑joining…');

    _retries = (_retries + 1).clamp(1, 5);
    final delay = Duration(seconds: 2 << (_retries - 1));

    Future.delayed(delay, () {
      if (!_closing && _accessToken != null) _openSocket();
    });
  }

  void _pushSystem(String text) {
    if (_controller.isClosed) return;
    if (_lastSystem == text) return;
    _lastSystem = text;
    _controller.add(ChatMessage(author: ChatAuthor.bot, text: text));
  }
}

