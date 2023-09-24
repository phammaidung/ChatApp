import 'package:chat_app/models/generate_room_id.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/widgets/user_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  // dynamic _roomData;
  // @override
  // void initState() {

  //   _getDataFromChatRoom();
  //   super.initState();
  // }

  // void _getDataFromChatRoom(List<String> usersId) async {
  //   _roomData = FirebaseFirestore.instance
  //       .collection('chat_room')
  //       .doc()
  //       .collection('chat').where('roomId', isEqualTo: generateRoomId(usersId));
  // }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
        appBar: AppBar(
          title: const Text('ChitChat'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.group_add_outlined)),
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
                  final roomId = generateRoomId([
                    authenticatedUser.uid,
                    loadedUsers[index].data()['userId']
                  ]);

                  // final curMsg = FirebaseFirestore.instance
                  //     .collection('chat_room')
                  //     .doc(roomId)
                  //     .collection('chat')
                  //     .get();

                  return UserItem(
                    userImg: loadedUsers[index].data()['image_url'],
                    username: loadedUsers[index].data()['username'],
                    //currentMsg: ,
                    openChatMessages: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ChatScreen(
                                friendId: loadedUsers[index].data()['userId'],
                                roomId: roomId,
                              )));
                    },
                  );
                });
          },
        ));
  }
}
