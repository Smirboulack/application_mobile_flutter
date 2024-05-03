import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatBloc.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatEvent.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeBloc.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeEvent.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/chat_services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:sevenapplication/screens/messenger/chat_options_page.dart';
import 'package:sevenapplication/screens/messenger/conversation_page.dart';
import 'package:sevenapplication/screens/messenger/widgets/input_widget.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class SingleConversationPage extends StatefulWidget {
  final User? user_him;
  final User? user_me;
  final Conversation? conversation;

  @override
  _SingleConversationPageState createState() => _SingleConversationPageState();

  SingleConversationPage({this.user_me, this.conversation, this.user_him});
}

class _SingleConversationPageState extends State<SingleConversationPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFirstLaunch = true;
  bool configMessagePeek = true;
  bool show = false;
  bool load = false;

  LiveQuery liveQuery = LiveQuery();
  late Subscription<ParseObject> stream;

  returnn() {
    setState(() {
      show = false;
    });
  }

  initData() async {
    QueryBuilder<ParseObject> userQuery =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', widget.user_me!.id);

    QueryBuilder<ParseObject> or1 =
        QueryBuilder<ParseObject>(ParseObject("Conversation"))
          ..whereMatchesKeyInQuery('user2', "objectId", userQuery);

    QueryBuilder<ParseObject> or2 =
        QueryBuilder<ParseObject>(ParseObject("Conversation"))
          ..whereMatchesKeyInQuery('user1', "objectId", userQuery);

    QueryBuilder<ParseObject> query =
        QueryBuilder.or(ParseObject("Conversation"), [or1, or2])
          ..includeObject(['user1', 'user2'])
          ..setLimit(80)
          ..orderByDescending("lastTime")
          ..setAmountToSkip(0);

    stream = await liveQuery.client.subscribe(query);

    stream.on(LiveQueryEvent.update, (value) {
      print(value);

      if (!this.mounted) return;
      setState(() {
        widget.conversation!.accepted = value["accepted"];
      });
    });
  }

  @override
  void initState() {
    super.initState();

    //  chatBloc = BlocProvider.of<ChatBloc>(context);
    // chatBloc.add(RegisterActiveChatEvent(widget.user_me!.id));
    initData();
  }

  ChatRepository repos = ChatRepository();

  delete_messages() {
    Alert(
        context: context,
        image: Container(),
        title: "Effacer l'historique",
        desc: "Voulez-vous vraiment effacer l'historique ?",
        buttons: [
          DialogButton(
            color: ColorsConst.col_app_black,
            child: Text(
              "Non",
              style: TextStyle(color: Colors.white, fontSize: 15.5.sp),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 12.w,
          ),
          DialogButton(
              color: ColorsConst.col_app,
              child: Text(
                "Oui",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context);

                delete_messages_func();
              })
        ]).show();
  }

  late HomeConversationBloc homeBloc;

  delete_messages_func() async {
    setState(() {
      load = true;
    });
    List<Message> messages =
        await repos.getMessages(widget.conversation!, widget.user_me!);

    for (Message mess in messages) {
      if (mess.show_message!.contains(widget.user_me!.id)) {
        mess.show_message!.remove(widget.user_me!.id);
        await repos.update_messages(mess.objectId, mess.show_message!);
      }
    }
    await UserDataRepository.update_conversation(widget.conversation!.id, "",
        id_receiver: widget.user_him!.id,
        id_sender: widget.user_me!.id,
        my_id: widget.user_me!.id);

    setState(() {
      load = false;
    });
    homeBloc = BlocProvider.of<HomeConversationBloc>(context);
    homeBloc.add(FetchHomeChatsEvent());
    Navigator.pop(context);
  }

  accept_func() {
    setState(() {
      widget.conversation!.accepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget app_bar = AppBar(
        backgroundColor: ColorsConst.col_app,
        title: Row(
          children: [
            Container(
                child: ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: widget.user_him!.image ?? "",
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/placeholder.png'),
                )),
                width: 36.0,
                height: 36.0,
                padding: const EdgeInsets.all(0.5),
                // borde width
                decoration: new BoxDecoration(
                  color: ColorsConst.col_app, // border color
                  shape: BoxShape.circle,
                )),
            Container(width: 8.w),
            Text(
              widget.user_him!.username,
            )
          ],
        ),
        actions: []);

    return Scaffold(
      // backgroundColor: Color(0xff222222),
        appBar: app_bar,
        key: _scaffoldKey,
        body: Stack(children: [
          Column(children: <Widget>[
            Expanded(
                child: ConversationPage(
                        contact: widget.user_me,
                        chat: widget.conversation,
                      )),
            (widget.conversation!.accepted ==
                    false /*&&
                    widget.user_me!.id != widget.conversation!.user1!.id*/
                )
                ? Container()
                : InputWidget(
                    widget.conversation!, widget.user_me!, widget.user_him!)
          ]),
          show
              ? ChatOptionsPage(
                  widget.user_him!, widget.user_me!, returnn, delete_messages)
              : SizedBox(
                  height: 1,
                  width: 1,
                )
        ]));
  }
}
