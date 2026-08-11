import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import '../../../../Helpers/CreditManager/CreditManager.dart';
import '../ChatHistory/chat_messageModel.dart';
import 'ChatSocket_model.dart';
import 'chat_model.dart';
import 'chat_repository.dart';

enum ChatResponseStatus {
  success,
  error,
  tokenLimitExpired,
  creditLimitExpired,
  accessTokenExpired,
  subscriptionExpired,
}

class ChatResponseEvent {
  final ChatResponseStatus status;
  final String? message;

  ChatResponseEvent({required this.status, this.message});
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl();

  void Function(ChatResponseEvent event)? _onResponseEvent;

  final _controller = StreamController<ChatMessage>.broadcast();
  final _uuid = Uuid();
  final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);

  @override
  Stream<ChatMessage> get messages => _controller.stream;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSub;
  bool _isSocketConnected = false;
  VoidCallback? onSocketConnected;
  bool _hasInternet = true;
  bool _isConnecting = false;

  String? _sessionId;
  String? _accessToken;
  bool _closing = false;
  String? get currentSessionId => _sessionId;
  int _retries = 0;
  String? _lastSystem;
  String? _pendingUserMessage;
  ChatMessage? _pendingUserMessageObject;
  String? _initialGreeting;
  bool _isFirstMessage = true;

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

    // Load local messages if not a new session
    if (!isNewSession && _sessionId != null && _sessionId!.isNotEmpty) {
      final localMsgs = await getMessagesForSession(_sessionId!);
      for (var msg in localMsgs) {
        _controller.add(msg);
      }
    } else {
      await prefs.remove('wilco_session_id');
    }

    await _openSocket();
  }

  Future<void> _openSocket() async {
    if (!_hasInternet) {
      print('[WebSocket] Skip connection. No internet');
      return;
    }

    if (_isConnecting) return;

    _isConnecting = true;

    try {
      if (_accessToken == null || _accessToken!.isEmpty) {
        print('[WebSocket] Missing access token');
        return;
      }

      final isNewSession = _sessionId == null || _sessionId!.isEmpty;

      final endpoint = isNewSession
          ? 'wss://${ApiBaseUrlConstant.baseChatUrl}/ai-engine/wilco/new-session?token=$_accessToken'
          : 'wss://${ApiBaseUrlConstant.baseChatUrl}/ai-engine/wilco/session/$_sessionId?token=$_accessToken';

      print('[WebSocket] Connecting to: $endpoint');

      _channel = WebSocketChannel.connect(Uri.parse(endpoint));

      _socketSub = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: true,
      );

      _isSocketConnected = true;
      _retries = 0;

      onSocketConnected?.call();
    } catch (e) {
      print("[WebSocket] Connection failed $e");
    } finally {
      _isConnecting = false;
    }
  }

  void _onData(dynamic data) async {
    try {
      print('[WebSocket] Raw: $data');
      final decoded = jsonDecode(data as String);
      final response = ChatSocketResponse.fromJson(decoded);
      if (response.code != 5) {
        CreditManager().totalToken = response.totalTokenUsage!.toDouble();
      }
      print('[WebSocket] Parsed Code: ${response.code}');
      switch (response.code) {
        case 1:
          await _handleSuccess(response);
          break;

        case 0:
          _pushSystem("Something went wrong");
          break;
        case 2:
          _closing = true;
          _onResponseEvent?.call(
            ChatResponseEvent(status: ChatResponseStatus.tokenLimitExpired),
          );
          break;
        case 3:
          _closing = true;
          _onResponseEvent?.call(
            ChatResponseEvent(status: ChatResponseStatus.creditLimitExpired),
          );
          break;
        case 4:
          _closing = true;
          _onResponseEvent?.call(
            ChatResponseEvent(status: ChatResponseStatus.accessTokenExpired),
          );
          break;
        case 5:
          _closing = true;
          _onResponseEvent?.call(
            ChatResponseEvent(status: ChatResponseStatus.subscriptionExpired),
          );
          break;
        default:
          _pushSystem("Unexpected response ⚠️");
      }
    } catch (e) {
      print('[WebSocket] Error: $e');
    }
  }

  Future<void> _handleSuccess(ChatSocketResponse response) async {
    if ((_sessionId ?? '').isEmpty && response.sessionId != null) {
      _sessionId = response.sessionId;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wilco_session_id', _sessionId!);

      if (_pendingUserMessageObject != null) {
        _pendingUserMessageObject!.sessionId = _sessionId!;
        await _chatDb.update(_pendingUserMessageObject!);
        _pendingUserMessage = null;
      }
    }

    if (response.answer != null && response.answer!.trim().isNotEmpty) {
      final msg = ChatMessage(
        id: _uuid.v4(),
        author: ChatAuthor.bot,
        text: response.answer!,
        sessionId: _sessionId ?? '',
      );

      _saveChatMessage(msg);
      _pendingUserMessage = null;
      _pendingUserMessageObject = null;
    }
  }

  void setResponseCallback(void Function(ChatResponseEvent event) callback) {
    _onResponseEvent = callback;
  }

  // void _onData(dynamic data) async {
  //   print('[WebSocket] Received: $data');
  //   final decoded = jsonDecode(data as String);
  //   print('[WebSocket] Decoded: $decoded');
  //
  //   if (decoded['error'] != null) {
  //     final errorMsg = decoded['error'] as String;
  //     _pushSystem("Internal Server Error: $errorMsg ❌");
  //     return;
  //   }
  //
  //   if ((_sessionId ?? '').isEmpty && decoded['session_id'] != null) {
  //     _sessionId = decoded['session_id'] as String;
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('wilco_session_id', _sessionId!);
  //
  //     if (_pendingUserMessageObject != null) {
  //       _pendingUserMessageObject!.sessionId = _sessionId!;
  //       final updateCount = await _chatDb.update(_pendingUserMessageObject!);
  //       print('Updated first message ${_pendingUserMessageObject!.id} with sessionId: $_sessionId, rows affected: $updateCount');
  //       if (updateCount == 0) {
  //         print('Warning: No rows updated for message ${_pendingUserMessageObject!.id}');
  //       }
  //       _pendingUserMessage = null;
  //     }
  //   }
  //
  //   final answer = decoded['answer'] as String?;
  //   if (answer != null) {
  //     final msg = ChatMessage(
  //       id: _uuid.v4(),
  //       author: ChatAuthor.bot,
  //       text: answer,
  //       sessionId: _sessionId ?? '',
  //     );
  //     // _controller.add(msg);
  //     _saveChatMessage(msg);
  //     _pendingUserMessage = null;
  //     _pendingUserMessageObject = null;
  //   }
  // }

  void _onError(Object error) {
    _isSocketConnected = false;

    print('[WebSocket] Error: $error');

    if (_closing || !_hasInternet) {
      print('[WebSocket] Reconnect skipped');
      return;
    }

    _retries++;

    final delay = Duration(seconds: 2 << (_retries - 1));

    Future.delayed(delay, () {
      if (!_closing && _hasInternet && _accessToken != null) {
        _openSocket();
      }
    });
  }

  void _onDone() {
    _isSocketConnected = false;

    if (_closing || !_hasInternet) {
      return;
    }

    _retries++;

    final delay = Duration(seconds: 2 << (_retries - 1));

    print('[WebSocket] Reconnect in ${delay.inSeconds}s');

    Future.delayed(delay, () {
      if (!_closing && _hasInternet && _accessToken != null) {
        _openSocket();
      }
    });
  }

  // void send(String text) {
  //   print('[WebSocket] Sending: $text');
  //
  //   if (!_isSocketConnected) {
  //     print('[WebSocket] Socket not connected');
  //
  //     _pendingUserMessage = text;
  //
  //     if (_hasInternet) {
  //       reconnect();
  //     }
  //
  //     return;
  //   }
  //
  //   final payload = {
  //     'query': text,
  //   };
  //
  //   if (_isFirstMessage && _initialGreeting != null) {
  //     payload['code'] = _initialGreeting!;
  //     _isFirstMessage = false;
  //   }
  //
  //   _channel?.sink.add(jsonEncode(payload));
  //
  //   final msg = ChatMessage(
  //     id: _uuid.v4(),
  //     author: ChatAuthor.user,
  //     text: text,
  //     sessionId: _sessionId ?? '',
  //   );
  //   _pendingUserMessage = text;
  //   _pendingUserMessageObject = msg;
  //   // _controller.add(msg);
  //   _saveChatMessage(msg);
  //
  //   if (_sessionId != null && _sessionId!.isNotEmpty) {
  //     _pendingUserMessage = null;
  //   }
  // }

  void send(String text) {
    print('[WebSocket] Sending Text => $text');

    final payload = {
      'query': text,
    };

    final isNewSession = _sessionId == null || _sessionId!.isEmpty;

    if (isNewSession && _isFirstMessage && _initialGreeting != null) {
      payload['initial_message'] = _initialGreeting!;

      print(
        '[WebSocket] First Message Greeting => $_initialGreeting',
      );
    }
    print(
      '[WebSocket] Final Payload => ${jsonEncode(payload)}',
    );
    if (!_isSocketConnected) {
      print('[WebSocket] Socket not connected');

      _pendingUserMessage = text;

      if (_hasInternet) {
        reconnect();
      }

      return;
    }

    if (isNewSession && _isFirstMessage) {
      _isFirstMessage = false;
    }

    _channel?.sink.add(jsonEncode(payload));

    final msg = ChatMessage(
      id: _uuid.v4(),
      author: ChatAuthor.user,
      text: text,
      sessionId: _sessionId ?? '',
    );

    _pendingUserMessage = text;
    _pendingUserMessageObject = msg;

    _saveChatMessage(msg);

    if (_sessionId != null && _sessionId!.isNotEmpty) {
      _pendingUserMessage = null;
    }
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

    final msg = ChatMessage(
      id: _uuid.v4(),
      author: ChatAuthor.bot,
      text: text,
      sessionId: _sessionId ?? '',
    );

    _controller.add(msg);
    _saveChatMessage(msg);
  }

  void _saveChatMessage(ChatMessage msg) async {
    msg.userId = await SharedPrefsHelper.read();
    msg.sessionId = _sessionId ?? '';
    try {
      // await _chatDb.insertAll([msg]);
      await _chatDb.insertChatMessageSafe(msg);
      _controller.add(msg);
      print(
        'Saved message: ${msg.text}, id: ${msg.id}, sessionId: ${msg.sessionId}, userId: ${msg.userId}',
      );
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  Future<List<ChatMessage>> getMessagesForSession(String sessionId) async {
    return await _chatDb.getBySession(ChatMessage.tableName, sessionId);
  }

  @override
  Future<void> dispose() async {
    _closing = true;
    await _socketSub?.cancel();
    await _channel?.sink.close(status.normalClosure);
    await _controller.close();
  }

  Future<List<ChatMessageModel>> fetchFullServerHistory(
    String sessionId,
  ) async {
    List<ChatMessageModel> all = [];
    int page = 1;
    while (true) {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlConstant.chatHistorySession}/$sessionId",
      );

      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      final results = (jsonData['results'] as List<dynamic>)
          .map((item) => ChatMessageModel.fromApi(item, sessionId))
          .toList();

      all.addAll(results);

      final totalPages = jsonData['total_pages'] as int? ?? 1;
      if (page >= totalPages) break;
      page++;
    }
    return all;
  }

  /// Convert server model → local ChatMessage
  ChatMessage serverToLocal({
    required ChatMessageModel api,
    required String sessionId,
    String? userId,
  }) {
    return ChatMessage(
      id: api.id,
      author: api.role.toLowerCase() == 'user'
          ? ChatAuthor.user
          : ChatAuthor.bot,
      text: api.content,
      sessionId: sessionId,
      userId: userId,
    );
  }

  /// Insert messages into local DB, ignore duplicates by id
  Future<void> insertOrIgnoreLocalMessages(List<ChatMessage> messages) async {
    final existing = await _chatDb.getAll(ChatMessage.tableName);
    final existingIds = existing.map((e) => e.id).toSet();

    final toInsert = messages
        .where((m) => !existingIds.contains(m.id))
        .toList();
    if (toInsert.isNotEmpty) {
      await _chatDb.insertAll(toInsert);
    }
  }

  Future<void> reconnect() async {
    print('[WebSocket] Manual reconnect triggered');

    try {
      await _socketSub?.cancel();
      await _channel?.sink.close();
    } catch (e) {
      print('[WebSocket] Reconnect cleanup error: $e');
    }

    _isSocketConnected = false;

    await _openSocket();
  }

  void updateInternetStatus(bool value) {
    _hasInternet = value;

    if (!value) {
      _socketSub?.cancel();
      _channel?.sink.close();
      _channel = null;
      _isSocketConnected = false;
    }
  }

  Future<void> resetSession() async {
    print("[WebSocket] Reset Session");

    _sessionId = null;

    _pendingUserMessage = null;
    _pendingUserMessageObject = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wilco_session_id');

    try {
      await _socketSub?.cancel();
      await _channel?.sink.close();
    } catch (e) {
      print(e);
    }

    _isSocketConnected = false;
  }

  void setInitialGreeting(String greeting) {
    _initialGreeting = greeting;
  }
}
