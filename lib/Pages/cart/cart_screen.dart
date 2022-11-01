import 'dart:convert';
import 'dart:ffi';

import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/CartController.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ConstantUtil/colors.dart';
import '../Home/Search.dart';
import '../Payment/RazorPayPayment.dart';
import 'Checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

// final CartController cartController = Get.put(CartController());

class _CartScreenState extends State<CartScreen> {
//   DBHelper? dbHelper = DBHelper();

  String add = "add";
  String remove = "remove";
  Int? count;

  int maxCounter = 4;
  int counter = 0;

  List cartproducts = [];
  var product = {
    "id": 0,
    "quantity": 0,
    "product": {
      "id": 0,
      "name": '',
      "desc": '',
      "price": 0,
      "imageUrl": '',
      "status": '',
      "ispopular": false,
      "inventory": {
        "createdDate": null,
        "lastModifiedDate": null,
        "id": 0,
        "quantity": 0
      }
    }
  };
  var total;

  int? id;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      this.id = id;
      apiCall();
    });
  }

  Future getCartproducts(userId) async {
    // print("fatchProduct $userId");
    // var postData = {"productid": id};

    CommanDialog.showLoading();
    String url = 'http://10.0.2.2:8082/api/auth/getcartitems/${userId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    CommanDialog.hideLoading();
    print(body['cartItems']);

    return body['cartItems'];
  }

  apiCall() async {
    var allproductsfromapi = await getCartproducts(id);
    setState(() {
      cartproducts = allproductsfromapi;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
//     final cart  = Provider.of<CartProvider>(context);
//  var userId = Get.arguments;
//     print(userId);

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       cartController.getCartproducts(userId['userId']);
//     });
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "My Bag",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu),
            onPressed: () {}, //=> _key.currentState!.openDrawer(),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 25),
            child: Text(
              "My Bag",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
          Column(
            children: List.generate(cartproducts.length, (index) {
              print(cartproducts);
              var cartdata = cartproducts[index];
              total = cartproducts.length > 0
                  ? cartproducts
                      .map<int>((m) => m['product']['price'] * m['quantity'])
                      .reduce((value, element) => value + element)
                      .toStringAsFixed(2)
                  : 0;
              return Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: grey,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0.5,
                                color: black.withOpacity(0.1),
                                blurRadius: 1)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 25, right: 25, bottom: 25),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 120,
                                height: 70,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'http://10.0.2.2:8082/api/auth/serveproducts/${cartdata['product']['imageUrl'].toString()}'),
                                        // image: AssetImage("assets/shoe_1.webp"),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              cartdata['product']['name'],
                              // "Jorden",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Container(
                            //   child: IconButton(
                            //     icon: Icon(Icons.delete, color: Colors.black),
                            //     onPressed: () {
                            //       //  Get.to(() => SearchPage());//deletefunction
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              cartdata['product']['price'].toString(),
                              // "\$ 200",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            // Text(
                            //   '${cartproducts.length > 0 ? cartproducts.map<int>((m) => m['product']['price'] * m['quantity']).reduce((value, element) => value + element).toStringAsFixed(2) : 0}',
                            //   // "\$ 200",
                            //   style: TextStyle(
                            //       fontSize: 15, fontWeight: FontWeight.w500),
                            // ),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Colors.black,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: SizedBox(
                                        height: 50,
                                        width: 35,
                                        child: IconButton(
                                          icon: Icon(Icons.remove,
                                              color: Colors.white),
                                          onPressed: () {
                                            increasequantity(
                                                this.id!,
                                                cartdata['product']['id'],
                                                this.remove);
                                            setState(() {
                                              if (cartdata['quantity'] == 1) {
                                                cartproducts.removeAt(index);
                                                if (cartproducts.isEmpty) {
                                                  cartproducts.add(product);
                                                }
                                              } else {
                                                cartdata['quantity'] =
                                                    cartdata['quantity'] - 1;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  //  Obx(()=>Text("${myProductController.},
                                  Text(
                                    cartdata['quantity'].toString(),
                                    // "1",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: SizedBox(
                                      height: 50,
                                      width: 30,
                                      child: IconButton(
                                        icon: Icon(Icons.add,
                                            color: Colors.white),
                                        onPressed: () {
                                          if (cartdata['product']['inventory']
                                                      ['quantity'] >
                                                  cartdata['quantity'] &&
                                              cartdata['quantity'] < 5) {
                                            increasequantity(
                                                this.id!,
                                                cartdata['product']['id'],
                                                this.add);
                                            setState(() {
                                              cartdata['quantity'] =
                                                  cartdata['quantity'] + 1;
                                              counter++;
                                            });
                                          }

                                          // Get.to(() => SearchPage());
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              );
            }),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(
                      fontSize: 22,
                      color: black.withOpacity(0.5),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "\$ ${total}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              color: Colors.black,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: cartproducts.isEmpty
                    ? null
                    : () {
                        Get.to(() => CheckoutScreen());
                      },
                child: const Text(
                  'CHECKOUT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Future increasequantity(int userId, productId, String sum) async {
    String url =
        'http://10.0.2.2:8082/api/auth/addProductsInCart?userId=${userId}&productId=${productId}&sum=${sum}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    setState(() {
      count = body['quantity'];
    });
    return body['quantity'];
  }
}

// Widget getBody() {
//   return
// }
Widget getBody() {
  return ListView(
    children: <Widget>[
      Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: grey,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.5,
                            color: black.withOpacity(0.1),
                            blurRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 25, right: 25, bottom: 25),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 120,
                            height: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/shoe_1.webp"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Jorden",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "\$ 200",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "x1",
                          style: TextStyle(
                              fontSize: 14,
                              color: black.withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ))
              ],
            ),
          );
        }),
      ),
      SizedBox(
        height: 50,
      ),
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Total",
              style: TextStyle(
                  fontSize: 22,
                  color: black.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "\$ 508.00",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          color: Colors.black,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              // Get.to(() => CheckoutScreen());
            },
            child: const Text('CHECKOUT'),
          ),
        ),
        // child: Container(
        //   height: 50,
        //  child: Center(
        //    child: Text("CHECKOUT",style: TextStyle(
        //      color: white,
        //      fontSize: 15,
        //      fontWeight: FontWeight.w600
        //    ),),
        //  ),
        // )
      ),
    ],
  );
}
