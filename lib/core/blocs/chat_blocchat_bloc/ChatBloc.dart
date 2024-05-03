import 'dart:async';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatEvent.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatState.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/services/chat_services.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository? chatRepository;
  final UserDataRepository? userDataRepository;
  Map<String, StreamSubscription> messagesSubscriptionMap = Map();
  late StreamSubscription chatsSubscription;
  late String activeChatId;

  ChatBloc(
      {this.chatRepository, this.userDataRepository})
      : assert(chatRepository != null),
        assert(userDataRepository != null), super(InitialChatState())
        ;

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {

    if (event is FetchChatListEvent) {
      yield* mapFetchChatListEventToState(event);
    }
    if (event is RegisterActiveChatEvent) {
      activeChatId = event.activeChatId;
    }
    if (event is ReceivedChatsEvent) {
      yield FetchedChatListState([]);

      ///jiji
    }
    if (event is PageChangedEvent) {
      //  activeChatId = event.activeChat.chatId;
      yield PageChangedState(event.conversation, event.user_me, event.index);
    }
    if (event is FetchConversationDetailsEvent) {
      yield* mapFetchConversationDetailsEventToState(event);
    }
    if (event is FetchMessagesEvent) {
      yield* mapFetchMessagesEventToState(event);
    }
    if (event is FetchPreviousMessagesEvent) {
      yield* mapFetchPreviousMessagesEventToState(event);
    }

    if (event is ReceivedMessagesEvent) {
      print('dispatching received messages');
      yield FetchedMessagesState(event.messages, isPrevious: false);
    }
    if (event is SendTextMessageEvent) {
      Message message = event.message;
      await chatRepository!.sendMessage(message);
    }

  }

  Stream<ChatState> mapFetchChatListEventToState(
      FetchChatListEvent event) async* {
    try {
      chatsSubscription.cancel();
      chatsSubscription = chatRepository!
          .getChats()
          .listen((chats) => add(ReceivedChatsEvent(chats)));
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchMessagesEventToState(
      FetchMessagesEvent event) async* {
    try {
      yield FetchingMessageState();

      chatRepository!
          .getMessages(event.chat, event.user)
          .then((messages) => add(ReceivedMessagesEvent(messages)));

      //messagesSubscriptionMap[chatId] = messagesSubscription;
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchPreviousMessagesEventToState(
      FetchPreviousMessagesEvent event) async* {
    try {
      final messages = await chatRepository!.getMessages(
          event.conversation, event.user_me);
      yield FetchedMessagesState(messages, isPrevious: true);
    } on Exception catch (exception) {
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event) async* {
   // UserData? user; //= await userDataRepository.getUser(event.chat.username);
   // yield FetchedContactDetailsState(event.user);
    add(FetchMessagesEvent(event.chat, event.user));
  }

  @override
  void dispose() {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
  }
}
