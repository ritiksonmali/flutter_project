// import 'dart:convert';

// import 'package:flutter_login_app/model/OfferProduct.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class OfferProductController extends GetxController {
//   List<OfferProduct> offeredProduct = [];
//   var offerId = Get.arguments;
//   @override
//   void onReady() {
//     // TODO: implement onReady
//     super.onReady();
//     productofferApi(offerId['offerId']);
//   }

//   Future productofferApi(offerId) async {
//     var store = await SharedPreferences.getInstance();
//     var iddata = store.getString('id');
//     int user_id = jsonDecode(iddata!);
//     String url =
//         'http://158.85.243.11:8082/api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&offerId=${offerId}&userId=${user_id}';
//     http.Response response = await http.get(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//     );
//     var body = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       for (Map i in body['records']) {
//         offeredProduct.add(OfferProduct.fromJson(i));
//       }
//       update();
//       return offeredProduct;
//     } else {
//       return offeredProduct;
//     }
//   }
// }
