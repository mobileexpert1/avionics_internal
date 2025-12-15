import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/Custom_Pagination.dart';
import '../../../../Database/auth_storage.dart';
import '../../../../Database/generic_methods.dart';
import '../ChatHistory/chat_messageModel.dart';
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

  void startInternetMonitoring() {
    // Handled in ChatCubit using connectivity_plus
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
    if (_accessToken == null || _accessToken!.isEmpty) {
      print('[WebSocket] Missing access token');
      return;
    }

    final isNewSession = _sessionId == null || _sessionId!.isEmpty;
    final endpoint = isNewSession
        ? 'wss://avionica.csdevhub.com/ai-engine/wilco/new-session?token=$_accessToken'
        : 'wss://avionica.csdevhub.com/ai-engine/wilco/session/$_sessionId?token=$_accessToken';

    print('[WebSocket] Connecting to: $endpoint');

    // Platform agnostic WebSocket for Web & Mobile
    _channel = WebSocketChannel.connect(Uri.parse(endpoint));

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

    if ((_sessionId ?? '').isEmpty && decoded['session_id'] != null) {
      _sessionId = decoded['session_id'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wilco_session_id', _sessionId!);

      if (_pendingUserMessageObject != null) {
        _pendingUserMessageObject!.sessionId = _sessionId!;
        final updateCount = await _chatDb.update(_pendingUserMessageObject!);
        print('Updated first message ${_pendingUserMessageObject!.id} with sessionId: $_sessionId, rows affected: $updateCount');
        if (updateCount == 0) {
          print('Warning: No rows updated for message ${_pendingUserMessageObject!.id}');
        }
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
      // _controller.add(msg);
      _saveChatMessage(msg);
      _pendingUserMessage = null;
      _pendingUserMessageObject = null;
    }
  }

  void _onError(Object error) {
    print('[WebSocket] Error: $error');
    _pushSystem("Unexpected error occurred. Please try again later. ⚠️");
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

  void send(String text) {
    print('[WebSocket] Sending: $text');
    _channel?.sink.add(jsonEncode({'query': text}));

    final msg = ChatMessage(
      id: _uuid.v4(),
      author: ChatAuthor.user,
      text: text,
      sessionId: _sessionId ?? '',
    );
    _pendingUserMessage = text;
    _pendingUserMessageObject = msg;
    // _controller.add(msg);
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
    msg.userId = await AuthStorage.read();
    msg.sessionId = _sessionId ?? '';
    try {
      // await _chatDb.insertAll([msg]);
      await _chatDb.insertChatMessageSafe(msg);
      _controller.add(msg);
      print('Saved message: ${msg.text}, id: ${msg.id}, sessionId: ${msg.sessionId}, userId: ${msg.userId}');
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


  Future<List<ChatMessageModel>> fetchFullServerHistory(String sessionId) async {
    List<ChatMessageModel> all = [];
    int page = 1;
    while (true) {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlChatConstant.chatService}/$sessionId",
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
      author: api.role.toLowerCase() == 'user' ? ChatAuthor.user : ChatAuthor.bot,
      text: api.content,
      sessionId: sessionId,
      userId: userId,
    );
  }

  /// Insert messages into local DB, ignore duplicates by id
  Future<void> insertOrIgnoreLocalMessages(List<ChatMessage> messages) async {
    final existing = await _chatDb.getAll(ChatMessage.tableName);
    final existingIds = existing.map((e) => e.id).toSet();

    final toInsert = messages.where((m) => !existingIds.contains(m.id)).toList();
    if (toInsert.isNotEmpty) {
      await _chatDb.insertAll(toInsert);
    }
  }
}
