import 'dart:io';
import 'package:sevenapplication/core/models/Chat.dart';
import 'package:sevenapplication/core/models/Conversation.dart';
import 'package:sevenapplication/core/models/Message.dart';
import 'package:sevenapplication/core/models/user.dart';


abstract class BaseProvider{
  void dispose();
}


abstract class BaseUserDataProvider extends BaseProvider{
  Future<void> addContact(String username);
  Future<User> getUser(String username);
  Future<String> getUidByUsername(String username);
  Future<void> updateProfilePicture(String profilePictureUrl);
}

abstract class BaseStorageProvider extends BaseProvider{
  Future<String> uploadFile(File file, String path);
}

abstract class BaseChatProvider extends BaseProvider{
  ChatProvider(){

  }
  Stream<List<Conversation>> getConversations();
  Stream<List<Message>> getMessages(String chatId);
  Future<List<Message>> getPreviousMessages(String chatId);
  Future<List<Message>> getAttachments(String chatId, int type);
  Stream<List<Chat>> getChats();
  Future<void> sendMessage(String chatId, Message message);
  Future<String> getChatIdByUsername(String username);
  Future<void> createChatIdForContact(User user);
}
abstract class BaseDeviceStorageProvider extends BaseProvider{
  Future<File> getThumbnail(String videoUrl);
}
