import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/screens/messenger/ConversationListWidget.dart';

import '../../utils/colors_app.dart';


class ChatMainPage extends StatefulWidget {
  ChatMainPage(this.user_me, {Key? key}) : super(key: key);
  User user_me;

  @override
  _ChatMainPageState createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> {
  final FocusNode _focus = new FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  String _searchText = "";
  bool _IsSearching = false;




  _ChatMainPageState() {


    textEditingController.addListener(() {
      if (textEditingController.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = textEditingController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      children: [

        const Text("Discussions",),
        Container(
          height: 12.h,
        ),
        Container(
            decoration: BoxDecoration(
              // border: Border.all(color: ColorsConst.col_border, width: 1),
              color: ColorsConst.col_app_black,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
            child: TextFormField(
              controller: textEditingController,
              focusNode: _focus,
              textAlignVertical: TextAlignVertical.center,
              //textAlign: TextAlign.center,

              keyboardType: TextInputType.text,
              maxLines: 1,
              minLines: 1,
              onChanged: (value) {},
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Chercher iune conversation",
                  hintStyle: TextStyle(color: Color(0xff979797)),
                  labelStyle: TextStyle(color: Colors.white)

                  // contentPadding: EdgeInsets.all(8),
                  ),
            )),
        Container(height: 10.h),
        ConversationListWidget(widget.user_me, _searchText)
      ],
    );
  }
}
