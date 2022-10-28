import 'dart:convert';

import 'package:flutter_login_app/model/OfferProduct.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OfferProductController extends GetxController {
  List<OfferProduct> offeredProduct = [];

  Future productofferApi(offerId) async {
    String url = 'http://10.0.2.2:8082/api/auth/getproductbyoffer/${offerId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    print(body['products']);
    if (response.statusCode == 200) {
      for (Map i in body['products']) {
        offeredProduct.add(OfferProduct.fromJson(i));
      }
      update();
      return offeredProduct;
    } else {
      return offeredProduct;
    }
  }
}
