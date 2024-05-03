import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';


@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super();
}

class InitialChatState extends ChatState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchedChatListState extends ChatState {
  final List<Message> chatList;

  FetchedChatListState(this.chatList) : super([chatList]);

  @override
  String toString() => 'FetchedChatListState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class FetchingMessageState extends ChatState{
  @override
  String toString() => 'FetchingMessageState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}



class FetchedMessagesGroupeState extends ChatState {
  final List messages;
  final isPrevious;
  FetchedMessagesGroupeState(this.messages, {this.isPrevious}) : super([messages,isPrevious]);

  @override
  String toString() => 'FetchedMessagesState {messages: ${messages.length}, isPrevious: $isPrevious}';

  @override
  // TODO: implement props
  List<Object> get props => [messages];
}


class FetchedMessagesState extends ChatState {
  final List<Message> messages;
 // final String username;
  final isPrevious;
  FetchedMessagesState(this.messages, {this.isPrevious}) : super([messages,isPrevious]);

  @override
  String toString() => 'FetchedMessagesState {messages: ${messages.length}, isPrevious: $isPrevious}';

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ErrorState extends ChatState {
  final Exception exception;

  ErrorState(this.exception) : super([exception]);

  @override
  String toString() => 'ErrorState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FetchedContactDetailsState extends ChatState {
   User user;
  FetchedContactDetailsState(this.user) : super([user]);

  @override
  String toString() => 'FetchedContactDetailsState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PageChangedState extends ChatState {
  final int index;
  Conversation conversation;
  User user_me;

  PageChangedState(this.conversation,this.user_me, this.index) : super([index]);

  @override
  String toString() => 'PageChangedState';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ToggleEmojiKeyboardState extends ChatState{
  final bool showEmojiKeyboard;

  ToggleEmojiKeyboardState(this.showEmojiKeyboard): super([showEmojiKeyboard]);

  @override
  String toString() => 'ToggleEmojiKeyboardState';

  @override
  // TODO: implement props
  List<Object> get props => [];
}
