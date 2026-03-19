import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'chat_implementation.dart';
import 'chat_model.dart';

class ChatCubit extends Cubit<List<Map<String, String>>> {
  ChatCubit({
    required String accessToken,
    required String existingSessionId,
    required bool isNewSession,
  })  : _repo = ChatRepositoryImpl(),
        super([
        {'type': 'bot', 'text': 'Hey there!'},
        {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
      ]) {
    _init(accessToken, existingSessionId, isNewSession);
    _startInternetListener();
  }

  final ChatRepositoryImpl _repo;
  StreamSubscription? _sub;
  dynamic _internetSub;
  final _internetStatusController = StreamController<bool>.broadcast();
  bool _isConnected = true;

  bool _isStopped = false;

  /// Expose current connection status and stream
  bool get isConnected => _isConnected;
  Stream<bool> get internetStream => _internetStatusController.stream;

  Future<void> _init(String token, String sessionId, bool isNewSession) async {
    if (!isNewSession && sessionId.isNotEmpty) {
      await _loadCompleteHistory(sessionId);
      // await _loadOldMessages(sessionId);
    }
    await _repo.connect(accessToken: token, existingSessionId: sessionId);
    _sub = _repo.messages.listen(_onSocketMessage);
  }

  // Future<void> _loadOldMessages(String sessionId) async {
  //   final oldMessages = await _repo.getMessagesForSession(sessionId);
  //
  //   final history = oldMessages
  //       .map(
  //         (msg) => {
  //       'type': msg.author == ChatAuthor.bot ? 'bot' : 'user',
  //       'text': msg.text,
  //     },
  //   )
  //       .toList();
  //
  //   final currentState = List<Map<String, String>>.from(state);
  //   final updatedState = [...currentState, ...history];
  //   emit(updatedState);
  // }


  Future<void> _loadCompleteHistory(String sessionId) async {
    List<Map<String, String>> greeting = [
      {'type': 'bot', 'text': 'Hey there!'},
      {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
    ];
    emit(greeting);
    final localMessages = await _repo.getMessagesForSession(sessionId);
    final serverMessages = await _repo.fetchFullServerHistory(sessionId);

    final converted = serverMessages.map(
          (s) => _repo.serverToLocal(
        api: s,
        sessionId: sessionId,
        userId: null,
      ),
    );
    await _repo.insertOrIgnoreLocalMessages(converted.toList());
    final merged = await _repo.getMessagesForSession(sessionId);

    final uiList = merged.map((msg) {
      return {
        'type': msg.author == ChatAuthor.bot ? 'bot' : 'user',
        'text': msg.text,
      };
    }).toList();
    final cleanList = removeDuplicates(uiList);
    final finalList = [
      ...greeting,
      ...cleanList,
    ];

    emit(removeDuplicates(finalList));
  }


  void sendMessage(String text) {
    if (!_isConnected) return;
    _isStopped = false;
    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analyzing');

    next.add({'type': 'user', 'text': text});
    next.add({'type': 'analyzing', 'text': ''});
    emit(next);
    _repo.send(text);
  }

  // void _onSocketMessage(ChatMessage msg) {
  //   final next = List<Map<String, String>>.from(state);
  //
  //   if (msg.author == ChatAuthor.bot) {
  //     next.removeWhere((m) => m['type'] == 'analyzing');
  //   }
  //
  //   final mapped = {
  //     'type': msg.author == ChatAuthor.user ? 'user' : 'bot',
  //     'text': msg.text,
  //   };
  //
  //   final nonTypingLast = next.lastWhere(
  //         (m) => m['type'] != 'analyzing',
  //     orElse: () => {},
  //   );
  //   final isDuplicate =
  //       nonTypingLast.isNotEmpty &&
  //           nonTypingLast['type'] == mapped['type'] &&
  //           (nonTypingLast['text'] ?? '').trim() == (mapped['text'] ?? '').trim();
  //
  //   if (!isDuplicate) next.add(mapped);
  //
  //   emit(next);
  // }

  List<Map<String, String>> removeDuplicates(List<Map<String, String>> items) {
    final seen = <String>{};
    final filtered = <Map<String, String>>[];

    for (final m in items) {
      final key = "${m['type']}|${m['text']?.trim()}";
      if (!seen.contains(key)) {
        seen.add(key);
        filtered.add(m);
      }
    }

    return filtered;
  }

  void _onSocketMessage(ChatMessage msg) {
    if (_isStopped) return;
    final next = List<Map<String, String>>.from(state);

    if (msg.author == ChatAuthor.bot) {
      next.removeWhere((m) => m['type'] == 'analyzing');
    }

    final mapped = {
      'type': msg.author == ChatAuthor.user ? 'user' : 'bot',
      'text': msg.text.trim(),
    };

    // FIX: check entire list, not only last element
    final isDuplicate = next.any((m) =>
    m['type'] == mapped['type'] &&
        (m['text'] ?? '').trim() == mapped['text']);

    if (!isDuplicate) {
      next.add(mapped);
    }

    emit(next);
  }


  void _startInternetListener() {
    _internetSub = Connectivity().onConnectivityChanged.listen((result) {
      final connected = result != ConnectivityResult.none;
      if (connected != _isConnected) {
        _isConnected = connected;
        _internetStatusController.add(_isConnected);
      }
    });
  }

  /// Stop
  void stopResponse() {
    _isStopped = true;

    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analyzing');

    emit(next);
    // for backend (optional, safe)
    // _repo.stopStreaming();
  }


  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _internetSub?.cancel();
    await _internetStatusController.close();
    await _repo.dispose();
    return super.close();
  }
}
