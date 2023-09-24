import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.friendId, required this.roomId});

  final String friendId;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    Query queryChat = FirebaseFirestore.instance
        .collection('chat_room')
        .doc(roomId)
        .collection('chat')
        .orderBy('createdAt', descending: true);

    return StreamBuilder(
        stream: queryChat.snapshots(),
        builder: (cxt, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No message found.'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMsg = loadedMessages[index];
                final nextChatMsg = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1]
                    : null;
                final currentMsgUserId = loadedMessages[index].get('userId');
                final nextMsgUserId =
                    nextChatMsg != null ? nextChatMsg['userId'] : null;
                final nextUserIsSame = nextMsgUserId == currentMsgUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMsg['message'],
                      isMe: authenticatedUser.uid == currentMsgUserId);
                }
                return MessageBubble.first(
                  userImage: chatMsg['userImage'],
                  username: chatMsg['username'],
                  message: chatMsg['message'],
                  isMe: authenticatedUser.uid == currentMsgUserId,
                );
              });
        });
  }
}
