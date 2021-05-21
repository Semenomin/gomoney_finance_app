import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/User.dart';

class ConnectionService {
  Dio? dio;

  ConnectionService() {
    dio = Dio();
    dio!.options
      ..baseUrl = "http://dea045fc18c4.ngrok.io"
      ..connectTimeout = 15000
      ..contentType = Headers.jsonContentType
      ..receiveTimeout = 15000;
    // (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   SecurityContext sc = SecurityContext();
    //   sc.setTrustedCertificatesBytes(serverGoMoney);
    //   HttpClient httpClient = HttpClient(context: sc);
    //   return httpClient;
    // };
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
          "data": {"User": user.toMap()}
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
