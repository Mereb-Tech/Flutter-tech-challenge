// lib/services/chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:merem_chat_app/src/models/chat.dart';
import 'package:merem_chat_app/src/models/message.dart';
import 'package:merem_chat_app/src/models/user.dart';

@lazySingleton
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatModel> chats = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        List<UserModel> participants = [];
        for (var id in data['users']) {
          if (id != userId) {
            final userDoc = await _firestore.collection('users').doc(id).get();
            if (userDoc.exists && userDoc.data() != null) {
              final user = UserModel.fromMap(userDoc.data()!, userDoc.id);
              participants.add(user);
            }
          }
        }

        final lastMessageQuery = await _firestore
            .collection('chats')
            .doc(doc.id)
            .collection('messages')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

        final lastMessage = lastMessageQuery.docs.isNotEmpty
            ? MessageModel.fromMap(lastMessageQuery.docs.first.data(),
                lastMessageQuery.docs.first.id)
            : null;

        chats.add(ChatModel.fromMap(data, doc.id, participants, lastMessage));
      }
      return chats;
    });
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> sendMessage(MessageModel message, String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<void> createChat(String userId, List<String> peerIds) async {
    final chatQuery = await _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .get();

    bool chatExists = false;
    for (var doc in chatQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (peerIds.every((id) => users.contains(id)) && users.contains(userId)) {
        chatExists = true;
        break;
      }
    }

    if (!chatExists) {
      await _firestore.collection('chats').add({
        'users': [userId, ...peerIds],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      print('Chat already exists');
    }
  }

  Future<String?> getChatId(String userId, String peerId) async {
    final chatQuery = await _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .get();

    for (var doc in chatQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(peerId) && users.contains(userId)) {
        return doc.id;
      }
    }

    return null;
  }

  //get all users except current user
  Future<List<UserModel>> getUsersList(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('uid', isNotEqualTo: userId)
        .get();
    List<UserModel> users = [];
    for (var doc in querySnapshot.docs) {
      users.add(UserModel.fromMap(doc.data(), doc.id));
    }
    return users;
  }
}
