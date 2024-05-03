import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatBloc.dart';
import 'package:sevenapplication/core/blocs/chat_blocchat_bloc/ChatEvent.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/messaging_handler.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:sevenapplication/utils/colors_app.dart';

class InputWidget extends StatefulWidget {
  InputWidget(this.conversation, this.user_me, this.user_him);

  User user_me;
  User user_him;
  Conversation conversation;

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late ChatBloc chatBloc;
  final FocusNode _focus = new FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  bool sendButton = false;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Start the recorder

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        height: 58.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /**
                 *   width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    ),
                 */
                Container(
                  width: 15.w,
                ),
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    focusNode: _focus,
                    textAlignVertical: TextAlignVertical.center,
                    //textAlign: TextAlign.center,

                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    onChanged: (value) {
                      if (value.length > 0) {
                        setState(() {
                          sendButton = true;
                        });
                      } else {
                        setState(() {
                          sendButton = false;
                        });
                      }
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Écrire quelque chose",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        labelStyle: TextStyle(color: Colors.white)
                        // contentPadding: EdgeInsets.all(8),
                        ),
                  ),
                ),
                InkWell(
                  child: Text(
                    "Envoyer",
                    style: TextStyle(color: ColorsConst.col_app_f),
                  ),
                  onTap: () => textEditingController.text.length == 0
                      ? null
                      : sendMessage(context),
                ),
              ],
            ),
          ],
        ),
      ),
    ) /*Material(
        elevation: 60.0,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      child: IconButton(
                        icon: Icon(Icons.face),
                        color: Theme.of(context).accentColor,
                        onPressed: () =>chatBloc.add(ToggleEmojiKeyboardEvent(!showEmojiKeyboard)),
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),

                  // Text input
                  Flexible(
                    child: Material(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                      child: TextField(
                        style: Theme.of(context).textTheme.body2,
                        controller: textEditingController,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                    )),
                  ),

                  // Send Message Button
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => sendMessage(context),
                        color:Theme.of(context).accentColor,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
                showEmojiKeyboard = state is ToggleEmojiKeyboardState &&
                    state.showEmojiKeyboard;
                if (!showEmojiKeyboard) return Container();
                //hide keyboard
                FocusScope.of(context).requestFocus(new FocusNode());
                //create emojipicker
                return EmojiPicker(
                  rows: 4,
                  columns: 7,
                  bgColor: Theme.of(context).backgroundColor,
                  indicatorColor: Theme.of(context).accentColor,
                  onEmojiSelected: (emoji, category) {
                    textEditingController.text = textEditingController.text+ emoji.emoji;
                  },
                );
              })
            ],
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Theme.of(context).hintColor, width: 0.5)),
              color: Theme.of(context).primaryColor,
        ),
        ))*/
        ;
  }

  void sendMessage(context) {
    // if (textEditingController.text.isEmpty) return;
    Message message_text = Message(
      conversation: widget.conversation,
      message: textEditingController.text,
      sender: widget.user_me,
      receiver: widget.user_him,
      type: "text",
      created: DateTime.now().toUtc(),
    );
    chatBloc.add(SendTextMessageEvent(message_text));
    //   UserDataRepository.update_notif_message(widget.user_him.id_notification!);
    /* if (widget.user_him.token != '') {
      CloudMessaging.sendCustomNotif(
          widget.user_him.token!,
          widget.user_me.username + ", vous a envoyé un nouveau message !",
          "message",
          widget.conversation.id,
          widget.user_him);
    }*/
    textEditingController.clear();
  }
}
