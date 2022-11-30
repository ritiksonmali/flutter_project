import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationController extends GetxController {
  Future sendNotificationData(String deviceToken, String deviceType) async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    String deviceTokenToSendPushNotification = token.toString();
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int userId = jsonDecode(iddata!);
    String url =
        'http://10.0.2.2:8082/api/auth/sendNotificationData?userId=${userId}&deviceToken=${deviceTokenToSendPushNotification}&deviceType=${deviceType}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
  }

  Future setNotifiedUserStatus() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    String deviceTokenToSendPushNotification = token.toString();
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    await Future.delayed(Duration(seconds: 2));
    String url =
        'http://10.0.2.2:8082/api/auth/setNotifiedUserStatus?userId=${user_id}&deviceToken=${deviceTokenToSendPushNotification}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    print(body);
  }
}
