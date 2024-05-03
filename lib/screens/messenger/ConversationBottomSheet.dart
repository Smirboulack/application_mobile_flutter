import 'package:flutter/material.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/screens/messenger/ConversationListWidget.dart';


class ConversationBottomSheet extends StatefulWidget {
  ConversationBottomSheet(this.user_me);
  User user_me;

  @override
  _ConversationBottomSheetState createState() =>
      _ConversationBottomSheetState();

}

class _ConversationBottomSheetState extends State<ConversationBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: ListView(children: <Widget>[
              /*GestureDetector(
                child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      NavigationPillWidget(),
                      Center(
                          child: Text('Messages', style: Theme.of(context).textTheme.title)),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity > 50) {
                    Navigator.pop(context);
                  }
                },
              ),*/
              ConversationListWidget(widget.user_me,""),
            ])));
  }
}
