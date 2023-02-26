import 'package:flutter/material.dart';
import '../components/custom_chat_buble.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  static String id = 'chatPage';
  TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();
  String? message;
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  void _scrollDown() {
    _controller.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/scholar.png',
                      height: 75,
                    ),
                    const Text(
                      'My Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].id == email
                            ? ChatBuble(
                                message: messagesList[index],
                              )
                            : ChatBubleForFriend(
                                message: messagesList[index],
                              );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (data) {
                        message = data;
                      },
                      controller: controller,
                      onSubmitted: (data) {
                        messages.add({
                          'message': data,
                          'createdAt': DateTime.now(),
                          'id': email,
                        });
                        controller.clear();
                        _scrollDown();
                      },
                      decoration: InputDecoration(
                        hintText: 'Send a message',
                        suffixIcon: IconButton(
                          onPressed: () {
                            messages.add({
                              'message': message,
                              'createdAt': DateTime.now(),
                              'id': email,
                            });
                            controller.clear();

                            FocusScope.of(context).unfocus();
                            _scrollDown();
                          },
                          icon: const Icon(Icons.send),
                          color: kPrimaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Text('loading...');
          }
        });
  }
}
