import 'dart:convert';

import 'package:flutter_login_app/model/CategoryProduct.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoryProductcontroller extends GetxController {
  List<ProductByCategory> products = [];

  Future getDetails(id) async {
    onReady();
    print("fatchProduct $id");
    // var postData = {"productid": id};

    CommanDialog.showLoading();
    String url =
        'http://10.0.2.2:8082/api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&categoryId=${id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    // var records = jsonDecode(body['records']);
    CommanDialog.hideLoading();
    // print(records);

    if (response.statusCode == 200) {
      for (Map i in body['records']) {
        products.add(ProductByCategory.fromJson(i));
      }
      update();
      return products;
    } else {
      return products;
    }
  }
}
