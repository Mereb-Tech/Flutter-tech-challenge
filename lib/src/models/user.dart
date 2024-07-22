// lib/models/user.dart

class UserModel {
  final String id;
  final String uid;
  final String username;
  final String email;

  //add created at
    

  UserModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
    };
  }
}
