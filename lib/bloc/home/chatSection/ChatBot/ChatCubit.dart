import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../../../Helpers/CreditManager/CreditManager.dart';
import '../../../../Screens/Onboarding/Subscription/AppleSubscription/SubscriptionBuyPlanScreen.dart';
import '../../../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import 'chat_implementation.dart';
import 'chat_model.dart';

class ChatCubit extends Cubit<List<Map<String, String>>> {
  void Function(ChatResponseStatus status)? onResponse;

  ChatCubit({
    required String accessToken,
    required String existingSessionId,
    required bool isNewSession,
  }) : _repo = ChatRepositoryImpl(),
       super([
         //{'type': 'bot', 'text': 'Hey there!'},
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

  Timer? _responseTimer;
  bool _isStopped = false;

  bool get isConnected => _isConnected;

  Stream<bool> get internetStream => _internetStatusController.stream;

  Future<void> _init(String token, String sessionId, bool isNewSession) async {
    _repo.setResponseCallback((event) {
      switch (event.status) {
        case ChatResponseStatus.tokenLimitExpired:
          final next = List<Map<String, String>>.from(state)
            ..removeWhere((m) => m['type'] == 'analyzing');
          emit(next);
          onResponse?.call(ChatResponseStatus.tokenLimitExpired);
          break;
        case ChatResponseStatus.creditLimitExpired:
          final next = List<Map<String, String>>.from(state)
            ..removeWhere((m) => m['type'] == 'analyzing');
          emit(next);
          onResponse?.call(ChatResponseStatus.creditLimitExpired);
          break;

        case ChatResponseStatus.accessTokenExpired:
          final next = List<Map<String, String>>.from(state)
            ..removeWhere((m) => m['type'] == 'analyzing');
          emit(next);
          onResponse?.call(ChatResponseStatus.accessTokenExpired);
          break;
        default:
          break;
      }
    });

    if (!isNewSession && sessionId.isNotEmpty) {
      await _loadCompleteHistory(sessionId);
    }
    await _repo.connect(accessToken: token, existingSessionId: sessionId);
    _sub = _repo.messages.listen(_onSocketMessage);
  }

  Future<void> _loadCompleteHistory(String sessionId) async {
    List<Map<String, String>> greeting = [
      {'type': 'bot', 'text': 'Hey there!'},
      {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
    ];
    emit(greeting);
    final serverMessages = await _repo.fetchFullServerHistory(sessionId);

    final converted = serverMessages.map(
      (s) => _repo.serverToLocal(api: s, sessionId: sessionId, userId: null),
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
    final finalList = [...greeting, ...cleanList];

    emit(removeDuplicates(finalList));
  }

  void sendMessage(
    String text,
    BuildContext context,
    bool isReceivedTokenFullWarning,
  ) {
    if (CreditManager().remainingToken <= 0 ||
        isReceivedTokenFullWarning == true) {
      Future.microtask(() {
        AlertHelperForSubsPopup.showSubscriptionEndAlert(
          isFromTrackingClass: false,
          context: context,
          title: "Token limit exhausted",
          message:
              "Your token limit has been exhausted. Please purchase a subscription.",
          navigateTo: SubscriptionPlanDetailScreen(isComeFromSignup: false),
        );
      });
      return;
    }

    _isStopped = false;
    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analyzing');

    next.add({'type': 'user', 'text': text});

    if (!_isConnected) {
      next.add({'type': 'bot', 'text': 'Message not sent. No internet'});
      emit(next);
      return;
    }

    next.add({'type': 'analyzing', 'text': ''});
    emit(next);

    _responseTimer?.cancel();
    _responseTimer = Timer(const Duration(seconds: 15), () {
      _handleNoResponse();
    });

    _repo.send(text);
  }

  void _handleNoResponse() {
    final next = List<Map<String, String>>.from(state);

    next.removeWhere((m) => m['type'] == 'analyzing');

    next.add({
      'type': 'bot',
      'text': 'Sorry, an error occurred while processing your request.',
    });

    emit(next);
  }

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
    if (msg.text == "__SESSION_EXPIRED__") {
      emit(List<Map<String, String>>.from(state));
      return;
    }

    if (msg.text.contains("token")) {
      emit(List<Map<String, String>>.from(state));
      return;
    }

    _responseTimer?.cancel();
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
    final isDuplicate = next.any(
      (m) =>
          m['type'] == mapped['type'] &&
          (m['text'] ?? '').trim() == mapped['text'],
    );

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

  void stopResponse() {
    _isStopped = true;
    _responseTimer?.cancel();
    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analyzing');
    emit(next);
  }

  @override
  Future<void> close() async {
    _responseTimer?.cancel();
    await _sub?.cancel();
    await _internetSub?.cancel();
    await _internetStatusController.close();
    await _repo.dispose();
    return super.close();
  }
}
