import 'dart:async';
import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:uuid/uuid.dart';

import '../../Database/auth_storage.dart';
import '../../Database/generic_methods.dart';
import 'chat_model.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl();

  final _controller = StreamController<ChatMessage>.broadcast();
  final _uuid = Uuid();
  final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);

  @override
  Stream<ChatMessage> get messages => _controller.stream;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSub;

  String? _sessionId;
  String? _accessToken;
  bool _closing = false;
  int _retries = 0;
  String? _lastSystem;
  String? _pendingUserMessage;
  ChatMessage? _pendingUserMessageObject;
  StreamSubscription<InternetConnectionStatus>? _internetStatusSub;
  bool _wasOffline = false;

  void startInternetMonitoring() {
    _internetStatusSub = InternetConnectionChecker().onStatusChange.listen((
      status,
    ) {
      if (status == InternetConnectionStatus.disconnected && !_wasOffline) {
        _wasOffline = true;
        _pushSystem(
          "Internet is disconnected. Kindly check your connection.🚫",
        );
      } else if (status == InternetConnectionStatus.connected && _wasOffline) {
        _wasOffline = false;

        _pushSystem("reconnecting...");

        Future.delayed(const Duration(seconds: 2), () {
          _pushSystem(
            "Connection established. you may now ask me for any queries..✅",
          );
        });
      }
    });
  }

  @override
  Future<void> connect({
    required String accessToken,
    String? existingSessionId,
  }) async {
    _closing = false;
    _accessToken = accessToken;
    _retries = 0;

    final prefs = await SharedPreferences.getInstance();
    _sessionId = existingSessionId ?? prefs.getString('wilco_session_id');

    final isNewSession = existingSessionId == null || existingSessionId.isEmpty;

    // 🟢 Only load local messages if it's NOT a new session
    if (!isNewSession && _sessionId != null && _sessionId!.isNotEmpty) {
      final localMsgs = await getMessagesForSession(_sessionId!);
      for (var msg in localMsgs) {
        _controller.add(msg);
      }
    } else {
      await prefs.remove('wilco_session_id');
    }

    await _openSocket();
    startInternetMonitoring();
  }

  Future<void> _openSocket() async {
    if (_accessToken == null || _accessToken!.isEmpty) {
      print('[WebSocket] Missing access token');
      return;
    }

    final isNewSession = _sessionId == null || _sessionId!.isEmpty;
    final endpoint = isNewSession
        ? 'wss://avionica.csdevhub.com/ai-engine/wilco/new-session?token=$_accessToken'
        : 'wss://avionica.csdevhub.com/ai-engine/wilco/session/$_sessionId?token=$_accessToken';

    print('[WebSocket] Connecting to: $endpoint');

    _channel = IOWebSocketChannel.connect(
      Uri.parse(endpoint),
      pingInterval: const Duration(seconds: 25),
    );

    _socketSub = _channel!.stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
    if (_pendingUserMessage != null) {
      Future.delayed(const Duration(seconds: 1), () {
        resendPendingMessageIfAny();
      });
    }
  }

  void _onData(dynamic data) async {
    print('[WebSocket] Received: $data');

    final decoded = jsonDecode(data as String);
    print('[WebSocket] Decoded: $decoded');

    if (decoded['error'] != null) {
      final errorMsg = decoded['error'] as String;
      _pushSystem("Internal Server Error: $errorMsg ❌");
      return;
    }
    // Save session ID only once for a new session
    if ((_sessionId ?? '').isEmpty && decoded['session_id'] != null) {
      _sessionId = decoded['session_id'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wilco_session_id', _sessionId!);

      if (_pendingUserMessage != null) {
        send(_pendingUserMessage!);
        _pendingUserMessage = null;
      }
    }

    final answer = decoded['answer'] as String?;
    if (answer != null) {
      final msg = ChatMessage(
        id: _uuid.v4(),
        author: ChatAuthor.bot,
        text: answer,
        sessionId: _sessionId ?? '',
      );
      _controller.add(msg);
      _saveChatMessage(msg);
      _pendingUserMessage = null;
      _pendingUserMessageObject = null;
    } else {
      print('[WebSocket] No "answer" in response');
    }
  }

  void _onError(Object error) {
    print('[WebSocket] Error: $error');

    final errorString = error.toString();
    final isServerError =
        errorString.contains('500') ||
        errorString.contains('504') ||
        errorString.contains('Internal Server Error') ||
        errorString.contains('Gateway Timeout');

    if (isServerError) {
      _pushSystem("Internal Server Error. Please try again later. ❌");
    } else {
      _pushSystem("Unexpected error occurred. Please try again. ⚠️");
    }
  }

  void _onDone() {
    if (_closing) return;

    _retries = (_retries + 1).clamp(1, 5);
    final delay = Duration(seconds: 2 << (_retries - 1));
    print('[WebSocket] Disconnected. Reconnecting in ${delay.inSeconds}s...');

    Future.delayed(delay, () {
      if (!_closing && _accessToken != null) {
        _openSocket();
      }
    });
  }

  @override
  void send(String text) {
    print('[WebSocket] Sending: $text');
    _channel?.sink.add(jsonEncode({'query': text}));

    if ((_sessionId ?? '').isEmpty) {
      _pendingUserMessage = text;
      return;
    }

    final msg = ChatMessage(
      id: _uuid.v4(),
      author: ChatAuthor.user,
      text: text,
      sessionId: _sessionId ?? '',
    );
    _pendingUserMessage = text;
    _pendingUserMessageObject = msg;
    _controller.add(msg);
    _saveChatMessage(msg);
  }

  void resendPendingMessageIfAny() {
    if (_pendingUserMessage != null) {
      print('[WebSocket] Resending pending message: $_pendingUserMessage');
      _channel?.sink.add(jsonEncode({'query': _pendingUserMessage}));
    }
  }

  void _pushSystem(String text) {
    if (_controller.isClosed || _lastSystem == text) return;
    _lastSystem = text;

    final isAnalyzing = text.toLowerCase().contains("reconnecting");

    final msg = ChatMessage(
      id: _uuid.v4(),
      author: ChatAuthor.bot,
      text: text,
      sessionId: _sessionId ?? '',
    );

    _controller.add(msg);
    // _saveChatMessage(msg);
  }

  void _saveChatMessage(ChatMessage msg) async {
    msg.userId = await AuthStorage.read();
    msg.sessionId = _sessionId ?? '';
    await _chatDb.insertAll([msg]);
  }

  Future<List<ChatMessage>> getMessagesForSession(String sessionId) async {
    return await _chatDb.getBySession(ChatMessage.tableName, sessionId);
  }

  @override
  Future<void> dispose() async {
    _closing = true;
    await _internetStatusSub?.cancel();
    await _socketSub?.cancel();
    await _channel?.sink.close(status.normalClosure);
    await _controller.close();
  }
}
