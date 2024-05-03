import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sevenapplication/utils/colors_app.dart';


class ChatItemWidget extends StatelessWidget {
  Message message;
  String? previous_id;
  String? previous_date;
  User? me;

  ChatItemWidget(this.message, this.me, this.previous_id, this.previous_date);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
    late bool isSelf = me!.email == message.sender!.id ? true : false;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(children: <Widget>[
          buildMessageContainer(isSelf, message, context),
        ]));
  }

  Widget buildMessageContainer(
      bool isSelf, Message message, BuildContext context) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    if (message.type == "text") {
      lrEdgeInsets = 15.0;
      tbEdgeInsets = 10.0;
    }
    return Column(
      crossAxisAlignment:
          isSelf != false ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: <Widget>[
        Center(
            child: (new DateFormat('dd/MM/yyyy').format(message.created) ==
                        previous_date &&
                    previous_date != "")
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: ColorsConst.col_border, width: 1),
                      color: ColorsConst.background_field,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      new DateFormat('dd/MM/yyyy').format(message.created),
                      style: TextStyle(color: ColorsConst.col_app),
                    ))),

        /* message.sender == null
            ? Container()
            : message.isSelf == false
            ? */
        (message.sender!.id == previous_id && previous_id != "")
            ? Container()
            : Container(
                child: CircleAvatar(
                  radius: 21.r,
                  backgroundImage:
                      CachedNetworkImageProvider(message.sender!.image??""),
                ),
                width: 42.0.w,
                height: 42.0.w,
                padding: EdgeInsets.all(1.0.w),
                // borde width
                decoration: new BoxDecoration(
                  color: ColorsConst.col_app, // border color
                  shape: BoxShape.circle,
                )),
        Container(height: 10.h),

        ChatBubble(
          elevation: 1,
          backGroundColor: me!.id == message.sender!.id
              ? ColorsConst.col_app
              : ColorsConst.col_app_f,
          clipper: me!.id == message.sender!.id
              ? ChatBubbleClipper2(type: BubbleType.sendBubble)
              : ChatBubbleClipper2(
              type: BubbleType.receiverBubble),
          child:Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            constraints: BoxConstraints(
                maxWidth:
                MediaQuery.of(context).size.width * 0.6),
            child: Row(
              children: [
                Expanded(child: buildMessageContent(isSelf, message, context)),
                buildTimeStamp(context, isSelf, message)
              ],
            ),
          ),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
         /* width: 290.w,
          // constraints: BoxConstraints(wi: 300.0.w),
          decoration: BoxDecoration(
           /* color:me!.id == message.sender!.id
                    ? const Color(0xff484848) /*Color(0xff484848)*/
                    : ColorsConst.col_app_black,*/
            borderRadius: BorderRadius.circular(8.0),
            border: (message.type == "reactin" || message.type == "sharin")
                ? null
                : Border.all(
                    color: me!.id == message.sender!.id
                        ? Color(0xff484848)
                        : Color(0xff707070),
                    width: 0.8),


          ),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
        */)
      ],
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.end
          : MainAxisAlignment.start, // aligns the chatitem to right end
    );
  }

  buildMessageContent(bool isSelf, Message message, BuildContext context) {


    if (message.type == "text") {
      return Text(
        message.message,
        style: TextStyle(color: ColorsConst.col_wite),
      );
    }


    }
  }

  Row buildTimeStamp(BuildContext context, bool isSelf, Message message) {
    return Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 12.w,
          ),
          (message.type == "reactin" || message.type == "sharin")
              ? Container()
              : Container(
                  child: Text(
                    DateFormat('kk:mm').format(message.created).contains("24:")
                        ? DateFormat('kk:mm')
                            .format(message.created)
                            .replaceAll("24:", "00:")
                        : DateFormat('kk:mm').format(message.created),
                    // timeago.format(message.createdAt, locale: "fr"),
                    style: TextStyle(
                      color: const Color(0xFF898686),
                    ),
                  ),
                  margin: EdgeInsets.only(
                      left: isSelf ? 5.0 : 0.0,
                      right: isSelf ? 0.0 : 5.0,
                      top: 5.0,
                      bottom: 5.0),
                ),
          Container(width: 12.w)
        ]);
  }

