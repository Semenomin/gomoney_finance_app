import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:gomoney_finance_app/model/index.dart';

import '../serverGoMoney.dart';
import 'SqliteService.dart';

class ConnectionService {
  Dio? dio;

  ConnectionService() {
    dio = Dio();
    dio!.options
      ..baseUrl = "http://de76902fe2be.ngrok.io"
      ..connectTimeout = 15000
      ..contentType = Headers.jsonContentType
      ..receiveTimeout = 15000;
    (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      SecurityContext sc = SecurityContext();
      sc.setTrustedCertificatesBytes(serverGoMoney);
      HttpClient httpClient = HttpClient(context: sc);
      return httpClient;
    };
  }

  Future<void> confirmInvite(
      Group group, List<String> pushes, User user) async {
    try {
      Response response = await dio!.post(
        '/group/confirmInvite',
        data: jsonEncode({
          "status": true,
          "from_id": user.id,
          "from_name": user.name,
          "group_id": group.id,
          "group_name": group.name,
          "to": pushes,
          "data": {
            "type": "confirmInvite",
            "user": user.toMap(),
            "group": group.toMap()
          }
        }),
        options: Options(contentType: Headers.jsonContentType),
      );
      print(response);
    } catch (e) {
      BotToast.showText(text: "Отсутствует соединение с сервером");
      return null;
    }
  }

  Future<void> sendOperation(Group group, FinTransaction transaction) async {
    User user = await GetIt.I<SqliteService>().getUser();
    List<String> pushes = await GetIt.I<SqliteService>().getGroupPushes(group);
    pushes.remove(user.pushId);
    String name = '';
    String type = '';
    if (transaction.categoryId != null) {
      name = (await GetIt.I<SqliteService>()
              .getCategoriesByIds([transaction.categoryId!]))
          .first
          .name;
      type = "Category";
    }

    if (transaction.moneyBoxId != null) {
      name = (await GetIt.I<SqliteService>()
              .getMoneyBoxesByIds([transaction.moneyBoxId!]))
          .first
          .name;
      type = "MoneyBox";
    }
    if (transaction.partnerId != null) {
      name = (await GetIt.I<SqliteService>()
              .getPartnersByIds([transaction.partnerId!]))
          .first
          .name;
      type = "Partner";
    }
    try {
      Response response = await dio!.post(
        '/group/sendOperation',
        data: jsonEncode({
          "status": true,
          "from_id": user.id,
          "from_name": user.name,
          "group_id": group.id,
          "group_name": group.name,
          "to": pushes,
          "data": {
            "type": "sendOperation",
            "operation": {
              "type": type,
              "operation": "create transaction",
              "name": name,
            },
            "transaction": transaction.toMap()
          }
        }),
        options: Options(contentType: Headers.jsonContentType),
      );
      print(response);
    } catch (e) {
      BotToast.showText(text: "Отсутствует соединение с сервером");
      return null;
    }
  }
}
