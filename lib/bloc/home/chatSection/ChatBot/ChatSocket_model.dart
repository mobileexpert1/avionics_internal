class ChatSocketResponse {
  final String? query;
  final String? answer;
  final String? sessionId;
  final int code;
  final int? totalTokenUsage;

  ChatSocketResponse({
    this.query,
    this.answer,
    this.sessionId,
    this.totalTokenUsage,
    required this.code,
  });

  factory ChatSocketResponse.fromJson(Map<String, dynamic> json) {
    return ChatSocketResponse(
      query: json['query'],
      answer: json['answer'],
      sessionId: json['session_id'],
      code: json['code'] ?? -1,
      totalTokenUsage: json['total_token_usage'] ?? -1,
    );
  }
}
