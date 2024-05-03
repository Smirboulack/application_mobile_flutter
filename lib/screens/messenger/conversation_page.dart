import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatBloc.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatEvent.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/screens/messenger/chat_list.dart';


class ConversationPage extends StatefulWidget {
  Conversation? chat;
  User? contact;

  @override
  _ConversationPageState createState() => _ConversationPageState();

  ConversationPage({this.chat, this.contact});
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin {


  late ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    // if (contact != null) chat = Chat(contact.username, contact.id);
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchConversationDetailsEvent(widget.chat!, widget.contact!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  ChatListWidget(widget.chat!, widget.contact);
  }

  @override
  bool get wantKeepAlive => true;
}
