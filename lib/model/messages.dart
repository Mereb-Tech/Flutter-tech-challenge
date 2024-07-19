class Messages {
  final String message;
  final String sender;
  final String reciever;
  final dynamic createdAt;
  Messages(
      {required this.message,
      required this.sender,
      required this.reciever,
      required this.createdAt});

  factory Messages.fromMap(Map<dynamic, dynamic> user) {
    return Messages(
        message: user["message"],
        sender: user['sender'],
        reciever: user["reciever"] ?? "",
        createdAt: user["createdAt"] ?? "");
  }
}
