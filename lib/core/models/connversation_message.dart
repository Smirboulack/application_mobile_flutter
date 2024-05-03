

import 'package:sevenapplication/core/models/Conversation.dart';

class ConversationResponse {
  final int responseCode;
  final String message;
  final List<Conversation> conversations;

  ConversationResponse({
    required this.responseCode,
    required this.message,
    required this.conversations,
  });
}
