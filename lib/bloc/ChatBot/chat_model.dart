enum ChatAuthor { user, bot }

class ChatMessage {
  const ChatMessage({
    required this.author,
    required this.text,
    this.isTyping = false,
  });

  final ChatAuthor author;
  final String text;
  final bool isTyping;

  @override
  bool operator ==(Object other) =>
      other is ChatMessage &&
          author == other.author &&
          text.trim() == other.text.trim() &&
          isTyping == other.isTyping;

  @override
  int get hashCode => Object.hash(author, text.trim(), isTyping);
}
