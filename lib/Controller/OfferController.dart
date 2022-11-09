import 'dart:convert';

import 'package:flutter_login_app/model/Offer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OfferController extends GetxController {
  List<Offer> offer = [];

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAllOffersApi();
  }

  Future getAllOffersApi() async {
    String url = 'http://10.0.2.2:8082/api/auth/offers';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in body) {
        offer.add(Offer.fromJson(i));
      }
      update();
      return offer;
    } else {
      return offer;
    }
  }
}
