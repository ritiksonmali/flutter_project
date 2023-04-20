import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart' as globals;
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/model/Product.dart';
import 'package:flutter_login_app/model/ProductModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/globals.dart';

class ProductController extends GetxController {
  var productData = <ProductModel>[];
  // List QuantityResponse = [];
  String stringResponse = '';
  List productsearchResponseList = [];
  List productResponseList = [].obs;
  List productFilterResponseList = [];
  // List productResponseList = [];
  late Map mapResponse;
  int count = 0;

  // bool _isLoadMoreRunning = false;
  ScrollController scrollController = ScrollController();
  // List<ProductModel> DemoProduct = [];{}
  main() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    globals.currentUserId = jsonDecode(iddata!);
  }

  @override
  void onReady() {
    super.onReady();
    getCount();
  }

  List<Product> cartitem = List<Product>.empty().obs;

  Future increasequantity(int userId, productId, String sum) async {
    try {
      String url =
          '${serverUrl}api/auth/addProductsInCart?userId=$userId&productId=$productId&sum=$sum';
      // ignore: unused_local_variable
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      e.printError();
    }
  }

  addtoCart(int userId, Product product) async {
    try {
      String url = '${serverUrl}api/auth/addToCart/$userId';
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"product_id": product.id, "quantity": 1}));

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        cartitem.add(product);
      }
    } on Exception catch (e) {
      e.printError();
    }
  }

  Future setPaymentDetails(String paymentId, String paymentStatus,
      String orderId, bool check) async {
    try {
      String url = '${serverUrl}setOrderPaymentStatus';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "orderId": orderId,
            "paymentId": paymentId,
            "paymentStatus": paymentStatus,
            "iswallet": check
          }));
      if (response.statusCode == 200) {
        await LogsController.printLog(
            ProductController, "INFO", "Payment Successful");
        // print(response.body);
      }
    } on Exception catch (e) {
      e.printError();
    }
  }

  Future getAllProducts() async {
    try {
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String url =
          '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=5&status=active&userId=$userId';
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
        update();
        await LogsController.printLog(
            ProductController, "INFO", "get all product success");
        return productResponseList;
      } else {
        await LogsController.printLog(ProductController, "ERROR",
            "get all product Failed : ${response.body}");
        return productResponseList;
      }
    } catch (e) {
      await LogsController.printLog(
          ProductController, "ERROR", "get all product failed : $e");
      e.printError();
    }
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }

  Future getSearchProducts(String name) async {
    try {
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String data = name;
      String url =
          '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active&userId=$userId&productname=$data';
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
        return productsearchResponseList;
      } else {
        return productsearchResponseList;
      }
    } on Exception catch (e) {
      e.printError();
    }
  }

  Future getFilterProducts(
      String isPopular,
      String highToLow,
      int maxPrice,
      int minPrice,
      String sortColumn,
      String catagoryId,
      String offerId,
      String productName,
      String productId) async {
    try {
      var store = await SharedPreferences.getInstance(); //add when requried
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String url =
          '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=5&status=active&maxprice=$maxPrice&minprice=$minPrice&ispopular=$isPopular&sorting=$sortColumn&Asc=$highToLow&userId=$userId&categoryId=$catagoryId&offerId=$offerId&productname=$productName&productId=$productId';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        stringResponse = response.body;
        mapResponse = jsonDecode(response.body);
        productFilterResponseList = mapResponse['records'];
        update();
        await LogsController.printLog(
            ProductController, "INFO", "get filtered product successful");
        return productFilterResponseList;
      } else {
        await LogsController.printLog(ProductController, "ERROR",
            "get filtered product Failed ${response.body}");
        print("error");
      }
    } catch (e) {
      await LogsController.printLog(
          ProductController, "ERROR", "error in filter product $e");
      e.printError();
    }
  }

  Future getCount() async {
    try {
      var store = await SharedPreferences.getInstance();
      var iddata = store.getString('id');
      int userId = jsonDecode(iddata!);
      String url = '${serverUrl}api/auth/getCount/$userId';
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
    } on Exception catch (e) {
      e.printError();
    }
  }
}
