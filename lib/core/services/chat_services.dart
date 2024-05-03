import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sevenapplication/core/models/Chat.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/connversation_message.dart';
import 'package:sevenapplication/core/models/user.dart';
import 'package:sevenapplication/core/services/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  late BaseChatProvider chatProvider;


  Future update_messages(
      String id , List<String> chat_mess) async {
    var insertt = ParseObject('Message')
      ..objectId = id
      ..set('show_message', chat_mess);
    ParseResponse a = await insertt.save();
    return a.success;
  }

  Future<ConversationResponse> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id").toString();

    QueryBuilder<ParseObject> userQuery =
    QueryBuilder<ParseObject>(ParseObject('_User'))
      ..whereEqualTo('objectId', id);

    QueryBuilder<ParseObject> or1 =
    QueryBuilder<ParseObject>(ParseObject("Conversation"))
      ..whereEqualTo("accepted", true)
      ..whereMatchesKeyInQuery('user2', "objectId", userQuery);

    QueryBuilder<ParseObject> or2 =
    QueryBuilder<ParseObject>(ParseObject("Conversation"))
      ..whereEqualTo("accepted", true)
      ..whereMatchesKeyInQuery('user1', "objectId", userQuery);

    QueryBuilder<ParseObject> or3 =
    QueryBuilder<ParseObject>(ParseObject("Conversation"))
      ..whereEqualTo("accepted", false)
      ..whereMatchesKeyInQuery('user2', "objectId", userQuery);

    /**
     *  ..whereNotEqualTo("accepted", false)
        //  ..whereMatchesKeyInQuery('user1', "objectId", userQuery)
     */

    QueryBuilder<ParseObject> query =
    QueryBuilder.or(ParseObject("Conversation"), [or1, or2, or3])
      ..includeObject([
        'user1',
        'user2',
      ])
      ..setLimit(80)
      ..orderByDescending("lastTime")
      ..setAmountToSkip(0);

    final ParseResponse apiResponse = await query.query();
    if (apiResponse.success && apiResponse.results != null) {
      return ConversationResponse(
          responseCode: 200,
          message: "Success",
          conversations: apiResponse.results!
              .map((e) => Conversation.fromMap(e, id))
              .toList());
    } else {
      return ConversationResponse(
          responseCode: 0, message: "", conversations: []);
      ;
    }
  }

  Future<String> inseer_cconversation(Conversation cal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("id").toString();

    var insert_connv = ParseObject('Conversation')
      ..set('lastMessage', cal.lastMessage)
      ..set('lastTime', cal.lastTime!.millisecondsSinceEpoch)
      ..set(
          'user1', (ParseObject("_User")..objectId = cal.user1!.id).toPointer())
      ..set('user2',
          (ParseObject("_User")..objectId = cal.user2!.id).toPointer());

    ParseResponse a = await insert_connv.save();

    if (a.success == true) {
      return a.results![0]["objectId"];
    } else
      return "";
  }

  Future<Message> sendMessage(Message message) async {
    var insert_message;


      insert_message = ParseObject('Message')
        ..set('type', message.type)
        ..set('message', message.message)
        ..set('created', message.created.millisecondsSinceEpoch)
        ..set('show_message', [message.sender!.id, message.receiver!.id])
        ..set('sender',
            (ParseObject("_User")..objectId = message.sender!.id).toPointer())
        ..set('receiver',
            (ParseObject("_User")..objectId = message.receiver!.id).toPointer())
        ..set(
            'conversation',
            (ParseObject("Conversation")..objectId = message.conversation!.id)
                .toPointer());

    ParseResponse a = await insert_message.save();

    if (a.success == true) {
      return message;
    } else {
      return Message(created: DateTime.now().toUtc());
    }
  }

  Stream<List<Chat>> getChats() => chatProvider.getChats();

  Future<List<Message>> getMessages(
      Conversation conversation, User user_me) async {
    QueryBuilder<ParseObject> query;
    QueryBuilder<ParseObject> chatQuery =
    QueryBuilder<ParseObject>(ParseObject('Conversation'))
      ..whereEqualTo('objectId', conversation.id);

    query = QueryBuilder<ParseObject>(ParseObject("Message"))
      ..whereMatchesKeyInQuery("conversation", "objectId", chatQuery)
      ..includeObject([
        "sender",
        "receiver",
      ])
      ..whereEqualTo("show_message", user_me.id)
      ..setLimit(100);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      List<Message> listM =
      apiResponse.results!.map((e) => Message.fromMap(e, user_me)).toList();
      return listM.reversed.toList();
    } else {
      return [];
      ;
    }
  }

  /* Future<List<Message>> getPreviousMessages(
      Conversation conversation, UserData user_me, int skip) async {
    QueryBuilder<ParseObject> query;
    QueryBuilder<ParseObject> chatQuery =
        QueryBuilder<ParseObject>(ParseObject('Conversation'))
          ..whereEqualTo('objectId', conversation.id);

    query = QueryBuilder<ParseObject>(ParseObject("Message"))
      ..whereMatchesKeyInQuery("conversation", "objectId", chatQuery)
      // ..includeObject(["user"])
      ..setLimit(100);

    final ParseResponse apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null) {
      print(apiResponse.results);
      List<Message> listM =
          apiResponse.results!.map((e) => Message.fromMap(e, user_me)).toList();
      return listM;
    } else {
      return [];
      ;
    }
  }*/

  @override
  void dispose() {
    chatProvider.dispose();
  }
}
