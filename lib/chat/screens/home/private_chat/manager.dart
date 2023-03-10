import 'dart:collection';

import 'private_chat.dart';

class PrivateChats{
  static PrivateChats? _inst;
  PrivateChats._internal();
  static PrivateChats get inst{
    _inst ??=PrivateChats._internal();
    return _inst!;
  }

  final HashMap<String, PrivateChat> _chats = HashMap();

  PrivateChat getOrCreate(String uid, {String? chatId}){
    var c = _chats[uid];
    if (c!=null) return c;
    _chats[uid] = PrivateChat(uid, chatId: chatId);
    return _chats[uid]!;
  }
}