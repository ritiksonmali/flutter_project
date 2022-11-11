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
  // var Selectedorder = <SelectedOrder>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAllOrdersByUser();
  }

  // Future<void> test() async {
  //   CommanDialog.showLoading();
  //   var store = await SharedPreferences.getInstance(); //add when requried
  //   var iddata = store.getString('id');
  //   int id = jsonDecode(iddata!);
  //   getAllOrdersByUser(id);
  // }

  Future getAllOrdersByUser() async {
    CommanDialog.showLoading();
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    String url = 'http://10.0.2.2:8082/getOrderDetailsbyuser/${id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in body) {
        orders.add(OrderHistory.fromJson(i));
      }
      CommanDialog.hideLoading();
      update();
      return orders;
    } else {
      CommanDialog.hideLoading();
      return orders;
    }
  }

  Future setOrderCancelled(int orderId) async {
    String url = 'http://10.0.2.2:8082/setOrderCancelled/${orderId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    return body;
  }
}
