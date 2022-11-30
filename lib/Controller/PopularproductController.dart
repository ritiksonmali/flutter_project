import 'dart:convert';

import 'package:flutter_login_app/model/PopularProduct.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class PopularProductController extends GetxController {
  var popular = <PopularProduct>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getPopularProducts();
  }

  Future getPopularProducts() async {
    String url =
        serverUrl+'api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&ispopular=true';
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
      return popular;
    } else {
      return popular;
    }
  }
}
