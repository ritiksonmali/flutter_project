import 'dart:convert';

import 'package:flutter_login_app/model/Product.dart';
import 'package:flutter_login_app/model/ProductModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var productData = <ProductModel>[].obs;
  List QuantityResponse =[];
   // List<ProductModel> DemoProduct = [];

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
    getAllProducts();
  }

  List<Product> cartitem = List<Product>.empty().obs;

  double get totalPrice => cartitem.fold(0, (sum, item) => sum + item.price);
  int get count => cartitem.length;

  Future increasequantity(int userId, productId, String sum) async {
    String url =
        'http://10.0.2.2:8082/api/auth/addProductsInCart?userId=${userId}&productId=${productId}&sum=${sum}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      for (Map i in body['records']) {
       // QuantityResponse.add();
      }
      // print(body['records']);
      update();
      return productData;
    } else {
      return productData;
    }
    

    // print(response.body);
  }

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

   Future setPaymentDetails(String paymentId ,String paymentStatus,String orderId) async {
    
      String url = 'http://10.0.2.2:8082/setOrderPaymentStatus';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "orderId": orderId,
            "paymentId":paymentId,
            "paymentStatus":paymentStatus
          }));
            print("failed payment");
      if (response.statusCode == 200) {
        print("Success payment");
       print(response.body);
      } 
  }
  

  

    Future getAllProducts() async {
    String url =
        'http://10.0.2.2:8082/api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&userId=7';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
  
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in body['records']) {
        productData.add(ProductModel.fromJson(i));
      }
      // print(body['records']);
      update();
      return productData;
    } else {
      return productData;
    }
  }

  

 
}










