import 'dart:convert';
import 'package:flutter_login_app/model/CartData.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    test();
  }

  int? id;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    getCartproducts(id);
  }

  List<CartProductData> cartproducts = [];

  // List<Product> cartitem = [];

  // addtoCart(int userId, Product product) async {
  //   String url = 'http://10.0.2.2:8082/api/auth/addToCart/${userId}';
  //   http.Response response = await http.post(Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({"product_id": product.id, "quantity": 1}));

  //   var body = jsonDecode(response.body);

  //   var store = await SharedPreferences.getInstance();
  //   if (response.statusCode == 200) {
  //     cartitem.add(product);
  //      print("Product Added in cart");
  //   }

  // }

  Future getCartproducts(userId) async {
    print("fatchProduct $userId");
    // var postData = {"productid": id};

    CommanDialog.showLoading();
    String url = 'http://10.0.2.2:8082/api/auth/getcartitems/${userId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    CommanDialog.hideLoading();
    print(body);
    if (response.statusCode == 200) {
      for (Map i in body['cartItems']) {
        cartproducts.add(CartProductData.fromJson(i));
      }
      return cartproducts;
    } else {
      return cartproducts;
    }
  }
}
