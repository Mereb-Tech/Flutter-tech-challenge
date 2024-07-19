class Users {
  final String username;

  final String lastMessage;

  final String createdAt;
  Users(
      {required this.username,
      required this.lastMessage,
      required this.createdAt});

  factory Users.fromMap(Map<dynamic, dynamic> user) {
    return Users(
        username: user['username'],
        lastMessage: user["lastMessage"] ?? "",
        createdAt: user["createdAt"] ?? "");
  }
}
