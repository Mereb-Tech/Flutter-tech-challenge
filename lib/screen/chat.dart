import 'package:estif_challange/controller/global.dart';
import 'package:estif_challange/model/messages.dart';
import 'package:estif_challange/utils/exception.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/chat_timestamp.dart';
import '../utils/message_textfield.dart';

class IndividualChatScreen extends StatefulWidget {
  final String recieverUsername;
  const IndividualChatScreen({super.key, required this.recieverUsername});
  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _controller = TextEditingController();
  // @override
  // void initState() {
  //   context.read<GlobalProvider>().getMessages();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        // forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(capitalizeFirstLetter(widget.recieverUsername)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.indigo),
              child: Text(
                capitalizeFirstLetter(widget.recieverUsername[0]),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      //
      //Chat Body
      //
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/chatBg.jpg"), fit: BoxFit.cover)),
        child: StreamBuilder<List<Messages>>(
          stream: context.read<GlobalProvider>().getMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                // final messages = snapshot.data as List<Messages>;
                final messages = snapshot.data ?? [];
                messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (ctx, index) {
                    final bool isMeReceiver =
                        context.read<GlobalProvider>().user !=
                            messages[index].sender;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        index != messages.length - 1
                            ? Center(
                                child: compareChatDates(
                                    messages[index].createdAt,
                                    messages[index + 1].createdAt),
                              )
                            : Center(
                                child: compareChatDates(
                                    messages[index].createdAt,
                                    DateTime.now()
                                        .add(const Duration(days: 1))
                                        .toIso8601String()),
                              ),
                        Align(
                          alignment: isMeReceiver
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Stack(children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                margin: EdgeInsets.only(
                                    left: isMeReceiver
                                        ? 15
                                        : MediaQuery.of(context).size.width *
                                            0.3,
                                    right: isMeReceiver
                                        ? MediaQuery.of(context).size.width *
                                            0.3
                                        : 15,
                                    top: 5,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                    color: isMeReceiver
                                        ? Colors.amber
                                        : Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(12.0),
                                        topRight: const Radius.circular(12.0),
                                        bottomRight: isMeReceiver
                                            ? const Radius.circular(12.0)
                                            : const Radius.circular(0.0),
                                        bottomLeft: isMeReceiver
                                            ? const Radius.circular(0.0)
                                            : const Radius.circular(12.0))),
                                child: Text(
                                  messages[index].message,
                                  style: TextStyle(
                                      height: 1.3,
                                      color: isMeReceiver
                                          ? Colors.black
                                          : Colors.white),
                                )),
                            isMeReceiver
                                ? Positioned(
                                    bottom: 2,
                                    left: 20,
                                    child: Text(
                                      DateFormat('kk:mm').format(DateTime.parse(
                                        messages[index].createdAt,
                                      )),
                                      style: const TextStyle(fontSize: 9),
                                    ))
                                : Positioned(
                                    bottom: 2,
                                    right: 20,
                                    child: Text(
                                      DateFormat('kk:mm').format(DateTime.parse(
                                        messages[index].createdAt,
                                      )),
                                      style: const TextStyle(
                                          fontSize: 9, color: Colors.white),
                                    ))
                          ]),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
      ),

      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CustomSendMessageTextFormFieldWidget(
            controller: _controller,
            hintText: "hy there ...",
            onSend: () {
              context.read<GlobalProvider>().sendMessage(
                  context.read<GlobalProvider>().user!,
                  widget.recieverUsername,
                  _controller.text);
              _controller.clear();
              // context.read<ChatProvider>().addToRunTimeChatArray(
              //     widget.conversationData.member.id, _controller.text);
              // context.read<ChatProvider>().sendMessage(
              //     chatID: widget.conversationData.id,
              //     recieverID: widget.conversationData.member.id,
              //     message: _controller.text);
            }),
      ),
    );
  }
}
