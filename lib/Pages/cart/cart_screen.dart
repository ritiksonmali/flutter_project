import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ConstantUtil/colors.dart';
import '../../ConstantUtil/globals.dart';
import '../../Controller/ProductController.dart';
import '../Home/home_screen.dart';
import 'Checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

// final CartController cartController = Get.put(CartController());

class _CartScreenState extends State<CartScreen> {
//   DBHelper? dbHelper = DBHelper();

  final ProductController productController = Get.put(ProductController());
  String add = "add";
  String remove = "remove";
  Int? count;
  bool isLoading = true;

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
    CommanDialog.showLoading();
    String url = serverUrl + 'api/auth/getcartitems/${userId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    setState(() {
      isLoading = false;
    });
    var body = jsonDecode(response.body);
    CommanDialog.hideLoading();
    // print(body['cartItems']);

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
    return WillPopScope(
      onWillPop: () async {
        CommanDialog.showLoading();
        productController.getAllProducts();
        productController.getCount();
        Timer(Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen()), // this mymainpage is your page to refresh
            (Route<dynamic> route) => false,
          );
          CommanDialog.hideLoading();
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          // automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              CommanDialog.showLoading();
              productController.getAllProducts();
              productController.getCount();
              Timer(Duration(seconds: 1), () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // this mymainpage is your page to refresh
                  (Route<dynamic> route) => false,
                );
                CommanDialog.hideLoading();
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
          title: Text(
            "Cart",
            style: TextStyle(
              color: black,
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Get.to(() => Navbar());
              }, //=> _key.currentState!.openDrawer(),
            ),
          ],
          backgroundColor: white,
        ),
        body: isLoading == true
            ? Scaffold()
            : cartproducts.isEmpty
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/cartempty.png'),
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Your Cart Is Empty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: black,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Looks like You Didn\'t \n add anything in your cart yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: List.generate(cartproducts.length, (index) {
                          // print(cartproducts);
                          var cartdata = cartproducts[index];
                          total = cartproducts.length > 0
                              ? cartproducts
                                  .map<int>((m) =>
                                      m['product']['price'] * m['quantity'])
                                  .reduce((value, element) => value + element)
                                  .toStringAsFixed(2)
                              : 0;
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 30),
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
                                        top: 10,
                                        left: 25,
                                        right: 25,
                                        bottom: 25),
                                    child: Column(
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            width: 120,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(serverUrl +
                                                        'api/auth/serveproducts/${cartdata['product']['imageUrl'].toString()}'),
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
                                        Expanded(
                                          child: Text(
                                            cartdata['product']['name'],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            "₹" +
                                                cartdata['product']['price']
                                                    .toString(),
                                            // "\$ 200",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Container(
                                          width: 80,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: black,
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
                                                            color: white),
                                                        onPressed: () {
                                                          increasequantity(
                                                              this.id!,
                                                              cartdata[
                                                                      'product']
                                                                  ['id'],
                                                              this.remove);
                                                          setState(() {
                                                            if (cartdata[
                                                                    'quantity'] ==
                                                                1) {
                                                              cartproducts
                                                                  .removeAt(
                                                                      index);
                                                              // if (cartproducts.isEmpty) {
                                                              //   cartproducts.add(product);
                                                              // }
                                                            } else {
                                                              cartdata[
                                                                      'quantity'] =
                                                                  cartdata[
                                                                          'quantity'] -
                                                                      1;
                                                            }
                                                          });
                                                        }),
                                                  ),
                                                ),
                                              ),
                                              //  Obx(()=>Text("${myProductController.},

                                              Text(
                                                cartdata['quantity'].toString(),
                                                style: TextStyle(color: white),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 30,
                                                  child: IconButton(
                                                    icon: Icon(Icons.add,
                                                        color: white),
                                                    onPressed: () {
                                                      if (cartdata['product'][
                                                                      'inventory']
                                                                  ['quantity'] >
                                                              cartdata[
                                                                  'quantity'] &&
                                                          cartdata['quantity'] <
                                                              5) {
                                                        increasequantity(
                                                            this.id!,
                                                            cartdata['product']
                                                                ['id'],
                                                            this.add);
                                                        setState(() {
                                                          cartdata['quantity'] =
                                                              cartdata[
                                                                      'quantity'] +
                                                                  1;
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
                            Text("Total",
                                style: Theme.of(context).textTheme.titleLarge),
                            Text("\₹${total}",
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: black,
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: black,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: cartproducts.isEmpty
                                ? null
                                : () {
                                    Get.to(() => CheckoutScreen());
                                  },
                            child: const Text(
                              'Checkout',
                              style: TextStyle(color: white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
      ),
    );
  }

  Future increasequantity(int userId, productId, String sum) async {
    String url = serverUrl +
        'api/auth/addProductsInCart?userId=${userId}&productId=${productId}&sum=${sum}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    print(body);
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
          color: black,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: white,
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
