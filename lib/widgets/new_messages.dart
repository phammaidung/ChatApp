import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key, required this.friendId, required this.roomId});

  final String friendId;
  final String roomId;

  @override
  State<NewMessages> createState() {
    return _NewMessagesState();
  }
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final roomIdExist = await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(widget.roomId)
        .get();

    final usersMessage = await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(widget.roomId)
        .collection('chat')
        .add({
      'roomId': roomIdExist.data()?['roomId'] ?? widget.roomId,
      'userId': user.uid,
      'createdAt': Timestamp.now(),
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
      'message': enteredMessage
    });

    if (widget.roomId == roomIdExist.data()?['roomId']) {
      FirebaseFirestore.instance
          .collection('chat_room')
          .doc(widget.roomId)
          .update({'last_message': usersMessage});
    } else {
      FirebaseFirestore.instance
          .collection('chat_room')
          .doc(widget.roomId)
          .set({
        'roomId': widget.roomId,
        'members': {user.uid, widget.friendId},
        'last_message': usersMessage
      });
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            decoration:
                const InputDecoration(labelText: 'Enter message here ...'),
          )),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _submitMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
