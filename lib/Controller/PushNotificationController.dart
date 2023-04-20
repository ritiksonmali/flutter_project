import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/globals.dart';

class PushNotificationController extends GetxController {
  Future sendNotificationData(String deviceToken, String deviceType) async {
    try {
      final FirebaseMessaging _fcm = FirebaseMessaging.instance;
      final token = await _fcm.getToken();
      String deviceTokenToSendPushNotification = token.toString();
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String url =
          '${serverUrl}api/auth/sendNotificationData?userId=$userId&deviceToken=$deviceTokenToSendPushNotification&deviceType=$deviceType';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        await LogsController.printLog(PushNotificationController, "INFO",
            "notification data sent success");
      } else {
        await LogsController.printLog(PushNotificationController, "ERROR",
            " send notification data failed : ${response.body}");
      }
    } catch (e) {
      await LogsController.printLog(PushNotificationController, "ERROR",
          " error in send notification data : $e");
      e.printError();
    }
  }

  Future setNotifiedUserStatus() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    String deviceTokenToSendPushNotification = token.toString();
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int userId = jsonDecode(iddata!);
    await Future.delayed(const Duration(seconds: 2));
    String url =
        '${serverUrl}api/auth/setNotifiedUserStatus?userId=$userId&deviceToken=$deviceTokenToSendPushNotification';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    print(body);
  }
}
