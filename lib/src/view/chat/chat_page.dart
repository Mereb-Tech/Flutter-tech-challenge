// lib/pages/chat_detail_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat;
import 'package:merem_chat_app/core/helpers/string_extensions.dart';
import 'package:merem_chat_app/di.dart';
import 'package:merem_chat_app/src/models/message.dart';
import 'package:merem_chat_app/src/viewmodels/chat_view_model.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ChatDetailPage extends StatefulWidget {
  final String chatId;
  final String username;

  const ChatDetailPage(
      {super.key, required this.chatId, required this.username});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final types.User _user =
      types.User(id: FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) => getIt<ChatViewModel>()..loadMessages(widget.chatId),
      child: Consumer<ChatViewModel>(
        builder: (context, chatViewModel, child) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 30,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.colorScheme.secondary],
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: () {
                    context.router.back();
                  },
                ),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(145, 18, 104, 175),
                    child: Text(
                      widget.username.isNotEmpty
                          ? widget.username[0].toTitleCase()
                          : '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.username.isEmpty
                        ? 'Chat'
                        : widget.username.toTitleCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<List<MessageModel>>(
              stream: chatViewModel.getMessageStream(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.map((message) {
                  return types.TextMessage(
                    author: types.User(id: message.authorId),
                    createdAt: message.createdAt,
                    id: message.id,
                    text: message.text,
                  );
                }).toList();

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  child: chat.Chat(
                    messages: messages,
                    onSendPressed: (message) => chatViewModel.sendMessage(
                        message.text, _user.id, widget.chatId),
                    user: _user,
                    emptyState: const Center(
                      child: Text('No messages yet.'),
                    ),
                    textMessageBuilder: (p0,
                        {required messageWidth, required showName}) {
                      return Stack(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1, left: 10),
                            child: Text(
                              p0.author.id == _user.id
                                  ? 'You'
                                  : widget.username.toTitleCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: p0.author.id == _user.id
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          chat.TextMessage(
                            message: p0,
                            showName: true,
                            emojiEnlargementBehavior:
                                chat.EmojiEnlargementBehavior.single,
                            hideBackgroundOnEmojiMessages: false,
                            usePreviewData: true,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 2, right: 10),
                              child: Text(
                                'Sent ${_formatTimestamp(DateTime.fromMillisecondsSinceEpoch(p0.createdAt ?? 0))}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final time = TimeOfDay.fromDateTime(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (date == today) {
      return 'Today, ${time.format(context)}';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${time.format(context)}';
    } else {
      return '${timestamp.month}/${timestamp.day}/${timestamp.year}, ${time.format(context)}';
    }
  }
}
