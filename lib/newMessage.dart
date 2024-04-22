import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _SubmitMessage() async {
    final entredMessage = _messageController.text;

    if (entredMessage.trim().isEmpty) {
      return;
    }

    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': entredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['UserName'],
      'userImage': userData.data()!['ImgUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: _messageController,
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration:
               InputDecoration(
                 labelText: "send a message....",
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade400,width: 2.0)
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2.0)
                ),
              ),
            ),
          ),
          IconButton(onPressed: _SubmitMessage, icon: const Icon(Icons.send, color: Colors.blue,))
        ],
      ),
    );
  }
}
