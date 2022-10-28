import 'dart:convert';

import 'package:flutter_login_app/model/Product.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  List<Product> productData = [];

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getAllProducts();
  }

  List<Product> cartitem = List<Product>.empty().obs;

  double get totalPrice => cartitem.fold(0, (sum, item) => sum + item.price);
  int get count => cartitem.length;

  addtoCart(int userId, Product product) async {
    print(product.id);
    String url = 'http://10.0.2.2:8082/api/auth/addToCart/${userId}';
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"product_id": product.id, "quantity": 1}));

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      cartitem.add(product);
      print("Product Added in cart");
    }
  }

  Future getAllProducts() async {
    String url =
        'http://10.0.2.2:8082/api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      for (Map i in body['records']) {
        productData.add(Product.fromJson(i));
      }
      return productData;
    } else {
      return productData;
    }
  }
}
