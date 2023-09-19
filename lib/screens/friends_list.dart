import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/widgets/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('ChatBox'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('userId', isNotEqualTo: authenticatedUser.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No user found.'),
              );
            }

            final loadedUsers = userSnapshot.data!.docs;

            return ListView.builder(
                itemCount: loadedUsers.length,
                itemBuilder: (ctx, index) {
                  return UserItem(
                    userImg: loadedUsers[index].data()['image_url'],
                    username: loadedUsers[index].data()['username'],
                    openChatMessages: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const ChatScreen()));
                    },
                  );
                });
          },
        ));
  }
}
