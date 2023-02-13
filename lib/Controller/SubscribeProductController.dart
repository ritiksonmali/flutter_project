import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Pages/Subscribe/SubscribeProductDetails.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
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
    // TODO: implement onReady
    super.onReady();
    // getProductByIdandUserId(argument['proId']);
  }

  Future getProductByIdandUserId(String productId) async {
    subscribeProdutList.clear();
    CommanDialog.showLoading();
    print('called');
    var store = await SharedPreferences.getInstance();
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    String url = serverUrl +
        'api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&productId=${productId}&userId=${user_id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    CommanDialog.hideLoading();
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mapResponse = jsonDecode(response.body);
      subscribeProdutList = mapResponse['records'];
      print("**********api called for subscribe********");
      update();
      return subscribeProdutList;
    } else {
      return subscribeProdutList;
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
      print(endDate);
      String url = serverUrl + 'api/auth/subscribeProduct';
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
      print(body);
      if (response.statusCode == 200) {
        isAmountLow = body['isAmountLow'];
        if (body['isAmountLow'] == true) {
          showAlertMessage("Warning", body['message'], body['amountNeedToAdd']);
        } else {
          Get.to(() => SubscribeProductDetails());
          Fluttertoast.showToast(
              msg: body['message'],
              fontSize: 14,
              backgroundColor: Colors.black,
              textColor: white);
        }
        print(body['isAmountLow']);
        print(body['amountNeedToAdd']);
        update();
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future showAlertMessage(String title, String content, double amountNeeded) {
    return Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(color: Colors.redAccent),
      content: Text(content),
      // 'You need to add \₹ ${amountNeeded}  in Your wallet for complete this subscription'),
      actions: <Widget>[
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            "Add Money",
            style: TextStyle(
                fontSize: 14, letterSpacing: 2.2, color: Colors.white),
          ),
          onPressed: () {
            // Navigator.of(ctx).pop();
            Get.to(() => WalletScreen(),
                arguments: {"amountNeeded": amountNeeded});
          },
        ),
      ],
    );
  }

  getSubscribeProductDetails() async {
    var store = await SharedPreferences.getInstance();
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    String url = serverUrl + 'api/auth/getSubscribeProductDetails/${user_id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    isloading = false.obs;
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      subscribeProductDetailsList = body;
      print("**********api called for product details********");
      update();
      return subscribeProductDetailsList;
    } else {
      return subscribeProductDetailsList;
    }
  }

  updateSubscribeProductStatus(String id) async {
    String url = serverUrl + 'api/auth/updateSubscriptionStatus/${id}';
    http.Response response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(body);
    } else {}
  }

  Future updateSubscription(String id, String startDate, String? endDate,
      String time, int frequeny, int quantity) async {
    print('Called');
    try {
      // print(endDate);
      print(id);
      print(startDate);
      print(endDate);
      print(frequeny);
      print(quantity);
      String url = serverUrl + 'api/auth/updateSubscription';
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
        print(body);
        update();
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
