import 'dart:convert';
import 'package:flutter_login_app/ConstantUtil/globals.dart' as globals;
import 'package:flutter_login_app/model/Product.dart';
import 'package:flutter_login_app/model/ProductModel.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/globals.dart';

class ProductController extends GetxController {
  var productData = <ProductModel>[];
  List QuantityResponse = [];
  String stringResponse = '';
  List productsearchResponseList = [];
  List productResponseList = [].obs;
  List productFilterResponseList = [];
  // List productResponseList = [];
  late Map mapResponse;
  int count = 0;
  // List<ProductModel> DemoProduct = [];{}
  main() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    globals.currentUserId = jsonDecode(iddata!);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // test();
    getCount();
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    getAllProducts();
  }

  List<Product> cartitem = List<Product>.empty().obs;

  // double get totalPrice => cartitem.fold(0, (sum, item) => sum + item.price);
  // int get count => cartitem.length;

  Future increasequantity(int userId, productId, String sum) async {
    String url =
        serverUrl+'api/auth/addProductsInCart?userId=${userId}&productId=${productId}&sum=${sum}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    // var body = jsonDecode(response.body);

    // if (response.statusCode == 200) {
    //   for (Map i in body) {
    //     // QuantityResponse.add();
    //   }
    //   // print(body['records']);
    //   update();
    //   return productData;
    // } else {
    //   return productData;
    // }

    // print(response.body);
  }

  addtoCart(int userId, Product product) async {
    print(product.id);
    String url = serverUrl+'api/auth/addToCart/${userId}';
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"product_id": product.id, "quantity": 1}));

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      cartitem.add(product);
      print("Product Added in cart");
    }
  }

  Future setPaymentDetails(
      String paymentId, String paymentStatus, String orderId) async {
    String url = serverUrl+'setOrderPaymentStatus';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "orderId": orderId,
          "paymentId": paymentId,
          "paymentStatus": paymentStatus
        }));
    if (response.statusCode == 200) {
      print("Success payment");
      print(response.body);
    }
  }

  Future getAllProducts() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    // int user_id=globals.currentUserId;
    String url =
        serverUrl+'api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&userId=${user_id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      stringResponse = response.body;
      mapResponse = jsonDecode(response.body);
      productResponseList = mapResponse['records'];
      print("refresh********* done");
      // for (Map i in body['records']) {
      //   productData.add(ProductModel.fromJson(i));
      //    print("refresh for loop");
      // }
      // print(body['records']);
      update();
      return productResponseList;
    } else {
      return productResponseList;
    }
  }

  Future getSearchProducts(String name) async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    String data = name;
    String url =
        serverUrl+'api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&userId=${user_id}&productname=${data}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    print(body);
    if (response.statusCode == 200) {
      stringResponse = response.body;
      mapResponse = jsonDecode(response.body);
      productsearchResponseList = mapResponse['records'];
      print("refresh search history");
      print(productsearchResponseList);

      return productsearchResponseList;
    } else {
      return productsearchResponseList;
    }
  }

  Future getFilterProducts(
      String isPopular,
      String highToLow,
      int maxPrice,
      int minPrice,
      String sortColumn,
      String CatagoryId,
      String offerId,
      String productName) async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int userId = jsonDecode(iddata!);
    print("running");
    String url =
        serverUrl+'api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&maxprice=${maxPrice}&minprice=${minPrice}&ispopular=${isPopular}&sorting=${sortColumn}&Asc=${highToLow}&userId=${userId}&categoryId=${CatagoryId}&offerId=${offerId}&productname=${productName}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    // print(body.toString());
    if (response.statusCode == 200) {
      stringResponse = response.body;
      mapResponse = jsonDecode(response.body);
      productFilterResponseList = mapResponse['records'];
      print("refresh filter history");
      // print(productFilterResponseList);
      return productFilterResponseList;
    } else {
      print("error");
    }
  }

  Future getCount() async {
    var store = await SharedPreferences.getInstance();
    var iddata = store.getString('id');
    int user_id = jsonDecode(iddata!);
    String url = serverUrl+'api/auth/getCount/${user_id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      onInit();
      count = body;
      update();
    }
  }
}
