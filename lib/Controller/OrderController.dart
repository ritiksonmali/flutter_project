import 'dart:convert';


import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/OrderHistory.dart';

class OrderController extends GetxController {
  var orders = <OrderHistory>[].obs;
  // List<SelectedOrder> Selectedorder = [];

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    test();
  }

  void test() async {
    CommanDialog.showLoading();
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    getAllOrdersByUser(id);
  }

  Future getAllOrdersByUser(int userId) async {
    String url = 'http://10.0.2.2:8082/getOrderDetailsbyuser/${userId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    CommanDialog.hideLoading();

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in body) {
        orders.add(OrderHistory.fromJson(i));
      }
      // print(body['orderItem']);

      update();
      return orders;
    } else {
      return orders;
    }
  }
}