// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class AddressController extends GetxController {
  // @override
  // void onReady() {
  //   super.onReady();
  //   getAddressApi();
  // }

  List address = [].obs;
  var isloading = true.obs;
  List countryCityStateData = [].obs;

  getAddressApi() async {
    try {
      isloading(true);
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int id = jsonDecode(iddata!);
      String url = '${serverUrl}api/auth/getaddressbyuser/$id';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        address = body;
        update();
        LogsController.printLog(
            AddressController, "INFO", "get addresses successful");
        return address;
      } else {
        LogsController.printLog(AddressController, "ERROR",
            "get addresses failed : ${response.body}");
        return address;
      }
    } catch (e) {
      LogsController.printLog(
          AddressController, "ERROR", "error in get  addresses : $e");
      e.printError();
    } finally {
      isloading(false);
    }
  }

  Future setAddressStatusInactive(int addressId) async {
    try {
      String url = '${serverUrl}api/auth/setAddressStatusInactive/$addressId';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        LogsController.printLog(
            AddressController, "INFO", "delete address success");
      } else {
        LogsController.printLog(AddressController, "ERROR",
            "delete address failed : ${response.body}");
      }
    } catch (e) {
      LogsController.printLog(
          AddressController, "ERROR", "error in delete address : $e");
      e.printError();
    }
  }

  getCountryCityState(String parent, String type) async {
    try {
      String url =
          '${serverUrl}api/auth/getCountryStateCity?parent=$parent&type=$type';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        countryCityStateData = body['results'];
        isloading = false.obs;
        update();
        LogsController.printLog(
            AddressController, "INFO", "get country state city success");
        return countryCityStateData;
      } else {
        LogsController.printLog(AddressController, "ERROR",
            "get country state city  failed : ${response.body}");
      }
    } catch (e) {
      LogsController.printLog(
          AddressController, "ERROR", "error in get country state city :$e");
      e.printError();
    }
  }
}
