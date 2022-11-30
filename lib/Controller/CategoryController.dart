import 'dart:convert';

import 'package:flutter_login_app/model/Category.dart';
import 'package:flutter_login_app/model/CategoryProduct.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController {
  List<CategoryData> category = [];
  List catagoryList = [];
  late Map mapResponse;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getCategoryApi();
  }

  Future getCategoryApi() async {
    String url = 'http://158.85.243.11:8082/api/auth/category';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      catagoryList= jsonDecode(response.body);
      print(catagoryList);
      for (Map i in body) {
        category.add(CategoryData.fromJson(i)); 
      }
      update();
      return category;
    } else {
      return category;
    }
  }
}
