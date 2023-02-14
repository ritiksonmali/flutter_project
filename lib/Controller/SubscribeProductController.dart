import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
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

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getProductByIdandUserId(argument['proId']);
  }

  Future getProductByIdandUserId(String productId) async {
    subscribeProdutList.clear();
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

      if (response.statusCode == 200) {
        isAmountLow = body['isAmountLow'];
        if (body['isAmountLow'] == true) {
          showAlertMessage(body['amountNeedToAdd']);
        } else {
          Fluttertoast.showToast(
              msg: 'Subscribe Product Successfully',
              fontSize: 18,
              backgroundColor: Colors.green,
              textColor: white);
        }
        // amountNeedToAdd = body['amountNeedToAdd'];
        // showAlertMessage(amountNeedToAdd);
        print(body['isAmountLow']);
        print(body['amountNeedToAdd']);
        update();
        // Fluttertoast.showToast(
        //     msg: 'Subscribe Product Successfully',
        //     fontSize: 18,
        //     backgroundColor: Colors.green,
        //     textColor: white);
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future showAlertMessage(double amountNeeded) {
    return Get.defaultDialog(
      title: "Your Wallet Amount is Low",
      titleStyle: TextStyle(color: Colors.redAccent),
      content: Text(
          'You need to add more \₹ ${amountNeeded}  in Your wallet for add this subscription'),
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
}
