import 'package:estif_challange/controller/global.dart';
import 'package:estif_challange/main.dart';
import 'package:estif_challange/screen/chat.dart';
import 'package:estif_challange/utils/exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/users.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // late Future _convs;
  @override
  void initState() {
    // _convs = context.read<GlobalProvider>().getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversation"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder<List<Users>>(
          stream: context.read<GlobalProvider>().getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator.adaptive()));
            } else {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                final users = snapshot.data as List<Users>;
                return ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (users[index].username ==
                        context.read<GlobalProvider>().user) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () async {
                        navigationKey.currentState!.push(CupertinoPageRoute(
                            builder: (context) => IndividualChatScreen(
                                recieverUsername: users[index].username)));
                        // await context.read<GlobalProvider>().getMessages(
                        //       context.read<GlobalProvider>().user!,
                        //       users[index].username,
                        //     );
                        // context.read<GlobalProvider>().sendMessage(
                        //     context.read<GlobalProvider>().user!,
                        //     users[index].username,
                        //     "Mama");
                      },
                      child: Card(
                          elevation: 0.5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: SizedBox(
                            height: 70,
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 45,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.indigo),
                                          child: Text(
                                            capitalizeFirstLetter(
                                                users[index].username[0]),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              capitalizeFirstLetter(
                                                  users[index].username),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            if (users[index].lastMessage != "")
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  capitalizeFirstLetter(
                                                      users[index].lastMessage),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      height: 1.2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      fontSize: 12),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ]),
                                  if (users[index].createdAt != "")
                                    Text(
                                      DateFormat('kk:mm').format(DateTime.parse(
                                        users[index].createdAt,
                                      )),
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                          )),
                    );
                  },
                );
              }
            }
          },
        ),
      )),
    );
  }
}
