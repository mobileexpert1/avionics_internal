enum ChatAuthor { user, bot }

class ChatMessage {
  ChatMessage({
    required this.author,
    required this.text,
  });

  final ChatAuthor author;
  final String text;
}
