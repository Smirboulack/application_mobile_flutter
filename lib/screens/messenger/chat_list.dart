import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatBloc.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatState.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeBloc.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:sevenapplication/screens/messenger/widgets/chat_item.dart';

class ChatListWidget extends StatefulWidget {
  final Conversation chat;
  User? user_me;

  ChatListWidget(this.chat, this.user_me);

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = [];
  late HomeConversationBloc homeBloc;

  // final Conversation conversation;
  LiveQuery liveQuery = LiveQuery();
  late Subscription<ParseObject> stream;

  int skip = 0;

  @override
  void initState() {
    super.initState();
    initData();

    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        /* BlocProvider.of<ChatBloc>(context).add(
            FetchPreviousMessagesEvent(widget.chat, widget.chat.user1!, skip));*/
      }
    });
  }

  initData() async {
    QueryBuilder<ParseObject> query;
    query = QueryBuilder<ParseObject>(ParseObject("Message"))
      ..whereEqualTo("conversation", {
        "__type": "Pointer",
        "className": "Conversation",
        "objectId": "${widget.chat.id}"
      })
      ..includeObject(['song', 'activity'])
      ..setLimit(0);

    stream = await liveQuery.client.subscribe(query);

    stream.on(LiveQueryEvent.create, (value) async {
      if (!this.mounted) return;


      setState(() {
        User sender = value["sender"]["objectId"] == widget.chat.user1!.id
            ? widget.chat.user1!
            : widget.chat.user2!;
        messages.insert(
            0, Message.fromMap(value, widget.user_me!, sender: sender));
      });

      UserDataRepository.update_conversation(
        widget.chat.id,
        value["message"],
        my_id: widget.user_me!.id,
        id_sender:  value["sender"]["objectId"] != widget.chat.user1!.id
            ? widget.chat.user1!
            : widget.chat.user2!,
        id_receiver:  value["sender"]["objectId"] == widget.chat.user1!.id
            ? widget.chat.user1!
            : widget.chat.user2!,
      ).then((value) {
        //  homeBloc = BlocProvider.of<HomeConversationBloc>(context);
        // homeBloc.add(FetchHomeChatsEvent());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    liveQuery.client.unSubscribe(stream);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      if (state is FetchedMessagesState) {
        print('Received Messages');

        print(state.messages);

        if (state.isPrevious)
          messages.addAll(state.messages);
        else
          messages = state.messages; //
      }
      return /*messages.isEmpty
          ? Center(
              child: Text("Vous n'avez aucun message !",
                  style: AppTextStyles.error))
          : */
          ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 28.w),
        itemBuilder: (context, index) => ChatItemWidget(
            messages[index],
            widget.user_me,
            index < messages.length - 1 ? messages[index + 1].sender!.id : "",
            index < messages.length - 1
                ? new DateFormat('dd/MM/yyyy')
                    .format(messages[index + 1].created)
                : ""),
        itemCount: messages.length,
        reverse: true,
        controller: listScrollController,
      );
    });
  }
}
