import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/Pages/Subscribe/SubscribeProductDetails.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubscribeProductController extends GetxController {
  late Map mapResponse;
  List subscribeProdutList = [].obs;
  var argument = Get.arguments;
  List responseList = [].obs;
  bool isAmountLow = false;
  double amountNeedToAdd = 0;
  List subscribeProductDetailsList = [].obs;
  var isloading = true.obs;

  @override
  void onReady() {
    super.onReady();
    // getProductByIdandUserId(argument['proId']);
  }

  Future getProductByIdandUserId(String productId) async {
    try {
      subscribeProdutList.clear();
      isloading(true);
      var store = await SharedPreferences.getInstance();
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String url =
          '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&productId=$productId&userId=$userId';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        mapResponse = jsonDecode(response.body);
        subscribeProdutList = mapResponse['records'];
        update();
        await LogsController.printLog(SubscribeProductController, "INFO",
            "get subscribed product success");
        return subscribeProdutList;
      } else {
        await LogsController.printLog(SubscribeProductController, "ERROR",
            "get subscribed product failed : ${response.body}");
        return subscribeProdutList;
      }
    } on Exception catch (e) {
      await LogsController.printLog(SubscribeProductController, "ERROR",
          " error in get subscribed product : $e");
    } finally {
      isloading(false);
      Get.find<SubscribeProductController>().update();
    }
  }

  Future subscribeProduct(
      String startDate,
      String? endDate,
      String time,
      int frequeny,
      int quantity,
      String addressId,
      String productId,
      String userId) async {
    try {
      String url = '${serverUrl}api/auth/subscribeProduct';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'startDate': startDate,
            'endDate': endDate,
            'time': time,
            'frequency': frequeny,
            'quantity': quantity,
            'status': "active",
            'addressId': addressId,
            'productId': productId,
            'userId': userId
          }));

      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isAmountLow = body['isAmountLow'];
        if (body['isAmountLow'] == true) {
          showAlertMessage("Warning", body['message'], body['amountNeedToAdd']);
        } else {
          Get.to(() => const SubscribeProductDetails());
          Fluttertoast.showToast(
              msg: body['message'],
              fontSize: 14,
              backgroundColor: black,
              textColor: white);
        }
        update();
        await LogsController.printLog(SubscribeProductController, "INFO",
            "subscribe product successfully");
      } else {
        await LogsController.printLog(SubscribeProductController, "ERROR",
            "subscribe product failed : ${response.body}");
        print("failed");
      }
    } catch (e) {
      await LogsController.printLog(SubscribeProductController, "ERROR",
          "error in subscribe product : $e");
      e.printError();
    }
  }

  Future showAlertMessage(String title, String content, double amountNeeded) {
    return Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(color: kAlertColor),
      content: Center(child: Text(content)),
      actions: <Widget>[
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: buttonColour,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: const Text(
            "Add Money",
            style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: white),
          ),
          onPressed: () {
            Get.to(() => const WalletScreen(),
                arguments: {"amountNeeded": amountNeeded});
          },
        ),
      ],
    );
  }

  getSubscribeProductDetails() async {
    try {
      var store = await SharedPreferences.getInstance();
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String url = '${serverUrl}api/auth/getSubscribeProductDetails/$userId';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      isloading = false.obs;
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        subscribeProductDetailsList = body;
        update();
        await LogsController.printLog(SubscribeProductController, "INFO",
            "get subscribed product list success");
        return subscribeProductDetailsList;
      } else {
        await LogsController.printLog(SubscribeProductController, "ERROR",
            "get subscribed product list failed : ${response.body}");
        return subscribeProductDetailsList;
      }
    } on Exception catch (e) {
      await LogsController.printLog(SubscribeProductController, "ERROR",
          "error in get subscribed product list : $e");
    }
  }

  updateSubscribeProductStatus(String id) async {
    String url = '${serverUrl}api/auth/updateSubscriptionStatus/$id';
    http.Response response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
    } else {}
  }

  Future updateSubscription(String id, String startDate, String? endDate,
      String time, int frequeny, int quantity) async {
    try {
      String url = '${serverUrl}api/auth/updateSubscription';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "id": id,
            'startDate': startDate,
            'endDate': endDate,
            'frequency': frequeny,
            'quantity': quantity,
            'time': time,
          }));

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        update();
        LogsController.printLog(
            SubscribeProductController, "INFO", "update subscription success");
      } else {
        LogsController.printLog(SubscribeProductController, "ERROR",
            "update subscription failed : ${response.body}");
      }
    } catch (e) {
      LogsController.printLog(SubscribeProductController, "ERROR",
          "error in update subscription : $e");
      e.printError();
    }
  }
}
