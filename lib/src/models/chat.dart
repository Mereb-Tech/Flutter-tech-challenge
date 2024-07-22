// lib/models/chat.dart

import 'message.dart';
import 'user.dart';

class ChatModel {
  final String id;
  final List<UserModel> participants;
  final MessageModel? lastMessage;

  ChatModel({
    required this.id,
    required this.participants,
    this.lastMessage,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data, String documentId, List<UserModel> participants, MessageModel? lastMessage) {
    return ChatModel(
      id: documentId,
      participants: participants,
      lastMessage: lastMessage,
    );
  }
}
