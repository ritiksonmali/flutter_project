import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/Category.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../ConstantUtil/globals.dart';

class CategoryController extends GetxController with WidgetsBindingObserver {
  var category = <CategoryData>[].obs;
  var isLoading = true.obs;
  late Map mapResponse;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getCategoryApi();
  // }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this); // remove the observer
  }

  Future getCategoryApi() async {
    try {
      category.clear();
      isLoading(true);
      String url = '${serverUrl}api/auth/category';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // catagoryList = jsonDecode(response.body);
        for (Map i in body) {
          category.add(CategoryData.fromJson(i));
        }
        update();
        await LogsController.printLog(
            CategoryController, "INFO", "category Fetched");
        return category;
      } else {
        await LogsController.printLog(
            CategoryController, "ERROR", response.body);
        return category;
      }
    } catch (e) {
      e.printError();
      await LogsController.printLog(CategoryController, "ERROR", e);
    } finally {
      isLoading(false);
      Get.find<CategoryController>().update();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getCategoryApi();
    }
  }
}
