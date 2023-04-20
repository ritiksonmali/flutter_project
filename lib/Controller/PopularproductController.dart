import 'dart:convert';

import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/PopularProduct.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class PopularProductController extends GetxController {
  var popular = <PopularProduct>[].obs;
  var isLoading = true.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getPopularProducts();
  // }

  Future getPopularProducts() async {
    try {
      popular.clear();
      isLoading(true);
      String url =
          '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&ispopular=true';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (Map i in body['records']) {
          popular.add(PopularProduct.fromJson(i));
        }
        update();
        await LogsController.printLog(
            PopularProductController, "INFO", "popular product Fetched");
        return popular;
      } else {
        await LogsController.printLog(
            PopularProductController, "ERROR", response.body);
        return popular;
      }
    } catch (e) {
      await LogsController.printLog(PopularProductController, "ERROR", e);
      e.printError();
    } finally {
      isLoading(false);
      Get.find<PopularProductController>().update();
    }
  }
}
