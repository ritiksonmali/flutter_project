// import 'dart:convert';

// import 'package:flutter_login_app/model/Address.dart';
// import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class AddressController extends GetxController {
//   List<Address> ad = [];

//   @override
//   void onReady() {
//     // TODO: implement onReady
//     super.onReady();
//     test();
//   }

//   void test() async {
//     var store = await SharedPreferences.getInstance(); //add when requried
//     var iddata = store.getString('id');
//     int id = jsonDecode(iddata!);
//     getAddressApi(id);
//   }

//   getAddressApi(int id) async {
//     CommanDialog.showLoading();
//     String url = 'http://10.0.2.2:8082/api/auth/getaddressbyuser/${id}';
//     http.Response response = await http.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//     );
//     var body = jsonDecode(response.body);
//     // print(body);
//     if (response.statusCode == 200) {
//       for (Map i in body) {
//         ad.add(Address.fromJson(i));
//       }
//       CommanDialog.hideLoading();
//       return ad;
//     } else {
//       return ad;
//     }
//   }

//   Future checkAddressIsSelected(int userId, addressId) async {
//     String url =
//         'http://10.0.2.2:8082/api/auth/updateaddressIsSelected/${addressId}/${userId}';
//     http.Response response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//     );
//     print(addressId);
//     print(userId);
//     print(response.body);
//   }
// }
