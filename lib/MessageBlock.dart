import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'messagebubble.dart';


class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final userAuth = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
        'createdAt',
        descending: true,
      )
          .snapshots(),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text("NO MESSAGES FOUND." , style: TextStyle(color: Colors.white),),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text("Something went wrong", style: TextStyle(color: Colors.white)),
          );
        }

        final loadedMessage = chatSnapshots.data!.docs;
        // return card_show(size: size);
        return Chat_ui(loadedMessage: loadedMessage, userAuth: userAuth);
      },
    );
  }
}


class card_show extends StatelessWidget {
  const card_show({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: size.width,
        height: size.height * 0.1,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green,
              ),
              SizedBox(
                width: 10,
              ),
              Text("User Name"),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class Chat_ui extends StatelessWidget {
  const Chat_ui({
    super.key,
    required this.loadedMessage,
    required this.userAuth,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> loadedMessage;
  final User userAuth;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
        itemCount: loadedMessage.length,
        reverse: true,
        itemBuilder: (context, index) {
          final chatMessage = loadedMessage[index].data();
          final nextChatMessage = index + 1 < loadedMessage.length
              ? loadedMessage[index + 1].data()
              : null;
          final currentMessageUserId = chatMessage['userId'];
          final nextMessageUserId =
          nextChatMessage != null ? nextChatMessage['userId'] : null;
          final nextUserIsSame = nextMessageUserId == currentMessageUserId;

          if (nextUserIsSame) {
            return FadeInUp(duration: const Duration(milliseconds: 1200), child:MessageBubble.next(
              message: chatMessage['text'],
              isMe: userAuth.uid == currentMessageUserId,
            ));
          } else {
            return FadeInUp(duration: const Duration(milliseconds: 1200), child:MessageBubble.first(
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: userAuth.uid == currentMessageUserId));
          }
        });
  }
}

