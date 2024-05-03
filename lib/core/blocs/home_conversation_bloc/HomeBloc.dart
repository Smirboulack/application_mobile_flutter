import 'dart:async';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/services/chat_services.dart';
import './Bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeConversationBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => InitialHomeState();
  ChatRepository? chatRepository;

  HomeConversationBloc({this.chatRepository})
      : assert(chatRepository != null),
        super(InitialHomeState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    print(event);
    if (event is FetchHomeChatsEvent) {
      yield FetchingHomeChatsState();
      chatRepository!.getConversations().then((conversations) =>
          add(ReceivedChatsEvent(conversations.conversations)));
    }
    if (event is ReceivedChatsEvent) {
      yield FetchingHomeChatsState();
      yield FetchedHomeChatsState(event.conversations as List<Conversation>);
    }
  }
}
