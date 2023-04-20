import 'dart:convert';

import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/Offer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../ConstantUtil/globals.dart';

class OfferController extends GetxController {
  List<Offer> offer = <Offer>[].obs;
  var isLoading = true.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   getAllOffersApi();
  // }

  Future getAllOffersApi() async {
    try {
      isLoading(true);
      String url = '${serverUrl}api/auth/offers';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);
      offer.clear();
      if (response.statusCode == 200) {
        for (Map i in body) {
          offer.add(Offer.fromJson(i));
        }
        update();
        await LogsController.printLog(
            OfferController, "INFO", "all offer fetched successful");
        return offer;
      } else {
        await LogsController.printLog(OfferController, "ERROR", response.body);
        return offer;
      }
    } catch (e) {
      await LogsController.printLog(OfferController, "ERROR", e);
    } finally {
      isLoading(false);
      Get.find<OfferController>().update();
    }
  }
}
