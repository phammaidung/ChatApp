import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.userImg,
    required this.username,
    required this.openChatMessages,
    //required this.currentMsg,
  });

  final String userImg;
  final String username;
  //final String? currentMsg;
  final void Function() openChatMessages;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundImage: NetworkImage(userImg),
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(180),
      ),
      title: Text(username),
      //subtitle: Text(currentMsg ?? ''),
      onTap: openChatMessages,
    );
  }
}
