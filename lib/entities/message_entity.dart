class MessageEntity {
  final Map<String, dynamic> rawMessage;
  final String? id;
  final String response;
  final Map<String, dynamic>? from;
  final Map<String, dynamic>? to;
  final bool isUserMessage;

  MessageEntity({
    required this.isUserMessage,
    required this.response,
    this.from,
    this.to,
    this.id,
    required this.rawMessage,
  });
}
