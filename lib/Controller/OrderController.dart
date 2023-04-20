import 'dart:convert';

import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/OrderHistory.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class OrderController extends GetxController {
  var orders = <OrderHistory>[].obs;
  // var allOrders = <OrderHistory>[].obs;
  var allOrders = [].obs;
  var isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    getAllOrdersByUser();
  }

  Future getAllOrdersByUser() async {
    try {
      isLoading(true);
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int id = jsonDecode(iddata!);
      String url = '${serverUrl}getOrderDetailsbyuser/$id';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (Map i in body) {
          orders.add(OrderHistory.fromJson(i));
        }
        update();
        LogsController.printLog(
            OrderController, "INFO", "all orders fetched successful");
        return orders;
      } else {
        LogsController.printLog(OrderController, "ERROR",
            "failed ot fetch all Orders : ${response.body}");
        return orders;
      }
    } on Exception catch (e) {
      LogsController.printLog(
          OrderController, "ERROR", "error in get all orders : $e");
      e.printError();
    } finally {
      isLoading(false);
      Get.find<OrderController>().update();
    }
  }

  Future setOrderCancelled(int orderId) async {
    try {
      String url = '${serverUrl}setOrderCancelled/$orderId';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        LogsController.printLog(
            OrderController, "INFO", "order cancelled Successfully");
        return body;
      } else {
        LogsController.printLog(OrderController, "ERROR",
            "order cancel is failed : ${response.body}");
        return body;
      }
    } on Exception catch (e) {
      LogsController.printLog(
          OrderController, "ERROR", "exception in order cancel : $e");
      e.printError();
    }
  }

  Future getAllOrders() async {
    try {
      CommanDialog.showLoading();
      String url = '${serverUrl}getAllOrders';
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
        CommanDialog.hideLoading();
        update();
        return orders;
      } else {
        CommanDialog.hideLoading();
        return orders;
      }
    } on Exception catch (e) {
      e.printError();
    }
  }
}
