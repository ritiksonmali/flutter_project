import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/OrderHistory.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class OrderController extends GetxController {
  var orders = <OrderHistory>[].obs;
  ScrollController scrollController = ScrollController();
  // var allOrders = [].obs;
  var isLoading = true.obs;
  var isOrderUpdated = false.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getAllOrdersByUser();
  // }

  Future getAllOrdersByUser() async {
    try {
      orders.clear();
      isLoading(true);
      // isFetching(true);
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int id = jsonDecode(iddata!);
      String url =
          '${serverUrl}fetchOrderListfilter?pagenum=0&pagesize=5&userId=$id';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (Map i in body['records']) {
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
      // isFetching(false);
      isLoading(false);
      Get.find<OrderController>().update();
    }
  }

  // loadMore() {
  //   if (!isFetching.value) {
  //     page.value++;
  //     getAllOrdersByUser();
  //   }
  // }

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

  // Future getAllOrders() async {
  //   try {
  //     orders.clear();
  //     CommanDialog.showLoading();
  //     String url = '${serverUrl}getAllOrders';
  //     http.Response response = await http.get(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     CommanDialog.hideLoading();
  //     var body = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       for (Map i in body) {
  //         orders.add(OrderHistory.fromJson(i));
  //       }
  //       CommanDialog.hideLoading();
  //       update();
  //       return orders;
  //     } else {
  //       CommanDialog.hideLoading();
  //       return orders;
  //     }
  //   } on Exception catch (e) {
  //     e.printError();
  //   }
  // }

  Future getAllOrders() async {
    try {
      orders.clear();
      isLoading(true);
      String url =
          '${serverUrl}fetchOrderListfilter?pagenum=0&pagesize=5&orderStatus=INPROGRESS&sorting=dateTime&isDesc=true';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      update();
      if (response.statusCode == 200) {
        print(body['records']);
        for (Map i in body['records']) {
          orders.add(OrderHistory.fromJson(i));
        }
        update();
        return orders;
      } else {
        return orders;
      }
    } catch (e) {
      e.printError();
    } finally {
      isLoading(false);
      update();
    }
  }

  Future uploadOrderImageAndSetOrderDelivered(
      int orderId, File imageFile) async {
    try {
      CommanDialog.showLoading();
      String url = '${serverUrl}addImageAndSetOrderDelivered/$orderId';
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.files.add(http.MultipartFile(
          'image',
          File(imageFile.path).readAsBytes().asStream(),
          File(imageFile.path).lengthSync(),
          filename: imageFile.path.split("/").last));
      var res = await request.send();
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      e.printError();
      return false;
    } finally {
      CommanDialog.hideLoading();
    }
  }

  // Future getUpcomingOrders() async {
  //   try {
  //     orders.clear();
  //     isLoading(true);
  //     String url =
  //         '${serverUrl}fetchOrderListfilter?pagenum=0&pagesize=20&orderStatus=INPROGRESS&sorting=dateTime&isDesc=true';
  //     http.Response response = await http.get(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     var body = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       for (Map i in body['records']) {
  //         orders.add(OrderHistory.fromJson(i));
  //       }
  //       update();
  //       return orders;
  //     } else {
  //       return orders;
  //     }
  //   } on Exception catch (e) {
  //     e.printError();
  //   } finally {
  //     isLoading(false);
  //     update();
  //   }
  // }

  Future getAllOrdersByStatus(String status) async {
    try {
      orders.clear();
      isLoading(true);
      String url =
          '${serverUrl}fetchOrderListfilter?pagenum=0&pagesize=5&orderStatus=$status&sorting=dateTime&isDesc=true';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (Map i in body['records']) {
          orders.add(OrderHistory.fromJson(i));
        }
        update();
        return orders;
      } else {
        return orders;
      }
    } on Exception catch (e) {
      e.printError();
    } finally {
      isLoading(false);
      update();
    }
  }

  Future updateOrderStatus(int orderId, String status) async {
    try {
      orders.clear();
      isLoading(true);
      String url =
          '${serverUrl}updateOrderStatus?orderId=$orderId&status=$status';
      http.Response response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        isOrderUpdated(true);
        // print(response.body);
        // getAllOrdersByStatus("DELIVERED");
        Fluttertoast.showToast(
            msg: "Order Updated Successfully", backgroundColor: buttonColour);
        update();
        return isOrderUpdated.value;
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Update Order please retry",
            backgroundColor: buttonCancelColour);
        isOrderUpdated(false);
        update();
        return isOrderUpdated.value;
      }
    } on Exception catch (e) {
      isOrderUpdated(false);
      e.printError();
      return isOrderUpdated.value;
    } finally {
      isLoading(false);
      update();
    }
  }
}
