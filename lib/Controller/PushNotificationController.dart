import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/globals.dart';

class PushNotificationController extends GetxController {
  Future sendNotificationData(String deviceToken, String deviceType) async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int userId = jsonDecode(iddata!);
    String url =
        serverUrl+'api/auth/sendNotificationData?userId=${userId}&deviceToken=${deviceToken}&deviceType=${deviceType}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
  }
}
