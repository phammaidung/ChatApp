import 'dart:convert';

import 'package:crypto/crypto.dart';

String generateRoomId(List<String> usersId) {
  final usersIdSorted = _sortListIds(usersId);
  final usersIdToHash = usersIdSorted.join();

  final idToByte = utf8.encode(usersIdToHash);
  final roomId = sha256.convert(idToByte);
  return roomId.toString();
}

List<String> _sortListIds(List<String> list) {
  list.sort();
  return list;
}
