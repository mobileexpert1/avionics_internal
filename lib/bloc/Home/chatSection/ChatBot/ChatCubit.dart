// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'chat_implementation.dart';
// import 'chat_model.dart';
//
// class ChatCubit extends Cubit<List<Map<String, String>>> {
//   ChatCubit({
//     required String accessToken,
//     required String existingSessionId,
//     required bool isNewSession,
//   }) : _repo = ChatRepositoryImpl(),
//        super(const [
//          {'type': 'bot', 'text': 'Hey there!'},
//          {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
//        ]) {
//     _init(accessToken, existingSessionId, isNewSession);
//   }
//
//   Future<void> _loadOldMessages(String sessionId) async {
//     final oldMessages = await _repo.getMessagesForSession(sessionId);
//
//     final history = oldMessages
//         .map(
//           (msg) => {
//             'type': msg.author == ChatAuthor.bot ? 'bot' : 'user',
//             'text': msg.text,
//           },
//         )
//         .toList();
//
//     final introMessages = [
//       {'type': 'bot', 'text': 'Hey there!'},
//       {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
//     ];
//
//     emit([...introMessages, ...history]);
//   }
//
//   final ChatRepositoryImpl _repo;
//   StreamSubscription? _sub;
//   String? _pendingMessage;
//
//   Future<void> _init(String token, String sessionId, bool isNewSession) async {
//     if (!isNewSession) {
//       await _loadOldMessages(sessionId);
//     }
//     await _repo.connect(accessToken: token, existingSessionId: sessionId);
//     _sub = _repo.messages.listen(_onSocketMessage);
//   }
//
//
//   void sendMessage(String text) {
//     final next = List<Map<String, String>>.from(state)
//       ..removeWhere((m) => m['type'] == 'analyzing');
//
//     next.add({'type': 'user', 'text': text});
//     next.add({'type': 'analyzing', 'text': ''});
//     emit(next);
//     _repo.send(text);
//   }
//
//   void _onSocketMessage(ChatMessage msg) {
//     final next = List<Map<String, String>>.from(state);
//
//     if (msg.author == ChatAuthor.bot) {
//       next.removeWhere((m) => m['type'] == 'analyzing');
//     }
//
//     final mapped = {
//       'type': msg.author == ChatAuthor.user ? 'user' : 'bot',
//       'text': msg.text,
//     };
//
//     final nonTypingLast = next.lastWhere(
//       (m) => m['type'] != 'analyzing',
//       orElse: () => {},
//     );
//     final isDuplicate =
//         nonTypingLast.isNotEmpty &&
//         nonTypingLast['type'] == mapped['type'] &&
//         (nonTypingLast['text'] ?? '').trim() == (mapped['text'] ?? '').trim();
//
//     if (!isDuplicate) next.add(mapped);
//
//     emit(next);
//   }
//
//   @override
//   Future<void> close() async {
//     await _sub?.cancel();
//     await _repo.dispose();
//     return super.close();
//   }
// }

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'chat_implementation.dart';
import 'chat_model.dart';

class ChatCubit extends Cubit<List<Map<String, String>>> {
  ChatCubit({
    required String accessToken,
    required String existingSessionId,
    required bool isNewSession,
  })  : _repo = ChatRepositoryImpl(),
        super(const [
        {'type': 'bot', 'text': 'Hey there!'},
        {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
      ]) {
    _init(accessToken, existingSessionId, isNewSession);
    _startInternetListener();
  }

  final ChatRepositoryImpl _repo;
  StreamSubscription? _sub;
  StreamSubscription<InternetConnectionStatus>? _internetSub;
  final _internetStatusController = StreamController<bool>.broadcast();
  String? _pendingMessage;
  bool _isConnected = true;

  /// Expose current connection status and stream
  bool get isConnected => _isConnected;
  Stream<bool> get internetStream => _internetStatusController.stream;

  Future<void> _init(String token, String sessionId, bool isNewSession) async {
    if (sessionId.isNotEmpty) {
      await _loadOldMessages(sessionId);
    }

    await _repo.connect(accessToken: token, existingSessionId: sessionId);
    _sub = _repo.messages.listen(_onSocketMessage);
  }

  Future<void> _loadOldMessages(String sessionId) async {
    final oldMessages = await _repo.getMessagesForSession(sessionId);

    final history = oldMessages
        .map(
          (msg) => {
        'type': msg.author == ChatAuthor.bot ? 'bot' : 'user',
        'text': msg.text,
      },
    )
        .toList();

    final introMessages = [
      {'type': 'bot', 'text': 'Hey there!'},
      {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
    ];

    emit([...introMessages, ...history]);
  }

  void sendMessage(String text) {
    if (!_isConnected) return;

    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analyzing');

    next.add({'type': 'user', 'text': text});
    next.add({'type': 'analyzing', 'text': ''});
    emit(next);
    _repo.send(text);
  }

  void _onSocketMessage(ChatMessage msg) {
    final next = List<Map<String, String>>.from(state);

    if (msg.author == ChatAuthor.bot) {
      next.removeWhere((m) => m['type'] == 'analyzing');
    }

    final mapped = {
      'type': msg.author == ChatAuthor.user ? 'user' : 'bot',
      'text': msg.text,
    };

    final nonTypingLast = next.lastWhere(
          (m) => m['type'] != 'analyzing',
      orElse: () => {},
    );
    final isDuplicate =
        nonTypingLast.isNotEmpty &&
            nonTypingLast['type'] == mapped['type'] &&
            (nonTypingLast['text'] ?? '').trim() == (mapped['text'] ?? '').trim();

    if (!isDuplicate) next.add(mapped);

    emit(next);
  }

  void _startInternetListener() {
    _internetSub = InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (connected != _isConnected) {
        _isConnected = connected;
        _internetStatusController.add(_isConnected);
      }
    });
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

