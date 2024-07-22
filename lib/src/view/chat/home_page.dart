import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merem_chat_app/di.dart';
import 'package:merem_chat_app/routes/app_router.dart';
import 'package:merem_chat_app/src/models/message.dart';
import 'package:merem_chat_app/src/models/user.dart';
import 'package:merem_chat_app/src/viewmodels/chat_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return ChangeNotifierProvider(
      create: (context) => getIt<ChatViewModel>()
        ..getUsersList()
        ..loadChats(user?.uid ?? ''),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.colorScheme.secondary],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Messages',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.pushRoute(ProfileRoute(userId: user!.uid));
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'R E C E N T',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Consumer<ChatViewModel>(
                        builder: (context, chatViewModel, child) {
                      if (chatViewModel.users.isEmpty) {
                        return _buildShimmerEffect();
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          await chatViewModel.getUsersList();
                        },
                        child: ListView.builder(
                          itemCount: chatViewModel.users.length,
                          itemBuilder: (context, index) {
                            final user = chatViewModel.users[index];
                            final chat = chatViewModel.getChatWithUser(user.id);
                            final lastMessage = chat?.lastMessage;

                            return InkWell(
                              onTap: () async {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  final chatId =
                                      await chatViewModel.getOrCreateChatId(
                                          currentUser.uid, user.id);
                                  context.router.push(
                                    ChatDetailRoute(
                                      chatId: chatId,
                                      username: user.username,
                                    ),
                                  );
                                }
                              },
                              child: _buildChatItem(user, lastMessage),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(UserModel user, MessageModel? lastMessage) {
    final lastMessageText = lastMessage?.text ?? 'No messages yet';
    final lastMessageTime = lastMessage != null
        ? DateFormat('hh:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(lastMessage.createdAt))
        : '';
    final lastMessageDate = lastMessage != null
        ? DateFormat('MM/dd/yyyy')
            .format(DateTime.fromMillisecondsSinceEpoch(lastMessage.createdAt))
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Text(
              user.username[0],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      lastMessageDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lastMessageText,
                        style: const TextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      lastMessageTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 150.0,
                        height: 10.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
