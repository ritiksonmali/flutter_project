import 'dart:convert';
import 'dart:io';

import 'package:flutter_login_app/model/AllOrdersDeliveryManager.dart';
import 'package:flutter_login_app/model/OrderHistory.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AllOrdersForDeliveryManager extends GetxController {
  var allOrders = <AllOrdersDeliveryManager>[].obs;
  bool uploaded = false;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAllOrders();
  }

  Future getAllOrders() async {
    CommanDialog.showLoading();
    String url = 'http://10.0.2.2:8082/getAllOrders';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    CommanDialog.hideLoading();
    var body = jsonDecode(response.body);
    update();
    print(body);

    if (response.statusCode == 200) {
      for (Map i in body) {
        allOrders.add(AllOrdersDeliveryManager.fromJson(i));
      }

      return allOrders;
    } else {
      return allOrders;
    }
  }

  Future uploadImage(int orderId, File imageFile) async {
    String url = 'http://10.0.2.2:8082/addImageForPerOrder/${orderId}';
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(http.MultipartFile(
        'image',
        File(imageFile.path).readAsBytes().asStream(),
        File(imageFile.path).lengthSync(),
        filename: imageFile.path.split("/").last));
    var res = await request.send();

    if (res.statusCode == 200) {
      uploaded = true;
      print(res);
      print("image uploaded");
    } else {
      print("uploaded faild");
    }
  }

  Future setOrderDelivered(int orderId) async {
    String url = 'http://10.0.2.2:8082/setOrderDeliveted/${orderId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    print(body);
    return body;
  }
}
