import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sevenapplication/core/models/Chat.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';


@immutable
abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const <dynamic>[]]) : super();
}


//triggered to fetch list of chats
class FetchChatListEvent extends ChatEvent {
  @override
  String toString() => 'FetchChatListEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}


//triggered when stream containing list of chats has new data
class ReceivedChatsEvent extends ChatEvent {
  final List<Chat> chatList;

  ReceivedChatsEvent(this.chatList);

  @override
  String toString() => 'ReceivedChatsEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//triggered to get details of currently open conversation
class FetchConversationDetailsEvent extends ChatEvent {
  final Conversation chat;
  final User user;

  FetchConversationDetailsEvent(this.chat, this.user) : super([chat, user]);

  @override
  String toString() => 'FetchConversationDetailsEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//triggered to fetch messages of chat, this will also keep a subscription for new messages
class FetchMessagesEvent extends ChatEvent {
  final Conversation chat;
  final User user;
  FetchMessagesEvent(this.chat,this.user) : super([chat, user]);

  @override
  String toString() => 'FetchMessagesEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}
//triggered to fetch messages of chat
class FetchPreviousMessagesEvent extends ChatEvent {
  final Conversation conversation;
  final int skip;
  User user_me;

  FetchPreviousMessagesEvent(this.conversation,this.user_me, this.skip) : super([conversation,user_me, skip]);

  @override
  String toString() => 'FetchPreviousMessagesEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}



//triggered when messages stream has new data
class ReceivedMessagesEvent extends ChatEvent {
  final List<Message> messages;
  //final String username;
  ReceivedMessagesEvent(this.messages) : super([messages]);

  @override
  String toString() => 'ReceivedMessagesEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}




//triggered to send new text message
class SendTextMessageEvent extends ChatEvent {
  final Message message;

  SendTextMessageEvent(this.message) : super([message]);

  @override
  String toString() => 'SendTextMessageEvent {message: $message}';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//triggered on page change
class PageChangedEvent extends ChatEvent {
  final int index;
  final Conversation conversation;
  User user_me;
  PageChangedEvent(this.conversation,this.user_me,this.index) : super([index]);

  @override
  String toString() => 'PageChangedEvent {index: $index}';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RegisterActiveChatEvent extends ChatEvent{
  final String activeChatId;
  RegisterActiveChatEvent(this.activeChatId);
  @override
  String toString() => 'RegisterActiveChatEvent { activeChatId : $activeChatId }';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

// hide/show emojikeyboard
class ToggleEmojiKeyboardEvent extends ChatEvent{
  final bool showEmojiKeyboard;

  ToggleEmojiKeyboardEvent(this.showEmojiKeyboard);

  @override
  String toString() => 'ToggleEmojiKeyboardEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}