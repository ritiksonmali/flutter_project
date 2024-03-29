import 'dart:convert';

import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/OrderWalletModel.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  var orderWallet = <OrderWalletModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    getAllOrdersByUserForWallet();
  }

  Future getAllOrdersByUserForWallet() async {
    try {
      CommanDialog.showLoading();
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int id = jsonDecode(iddata!);
      String url = '${serverUrl}getOrderDetailsForWallet/$id';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (Map i in body) {
          orderWallet.add(OrderWalletModel.fromJson(i));
        }
        CommanDialog.hideLoading();
        update();
        LogsController.printLog(
            WalletController, "INFO", "get wallet orders successful");
        return orderWallet;
      } else {
        LogsController.printLog(WalletController, "ERROR",
            "get wallet orders failed : ${response.body}");
        CommanDialog.hideLoading();
        return orderWallet;
      }
    } on Exception catch (e) {
      LogsController.printLog(
          WalletController, "ERROR", "error in get wallet orders : $e");
    }
  }
}
