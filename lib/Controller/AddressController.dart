import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class AddressController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAddressApi();
  }

  List address = [].obs;

  getAddressApi() async {
    try {
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int id = jsonDecode(iddata!);
      String url = serverUrl+'api/auth/getaddressbyuser/${id}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      address = body;
      print(body);
      update();
      return address;
    } catch (e) {
      print(e.toString());
    }
  }

  Future setAddressStatusInactive(int addressId) async {
    print('addressid :${addressId}');
    String url =
        serverUrl+'api/auth/setAddressStatusInactive/${addressId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
  }
}
