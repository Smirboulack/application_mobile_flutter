import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/demandes.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/database/demandes_services.dart';
import 'package:sevenapplication/core/services/user_services.dart';
import 'package:sevenapplication/screens/messenger/chat_conversation_screen.dart';
import 'package:sevenapplication/screens/messenger/widgets/slide_left.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/buttonWidget/custom_button.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Demand> demList = []; // This will store the fetched list of users.
  bool load = true;
  bool load_c = false;

  Future<void> demanddesinit() async {
    final demands = await DemandeServices.getAllBossDemandes();
    if (!this.mounted) return;
    setState(() {
      demList = demands;
      load = false;
    });
  }

  void initState() {
    super.initState();
    demanddesinit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConst.col_app,
        title: Text('List des demandes'),
      ),
      body: demList.isNotEmpty
          ? ListView.builder(
              itemCount: demList.length,
              itemBuilder: (context, index) {
                final user = demList[index];
                return ListTile(
                  leading: user.jobber.image != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.jobber.image!),
                        )
                      : CircleAvatar(),
                  // You can use a default avatar if the user's image is null.
                  title: Text(user.jobber.username),

                  trailing: Container(
                    width: 120,
                    child: load_c == true
                        ? CupertinoActivityIndicator()
                        : CustomButton(
                            onPressed: () async {
                              setState(() {
                                load_c = true;
                              });

                              User? user_me =
                                  await UserDataRepository.getUserMe();
                              Conversation? conversation =
                                  await UserDataRepository.get_if_conversation(
                                      user_me!, user.jobber);

                              setState(() {
                                load_c = false;
                              });
                              Navigator.push(
                                  context,
                                  SlideLeftRoute(
                                      page: SingleConversationPage(
                                    user_him: user_me,
                                    user_me: user.jobber,
                                    conversation: conversation,
                                  )));
                            },
                            buttonText: 'Contacter',
                          ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
