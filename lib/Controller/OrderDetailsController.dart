import 'dart:convert';

import 'package:flutter_login_app/model/SelectedOrder.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderDetailsController extends GetxController {
  var Selectedorder = <SelectedOrder>[].obs;
  // List<SelectedOrder> Selectedorder = [];

  Future getOrderDetails(orderId) async {
    CommanDialog.showLoading();
    String url = 'http://10.0.2.2:8082/getOrderDetailsbyid/${orderId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    CommanDialog.hideLoading();
    var body = jsonDecode(response.body);
    // print(body);
    if (response.statusCode == 200) {
      for (Map i in body['orderItem']) {
        Selectedorder.add(SelectedOrder.fromJson(i));
      }
      update();
      return Selectedorder;
    } else {
      return Selectedorder;
    }
  }
}
