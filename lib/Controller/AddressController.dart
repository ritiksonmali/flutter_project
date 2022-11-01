import 'dart:convert';

import 'package:flutter_login_app/model/Address.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  List address = [];

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    test();
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    getAddressApi(id);
  }

  getAddressApi(int id) async {
    try {
      String url = 'http://10.0.2.2:8082/api/auth/getaddressbyuser/${id}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      print(body);
      if (response.statusCode == 200) {
        for (Map i in body) {
          address.add(Address.fromJson(i));
        }
        return address;
      } else {
        return address;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
