// lib/models/message.dart

class MessageModel {
  final String id;
  final String authorId;
  final int createdAt;
  final String text;

  MessageModel({
    required this.id,
    required this.authorId,
    required this.createdAt,
    required this.text,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String documentId) {
    return MessageModel(
      id: documentId,
      authorId: data['authorId'] ?? '',
      createdAt: data['createdAt'] ?? 0,
      text: data['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'createdAt': createdAt,
      'text': text,
    };
  }
}
