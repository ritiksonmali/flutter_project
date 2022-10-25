import 'dart:convert';

import 'package:flutter_login_app/model/Category.dart';
import 'package:flutter_login_app/model/CategoryProduct.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController {
  List<CategoryData> category = [];

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getCategoryApi();
  }

  Future getCategoryApi() async {
    String url = 'http://10.0.2.2:8082/api/auth/category';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      for (Map i in body) {
        category.add(CategoryData.fromJson(i));
      }
      return category;
    } else {
      return category;
    }
  }
}
