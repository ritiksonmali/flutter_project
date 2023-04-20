import 'dart:convert';

import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApplicationParameterController extends GetxController {
  var isLoading = true.obs;
  late Map mapResponse;
  static var isOrdersEnable = false.obs;
  Future checkIsEnabledOrders() async {
    try {
      isLoading(true);
      String dropdownName = "ENABLE_DISABLE_ORDERS";
      String code = "IS_ORDERS_ACCEPT";
      String url =
          '${serverUrl}api/auth/fetchDropDown?dropdownName=$dropdownName&param=$code';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isOrdersEnable(body[0]['orderAccept']);
        update();
      } else {}
    } catch (e) {
      e.printError();
    }
  }
}
