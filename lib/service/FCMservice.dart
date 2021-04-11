import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token;

  Future<FcmService> init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title.toString()} ${message.notification!.body.toString()}');
      }
    });
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    token = await _firebaseMessaging.getToken(
        vapidKey:
            "BG3NV2M4tqCTJ_j-5H1Po3Za8GM9MTh0pTmmU32JpKHs7BCO2Fz3uWIIeTB96riPHact_11dL9hqAfC1GY9L2Qk");
    print(token);
    return this;
  }
}
