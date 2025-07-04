import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_implementation.dart';
import 'chat_model.dart';

class ChatCubit extends Cubit<List<Map<String, String>>> {
  ChatCubit({required String accessToken})
      : _repo = ChatRepositoryImpl(),
        super(const [
        {'type': 'bot', 'text': 'Hey there!'},
        {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
        {'type': 'button', 'text': ''},
      ]) {
    _init(accessToken);
  }

  final ChatRepositoryImpl _repo;
  StreamSubscription? _sub;

  Future<void> _init(String token) async {
    await _repo.connect(accessToken: token);
    _sub = _repo.messages.listen(_onSocketMessage);
  }

  void sendMessage(String text) {
    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analizing');

    next.add({'type': 'user', 'text': text});
    next.add({'type': 'analizing', 'text': ''});
    emit(next);
    _repo.send(text);
  }

  void _onSocketMessage(ChatMessage msg) {
    final next = List<Map<String, String>>.from(state);

    if (msg.author == ChatAuthor.bot) {
      next.removeWhere((m) => m['type'] == 'analizing');
    }

    final mapped = {
      'type': msg.author == ChatAuthor.user ? 'user' : 'bot',
      'text': msg.text,
    };

    final nonTypingLast = next.lastWhere(
          (m) => m['type'] != 'analizing',
      orElse: () => {},
    );
    final isDuplicate = nonTypingLast.isNotEmpty &&
        nonTypingLast['type'] == mapped['type'] &&
        (nonTypingLast['text'] ?? '').trim() ==
            (mapped['text'] ?? '').trim();

    if (!isDuplicate) next.add(mapped);

    emit(next);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _repo.dispose();
    return super.close();
  }
}
