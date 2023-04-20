// ignore_for_file: control_flow_in_finally

import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/model/AllOrdersDeliveryManager.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AllOrdersForDeliveryManager extends GetxController {
  var allOrders = <AllOrdersDeliveryManager>[].obs;
  bool uploaded = false;

  @override
  void onReady() {
    super.onReady();
    getAllOrders();
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
      update();
      if (response.statusCode == 200) {
        for (Map i in body) {
          allOrders.add(AllOrdersDeliveryManager.fromJson(i));
        }
        return allOrders;
      } else {
        return allOrders;
      }
    } catch (e) {
      e.printError();
    }
  }

  Future uploadImage(int orderId, File imageFile) async {
    try {
      String url = '${serverUrl}addImageForPerOrder/$orderId';
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.files.add(http.MultipartFile(
          'image',
          File(imageFile.path).readAsBytes().asStream(),
          File(imageFile.path).lengthSync(),
          filename: imageFile.path.split("/").last));
      var res = await request.send();
      if (res.statusCode == 200) {
        // uploaded = true;
        bool isdelivered = await setOrderDelivered(orderId);
        if (isdelivered == true) {
          return true;
        } else {
          false;
        }
      } else {
        return false;
      }
      return false;
    } catch (e) {
      e.printError();
    }
  }

  Future<bool> setOrderDelivered(int orderId) async {
    try {
      String url = '${serverUrl}setOrderDeliveted/$orderId';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (body['orderStatus'] == 'DELIVERED') {
          sendNotificationtoUser(orderId);
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      e.printError();
      return false;
    }
  }
}

Future sendNotificationtoUser(int orderId) async {
  try {
    String url =
        '${serverUrl}api/auth/sendNotificationToDeliveredOrder?orderId=$orderId';
    // ignore: unused_local_variable
    http.Response response1 = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    e.printError();
  }
}
