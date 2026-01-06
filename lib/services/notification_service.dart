import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      // Show local notification
      print('Message received: ${message.notification?.title}');
    });
  }
}
