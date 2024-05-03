import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:sevenapplication/screens/messenger/chat_conversation_screen.dart';
import 'package:sevenapplication/screens/messenger/widgets/slide_left.dart';
import 'package:sevenapplication/utils/colors_app.dart';


class ChatRowWidget extends StatelessWidget {
  final Conversation conversation;
  User user_me;

  ChatRowWidget(this.conversation, this.user_me, this.searchText);

  String searchText;

  User other_user() {
    if (conversation.user2!.id == user_me.id)
      return conversation.user1!;
    else
      return conversation.user2!;
  }

  color_message() {
    switch (conversation.type) {

      default:
        return Color(0xffABABAB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!other_user()
                .username
                .toLowerCase()
                .contains(searchText.toLowerCase()) &&
            searchText.isNotEmpty)
        ? new Container()
        : InkWell(
            onTap: () {
              UserDataRepository.update_conversation_vu(conversation.id,
                  conversation.user1!.id, conversation.user2!.id, user_me.id);
              UserDataRepository.update_notif_message0(
                  conversation.user2!.id != user_me.id
                      ? conversation.user1!.id_notification!
                      : conversation.user2!.id_notification!);
              Navigator.push(
                  context,
                  SlideLeftRoute(
                      page: SingleConversationPage(
                    user_him: conversation.user2!.id == user_me.id
                        ? conversation.user1
                        : conversation.user2,
                    user_me: conversation.user2!.id != user_me.id
                        ? conversation.user1
                        : conversation.user2,
                    conversation: conversation,
                  )));
            },
            child: Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  /*  decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0.r),
              color: ColorsConst.col_border,
            ),*/
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                  // margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        //  flex: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                                width: 52.0,
                                height: 52.0,
                                padding: const EdgeInsets.all(0.5),
                                // borde width
                                decoration:  BoxDecoration(
                                  color: ColorsConst.col_app, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 26.r,
                                  backgroundImage: CachedNetworkImageProvider(
                                      other_user().image!),
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  other_user().username.toString(),
                                //  style: AppTextStyles.style_white2_bold22,
                                ),
                                Container(
                                  height: 6.h,
                                ),
                                Container(
                                  width: 200.w,
                                  child: Text(conversation.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Istok Web',

                                          color: conversation.vu == false
                                              ? color_message()
                                              : ColorsConst.col_app_black,
                                          fontSize: 11.sp)),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      Column(
                        //mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DateFormat('kk:mm')
                                    .format(conversation.lastTime!)
                                    .contains("24:")
                                ? DateFormat('kk:mm')
                                    .format(conversation.lastTime!)
                                    .replaceAll("24:", "00:")
                                : DateFormat('kk:mm')
                                    .format(conversation.lastTime!),
                            style: TextStyle(
                                color: Color(0xffABABAB), fontSize: 12.sp),
                          )
                        ],
                      ),
                      Container(
                        width: 4.w,
                      )
                    ],
                  )),
              /* Divider(
          height: 2,
          color: ColorsConst.col_text_grey,
        )*/
            ]),
          );
    /* });*/
  }
}
