import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/MoneyBox.dart';
import 'package:gomoney_finance_app/model/Partner.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token;
  InitializationSettings? initializationSettings;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<FcmService> init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotification(
          message.notification!.title!, message.notification!.body!);
      if (message.data["type"] == "confirmInvite") {
        GetIt.I<SqliteService>()
            .addUser(User.fromMap(jsonDecode(message.data["user"])));
        GetIt.I<SqliteService>().addGroupUsers(
            Group.fromMap(jsonDecode(message.data["group"])),
            [User.fromMap(jsonDecode(message.data["user"]))]);
      } else if (message.data["type"] == "sendOperation") {
        FinTransaction transaction =
            FinTransaction.fromMap(jsonDecode(message.data["transaction"]));
        MoneyBox? box;
        Category? cat;
        Partner? partner;
        if (transaction.categoryId != null) {
          cat = (await GetIt.I<SqliteService>()
                  .getCategoriesByIds([transaction.categoryId!]))
              .first;
        }
        if (transaction.moneyBoxId != null) {
          box = (await GetIt.I<SqliteService>()
                  .getMoneyBoxesByIds([transaction.moneyBoxId!]))
              .first;
        }
        if (transaction.partnerId != null) {
          partner = (await GetIt.I<SqliteService>()
                  .getPartnersByIds([transaction.partnerId!]))
              .first;
        }
        GetIt.I<SqliteService>().addTransaction(transaction,
            category: cat, moneyBox: box, partner: partner, isPush: true);
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
    initNotification();
    return this;
  }

  void initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings!,
    );
  }

  Future<void> showNotification(String title, String body) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'fcm_default_channel',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      styleInformation: BigTextStyleInformation(''),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        100, title, body, platformChannelSpecifics);
  }
}
