import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<List<Map<String, String>>> {
  ChatCubit()
      : super([
    {'type': 'bot', 'text': 'Hey there!'},
    {'type': 'bot', 'text': 'I’m your WILCO, How can I help you?'},
    {'type': 'button', 'text': ''},
    {
      'type': 'user',
      'text': 'Which is the fastest aircraft in world?',
    },
    {
      'type': 'bot',
      'text': '''Sure!! The fastest aircraft in the world is the:\nNorth American X-15\n• Top Speed: Mach 6.7 (≈ 7,273 km/h or 4,520 mph)\n• Record Set: 1967 by pilot William J. "Pete" Knight\n• Type: Rocket-powered experimental aircraft (NASA & U.S. Air Force)''',
    },
  ]);

  void sendMessage(String text) {
    final updatedMessages = [...state];
    updatedMessages.add({'type': 'user', 'text': text});
    updatedMessages.add({
      'type': 'bot',
      'text': "That's a great question! Let me get back to you on that.",
    });
    emit(updatedMessages);
  }
}
