import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeBloc.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeEvent.dart';
import 'package:sevenapplication/core/blocs/home_conversation_bloc/HomeState.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/screens/messenger/widgets/row_chat_widget.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class ConversationListWidget extends StatefulWidget {
  ConversationListWidget(this.user_me, this.searchText);

  String searchText;

  User user_me;

  @override
  State createState() => _ConversationListWidgetState();
}

class _ConversationListWidgetState extends State<ConversationListWidget> {
  late HomeConversationBloc homeBloc;
  List<Conversation> conversations = [];

  int indx = 0;
  bool isLoading = true;

  LiveQuery liveQuery = LiveQuery();
  late Subscription<ParseObject> stream;

  initData() async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject("Conversation"))
          ..whereEqualTo("ids", widget.user_me.id)
          ..includeObject(['user1', 'user2'])
          ..setLimit(0)
          ..orderByDescending("lastTime")
          ..setAmountToSkip(0);
    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      print(apiResponse.results);
    }

    stream = await liveQuery.client.subscribe(query);

    stream.on(LiveQueryEvent.update, (value) {
      if (!this.mounted) return;

      int i = conversations
          .indexWhere((element) => element.id == value["objectId"]);

      setState(() {
        conversations[i].lastMessage = value["lastMessage"];
        conversations[i].lastTime =
            DateTime.fromMillisecondsSinceEpoch(value["lastTime"]);
      });

      setState(() {
     conversations.sort((a,b) {
          var adate = a.lastTime; //before -> var adate = a.expiry;
          var bdate = b.lastTime; //before -> var bdate = b.expiry;
          return bdate!.compareTo(adate!); //to get the order other way just switch `adate & bdate`
        });
      });



    });
  }

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeConversationBloc>(context);
    homeBloc.add(FetchHomeChatsEvent());
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    Widget private =
        BlocBuilder<HomeConversationBloc, HomeState>(builder: (context, state) {
      if (state is FetchingHomeChatsState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is FetchedHomeChatsState) {
        conversations = state.conversations;
      }
      return Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(12.0.r),
            color: ColorsConst.col_app_black,
          ),
          padding:
              EdgeInsets.symmetric(vertical: conversations.isEmpty ? 28.h : 0),
          // margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          child: conversations.isEmpty
              ? Center(
                  child: Text(
                    "Aucune discussion trouvée !",
                    style: TextStyle(fontSize: 16.sp, color: Color(0xff979797)),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 2.h,
                      color: ColorsConst.col_app_black,
                    ) /* Your separator widget here */;
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) => ChatRowWidget(
                      conversations[index],
                      widget.user_me,
                      widget.searchText)));
    });

    return private;
  }
}
