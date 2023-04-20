import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/ApplicationParameterController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/Pages/cart/cart_screen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int? id;
  String add = "add";
  String remove = "remove";
  int counter = 0;
  bool isAdded = false;
  ProductController productController = Get.find();
  var argument = Get.arguments;
  bool isLoading = true;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      this.id = id;
    });
  }

  @override
  void initState() {
    super.initState();
    productController.productFilterResponseList.clear();
    test();
    productController
        .getFilterProducts(
            '', '', 10000, 0, '', '', '', '', argument['productId'])
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen()), // this mymainpage is your page to refresh
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: grey,
        appBar: AppBar(
          title: Text(
            "Product Details",
            style: Theme.of(context).textTheme.headline5!.apply(color: white),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryGreen,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              // CommanDialog.showLoading();
              // productController.getAllProducts();
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
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.menu, color: white),
              onPressed: () {
                Get.to(() => const Navbar());
              }, //=> _key.currentState!.openDrawer(),
            ),
          ],
        ),
        body: isLoading == true
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            width: 280,
                            height: 180,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 50,
                                      height: 15,
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 80,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 250,
                              height: 15,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 15,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 250,
                                  height: 15,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 200,
                                  height: 15,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      // height: 350,
                      child:
                          GetBuilder<ProductController>(builder: (controller) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: productController
                                .productFilterResponseList.length,
                            // scrollDirection: Axis.horizontal,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              var product = productController
                                  .productFilterResponseList[index];
                              return Column(
                                children: [
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      width: 280,
                                      height: 180,
                                      child: FadeInImage(
                                        placeholder: FileImage(File(
                                            '${directory.path}/${productController.productFilterResponseList[index]['imageUrl'].toString()}')),
                                        image: NetworkImage(
                                          '${serverUrl}api/auth/serveproducts/${productController.productFilterResponseList[index]['imageUrl'].toString()}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(product['name'].toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
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
                                                      color:
                                                          product['isVegan'] ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.red,
                                                      size: 25,
                                                    ),
                                                    Icon(Icons.circle,
                                                        color:
                                                            product['isVegan'] ==
                                                                    true
                                                                ? Colors.green
                                                                : Colors.red,
                                                        size: 8),
                                                  ],
                                                ),
                                                Text(
                                                    product['weight']
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium)
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                            "\₹ ${product['price'].toString()} ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  product['desc'].toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Quantity",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 20, left: 10, right: 10),
                                        child: Container(
                                          width: size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    productController.productFilterResponseList[
                                                                            index]
                                                                        [
                                                                        'inventory']
                                                                    [
                                                                    'quantity'] >
                                                                0 &&
                                                            ApplicationParameterController
                                                                .isOrdersEnable
                                                                .value
                                                        ? Container(
                                                            width: 180,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  buttonColour,
                                                            ),
                                                            child: productController
                                                                            .productFilterResponseList[index]
                                                                        [
                                                                        'cartQauntity'] !=
                                                                    0
                                                                ? Row(
                                                                    // mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              35,
                                                                          child:
                                                                              IconButton(
                                                                            icon:
                                                                                const Icon(Icons.remove),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                productController.increasequantity(id!, productController.productFilterResponseList[index]['id'], remove);
                                                                                if (productController.productFilterResponseList[index]['cartQauntity'] > 1) {
                                                                                  productController.productFilterResponseList[index]['cartQauntity'] = productController.productFilterResponseList[index]['cartQauntity'] - 1;
                                                                                } else {
                                                                                  productController.productFilterResponseList[index]['cartQauntity'] = 0;
                                                                                  productController.productFilterResponseList[index]['added'] = false;
                                                                                }
                                                                              });
                                                                            },
                                                                            color:
                                                                                white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        productController
                                                                            .productFilterResponseList[index]['cartQauntity']
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                white),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              30,
                                                                          child:
                                                                              IconButton(
                                                                            icon:
                                                                                const Icon(Icons.add),
                                                                            color:
                                                                                white,
                                                                            onPressed:
                                                                                () {
                                                                              if (productController.productFilterResponseList[index]['cartQauntity'] < 5 && productController.productFilterResponseList[index]['inventory']['quantity'] > productController.productFilterResponseList[index]['cartQauntity']) {
                                                                                productController.increasequantity(id!, productController.productFilterResponseList[index]['id'], add);
                                                                                setState(() {
                                                                                  productController.productFilterResponseList[index]['cartQauntity'] = productController.productFilterResponseList[index]['cartQauntity'] + 1;
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      productController.increasequantity(
                                                                          id!,
                                                                          productController.productFilterResponseList[index]
                                                                              [
                                                                              'id'],
                                                                          add);
                                                                      setState(
                                                                          () {
                                                                        productController.productFilterResponseList[index]
                                                                            [
                                                                            'cartQauntity'] = 1;
                                                                        productController.productFilterResponseList[index]['added'] =
                                                                            true;
                                                                      });
                                                                    },
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          buttonColour,
                                                                    ),
                                                                    child: const Text(
                                                                        "Add",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              white,
                                                                          fontSize:
                                                                              16,
                                                                        )),
                                                                  ),
                                                          )
                                                        : const Text(
                                                            'Out Of Stock',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      }),
                    ),
                  ],
                ),
              ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          opacity: 1.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            backgroundColor: white,
            child: Center(
              child: Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                badgeContent:
                    GetBuilder<ProductController>(builder: (controller) {
                  return Text(
                    productController.count.toString(),
                    style: const TextStyle(color: white),
                  );
                }),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: black,
                  ),
                  onPressed: () {
                    Get.to(() => const CartScreen());
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
