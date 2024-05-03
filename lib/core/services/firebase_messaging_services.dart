import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    await updateFCMTokenInParse(token!);

    await _firebaseMessaging.subscribeToTopic('Mission');

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      updateFCMTokenInParse(newToken);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: ${message.notification?.body}');
      // Handle incoming message while the app is in the foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: ${message.notification?.body}');
      // Handle app launch from a terminated or background state
    });
  }

  static Future<void> updateFCMTokenInParse(String token) async {
    try {
      final ParseUser currentUser = await ParseUser.currentUser();
      if (currentUser != null) {
        // User is authenticated, proceed with updating FCM token
        currentUser.set<String>('fcmToken', token);
        final response = await currentUser.update();
        if (response.success) {
          print('FCM token updated in Parse');
        } else {
          print('Failed to update FCM token in Parse: ${response.error!
              .message}');
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error while updating FCM token: $e');
    }
  }

}
