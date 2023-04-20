import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
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
    // CommanDialog.showLoading();
    String url = '${serverUrl}api/auth/getcartitems/$userId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    setState(() {
      isLoading = false;
    });
    var body = jsonDecode(response.body);
    // CommanDialog.hideLoading();
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
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return WillPopScope(
      onWillPop: () async {
        // CommanDialog.showLoading();
        // productController.getAllProducts();
        // productController.getCount();
        // Timer(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen()), // this mymainpage is your page to refresh
          (Route<dynamic> route) => false,
        );
        //   CommanDialog.hideLoading();
        // });
        return false;
      },
      child: Scaffold(
        backgroundColor: grey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: white),
          // automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              // CommanDialog.showLoading();
              // productController.getAllProducts();
              // productController.getCount();
              // Timer(const Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen()), // this mymainpage is your page to refresh
                (Route<dynamic> route) => false,
              );
              // CommanDialog.hideLoading();
              // });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
          title: Text(
            "Cart",
            style: Theme.of(context).textTheme.headline5!.apply(color: white),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Get.to(() => const Navbar());
              }, //=> _key.currentState!.openDrawer(),
            ),
          ],
          backgroundColor: kPrimaryGreen,
        ),
        body: isLoading == true
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      5, // number of shimmer placeholders you want to show
                  itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey[300],
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15,
                                    width: 100,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.only(bottom: 5),
                                  ),
                                  Container(
                                    height: 15,
                                    width: 200,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.only(bottom: 5),
                                  ),
                                  Container(
                                    height: 15,
                                    width: 150,
                                    color: Colors.grey[300],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              )
            : cartproducts.isEmpty
                ? Center(
                    child: Container(
                      color: grey,
                      child: Column(
                        children: [
                          Container(
                            // margin: EdgeInsets.only(top: 80),
                            // padding: EdgeInsets.all(20),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.fill,
                              image: const AssetImage('assets/cartempty.png'),
                            )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your Cart Is Empty',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .apply(color: black),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Looks like You Didn\'t \n add anything in your cart yet',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .apply(color: AppColor.secondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: grey,
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(
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
                                        color: white,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0.5,
                                              color: black.withOpacity(0.1),
                                              blurRadius: 1)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 15,
                                          right: 15,
                                          bottom: 10),
                                      child: Center(
                                        child: Container(
                                          width: width * 0.25,
                                          height: height * 0.10,
                                          child: ImageFade(
                                              image: NetworkImage(
                                                  '${serverUrl}api/auth/serveproducts/${cartdata['product']['imageUrl'].toString()}'),
                                              fit: BoxFit.cover,
                                              // scale: 2,
                                              placeholder: Image.file(
                                                fit: BoxFit.cover,
                                                File(
                                                    '${directory.path}/compress${cartdata['product']['imageUrl'].toString()}'),
                                                gaplessPlayback: true,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              cartdata['product']['name'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                Icons.crop_square_sharp,
                                                color: cartdata['product']
                                                            ['isVegan'] ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 20,
                                              ),
                                              Icon(Icons.circle,
                                                  color: cartdata['product']
                                                              ['isVegan'] ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 6),
                                            ],
                                          ),
                                          Text(
                                              cartdata['product']['weight']
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium)
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "₹${cartdata['product']['price']}",
                                            // "\$ 200",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Container(
                                            width: width * 0.2,
                                            height: height * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: buttonColour,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.zero,
                                                    child: SizedBox(
                                                      height: height * 0.05,
                                                      width: width * 0.05,
                                                      child: IconButton(
                                                          iconSize:
                                                              height * 0.02,
                                                          icon: const Icon(
                                                              Icons.remove,
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
                                                  cartdata['quantity']
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .apply(color: white),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: SizedBox(
                                                      height: height * 0.05,
                                                      width: width * 0.05,
                                                      child: IconButton(
                                                        iconSize: height * 0.02,
                                                        icon: const Icon(
                                                            Icons.add,
                                                            color: white),
                                                        onPressed: () {
                                                          if (cartdata['product']
                                                                          [
                                                                          'inventory']
                                                                      [
                                                                      'quantity'] >
                                                                  cartdata[
                                                                      'quantity'] &&
                                                              cartdata[
                                                                      'quantity'] <
                                                                  5) {
                                                            increasequantity(
                                                                this.id!,
                                                                cartdata[
                                                                        'product']
                                                                    ['id'],
                                                                this.add);
                                                            setState(() {
                                                              cartdata[
                                                                      'quantity'] =
                                                                  cartdata[
                                                                          'quantity'] +
                                                                      1;
                                                            });
                                                          }
                                                        },
                                                      ),
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
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Total",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              Text("\₹$total",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ],
                          ),
                        ),
                        const SizedBox(
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
                                backgroundColor: buttonColour,
                                padding: const EdgeInsets.all(16.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: cartproducts.isEmpty
                                  ? null
                                  : () {
                                      Get.to(() => const CheckoutScreen());
                                    },
                              child: const Text(
                                'Checkout',
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
      ),
    );
  }

  Future increasequantity(int userId, productId, String sum) async {
    String url =
        '${serverUrl}api/auth/addProductsInCart?userId=$userId&productId=$productId&sum=$sum';
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
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/shoe_1.webp"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Jorden",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
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
      const SizedBox(
        height: 50,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
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
            const Text(
              "\$ 508.00",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      const SizedBox(
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
