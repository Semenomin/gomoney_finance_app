import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

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

  Future<void> fetchShedule() async {
    try {
      Response response = await dio!.post(
        '/group/confirmInvite',
        data: jsonEncode({
          "status": false,
          "from_id": "dwfwgwgwg-gwegweg",
          "from_name": "Anya",
          "group_id": "qefwegweg",
          "group_name": "Котики",
          "to": [
            "ddPngjfGTcuY12GnIyqQK0:APA91bH1TVF0oevzgi0xPqKn4SjTF6Btxsfws9EJMQF89oKPXXPjaHBSBfYZjFuPCgbU20WqMCKYd-rlok5LPoDcDYsc3Gd4IrN_UT5X0LcssNFgwVFLKvwgcqQ4l7B6J2sYU8VwS1J0"
          ],
          "data": {
            "MoneyBoxes": [
              {"id": "dqwdqwfqfqwf"}
            ]
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
