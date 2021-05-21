import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:hive/hive.dart';
import 'app.dart';
import 'locator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/FinTransaction.dart';
import 'model/Group.dart';
import 'model/Category.dart' as c;
import 'model/MoneyBox.dart';
import 'model/Partner.dart';
import 'model/User.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  await Hive.initFlutter();
  await Hive.openBox('myScan');
  setupLocator();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  setupLocator();
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
    c.Category? cat;
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
}
