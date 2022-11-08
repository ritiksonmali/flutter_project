import 'dart:convert';

import 'package:flutter_login_app/model/OrderHistory.dart';
import 'package:flutter_login_app/model/SelectedOrder.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  var orders = <OrderHistory>[].obs;
  // List<SelectedOrder> Selectedorder = [];
  var Selectedorder = <SelectedOrder>[].obs;

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

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in body) {
        orders.add(OrderHistory.fromJson(i));
      }
      // print(body['orderItem']);
      CommanDialog.hideLoading();
      update();
      return orders;
    } else {
      CommanDialog.hideLoading();
      return orders;
    }
  }

  Future getOrderDetails(int orderId) async {
    String url = 'http://10.0.2.2:8082/getOrderDetailsbyid/${orderId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in body['orderItem']) {
        Selectedorder.add(SelectedOrder.fromJson(i));
      }
      // print(body['orderItem']);
      update();
      return Selectedorder;
    } else {
      return Selectedorder;
    }
  }
}
