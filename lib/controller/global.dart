
import 'dart:math';

import 'package:estif_challange/model/messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/users.dart';
import '../utils/exception.dart';

class GlobalProvider with ChangeNotifier {
  String? user;
  // List<Users> _users = [];
  // List<Users> get users => [..._users];
  // List<Messages> _messages = [];
  // List<Messages> get messages => [..._messages];

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<void> authenticate(String username) async {
    final usersRef = _databaseRef.child('users');

    try {
      final snapshot = await usersRef.child(username).get();
      if (!snapshot.exists) {
        throw CustomException(message: 'USER NOT FOUND!');
      } else {
        // await usersRef.child(username).set({

        //   'username': username,
        //   'lastMessage': "",
        //   'createdAt': "",
        // });
        user = username;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Users>> getAllUsers() {
    final usersRef = _databaseRef.child('users');

    return usersRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.values.map((value) => Users.fromMap(value)).toList();
      } else {
        return <Users>[]; // Return an empty list if no data exists
      }
    });
  }

  Future<void> sendMessage(
      String sender, String reciever, String message) async {
    final messagesRef = _databaseRef.child('messages');
    final usersRef = _databaseRef.child('users');

    try {
      await messagesRef
          .child("01")
          .child(Random.secure().nextInt(10000).toString())
          .set({
        'message': message,
        'sender': sender,
        'receiver': reciever,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Update createdAt for the sender
      await usersRef.child(sender).update({
        'createdAt': DateTime.now().toIso8601String(),
        "lastMessage": message
      });
      // }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Messages>> getMessages() {
    final messagesRef = _databaseRef.child('messages').child("01");

    return messagesRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final messages =
            data.values.map((value) => Messages.fromMap(value)).toList();
        messages.sort(
            (a, b) => a.createdAt.compareTo(b.createdAt)); // Sort by createdAt
        return messages;
      } else {
        return <Messages>[];
      }
    });
  }
}





// import 'dart:async';
// import 'dart:math';

// import 'package:estif_challange/model/messages.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// import '../model/users.dart';
// import '../utils/exception.dart';

// class GlobalProvider with ChangeNotifier {
//   String? user;
//   List<Users> _users = [];
//   List<Users> get users => [..._users];
//   List<Messages> _messages = [];
//   List<Messages> get messages => [..._messages];

//   final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
//   StreamSubscription<DatabaseEvent>? _userSubscription;
//   StreamSubscription<DatabaseEvent>? _messageSubscription;

//   GlobalProvider() {
//     _listenToUsers();
//     _listenToMessages();
//   }

//   Future<void> authenticate(String username) async {
//     final usersRef = _databaseRef.child('users');

//     try {
//       final snapshot = await usersRef.child(username).get();
//       if (!snapshot.exists) {
//         throw CustomException(message: 'USER NOT FOUND!');
//       } else {
//         user = username;
//         notifyListeners();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> getAllUsers() async {
//     final usersRef = _databaseRef.child('users');

//     try {
//       final snapshot = await usersRef.get();

//       if (snapshot.exists) {
//         _users.clear();
//         final data = snapshot.value as Map<dynamic, dynamic>;
//         _users = data.values.map((value) => Users.fromMap(value)).toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       throw CustomException(message: 'Failed to fetch users: $e');
//     }
//   }

//   Future<void> sendMessage(
//       String sender, String reciever, String message) async {
//     final messagesRef = _databaseRef.child('messages');
//     final usersRef = _databaseRef.child('users');

//     try {
//       await messagesRef
//           .child("01")
//           .child(Random.secure().nextInt(10000).toString())
//           .set({
//         'message': message,
//         'sender': sender,
//         'receiver': reciever,
//         'createdAt': DateTime.now().toIso8601String(),
//       });

//       await usersRef.child(sender).update({
//         'createdAt': DateTime.now().toIso8601String(),
//         "lastMessage": message
//       });
//       notifyListeners();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   void _listenToUsers() {
//     final usersRef = _databaseRef.child('users');
//     _userSubscription = usersRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>;
//       _users = data.values.map((value) => Users.fromMap(value)).toList();
//       notifyListeners();
//     });
//   }

//   void _listenToMessages() {
//     final messagesRef = _databaseRef.child('messages').child("01");
//     _messageSubscription = messagesRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>;
//       _messages = data.values.map((value) => Messages.fromMap(value)).toList();
//       notifyListeners();
//     });
//   }

//   Future<void> getMessages() async {
//     final messagesRef = _databaseRef.child('messages').child("01");

//     try {
//       final snapshot = await messagesRef.get();
//       if (snapshot.exists) {
//         final data1 = snapshot.value as Map<dynamic, dynamic>;
//         _messages.clear();
//         _messages =
//             data1.values.map((value) => Messages.fromMap(value)).toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       throw CustomException(message: 'Failed to fetch messages: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _userSubscription?.cancel();
//     _messageSubscription?.cancel();
//     super.dispose();
//   }
// }
