import 'dart:convert';

import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/model/OrderHistory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminController extends GetxController {
  var revenueAdrOrdersList = [].obs;
  // var upcomingOrders = <OrderHistory>[].obs;
  double revenue = 0.0;
  double adr = 0.0;
  int noOfOrders = 0;
  var perfomanceData = {};
  var isLoading = true.obs;

  Future getRevenueAdrOrders() async {
    try {
      isLoading(true);
      String url = '${serverUrl}api/auth/getReveneueAdrAndOrders';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        perfomanceData = body;
        update();
      } else {}
    } catch (e) {
      e.printError();
    } finally {
      isLoading(false);
      update();
    }
  }
}
