import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/Pages/cart/cart_screen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // TODO: implement initState
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            CommanDialog.showLoading();
            // productController.getAllProducts();
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
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu, color: black),
            onPressed: () {
              Get.to(() => Navbar());
            }, //=> _key.currentState!.openDrawer(),
          ),
        ],
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    // height: 350,
                    child: GetBuilder<ProductController>(builder: (controller) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: productController
                              .productFilterResponseList.length,
                          // scrollDirection: Axis.horizontal,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            var product = productController
                                .productFilterResponseList[index];
                            return Column(
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 30),
                                    width: 280,
                                    height: 180,
                                    child: FadeInImage(
                                      placeholder: FileImage(File(
                                          '${directory.path}/${productController.productFilterResponseList[index]['imageUrl'].toString()}')),
                                      image: NetworkImage(
                                        serverUrl +
                                            'api/auth/serveproducts/${productController.productFilterResponseList[index]['imageUrl'].toString()}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    // decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //         image: NetworkImage(
                                    //           serverUrl +
                                    //               'api/auth/serveproducts/${product['imageUrl'].toString()}',
                                    //         ),
                                    //         fit: BoxFit.cover)),
                                  ),
                                ),
                                SizedBox(
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
                                          SizedBox(
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
                                                    color: product['isVegan'] ==
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
                                                  '${product['weight'].toString()}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium)
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text("\₹ ${product['price'].toString()} ",
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Quantity",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ],
                                  ),
                                ),
                                SizedBox(
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
                                            color: grey),
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
                                                                  ['inventory']
                                                              ['quantity'] >
                                                          0
                                                      ? Container(
                                                          width: 180,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: buttonColour,
                                                          ),
                                                          child: productController
                                                                              .productFilterResponseList[
                                                                          index]
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
                                                                          EdgeInsets
                                                                              .zero,
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            35,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(Icons.remove),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              productController.increasequantity(this.id!, productController.productFilterResponseList[index]['id'], this.remove);
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
                                                                          .productFilterResponseList[
                                                                              index]
                                                                              [
                                                                              'cartQauntity']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              white),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            30,
                                                                        child:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(Icons.add),
                                                                          color:
                                                                              white,
                                                                          onPressed:
                                                                              () {
                                                                            if (productController.productFilterResponseList[index]['cartQauntity'] < 5 &&
                                                                                productController.productFilterResponseList[index]['inventory']['quantity'] > productController.productFilterResponseList[index]['cartQauntity']) {
                                                                              productController.increasequantity(this.id!, productController.productFilterResponseList[index]['id'], this.add);
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
                                                                        this
                                                                            .id!,
                                                                        productController.productFilterResponseList[index]
                                                                            [
                                                                            'id'],
                                                                        this.add);
                                                                    setState(
                                                                        () {
                                                                      productController
                                                                              .productFilterResponseList[index]
                                                                          [
                                                                          'cartQauntity'] = 1;
                                                                      productController.productFilterResponseList[index]
                                                                              [
                                                                              'added'] =
                                                                          true;
                                                                    });
                                                                  },
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        buttonColour,
                                                                  ),
                                                                  child: Text(
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
                                                      : Text(
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
        duration: Duration(milliseconds: 1000),
        opacity: 1.0,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => CartScreen());
          },
          child: Center(
            child: Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: black,
                ),
                onPressed: () {
                  Get.to(() => CartScreen());
                },
              ),
              badgeContent:
                  GetBuilder<ProductController>(builder: (controller) {
                return Text(
                  productController.count.toString(),
                  style: TextStyle(color: white),
                );
              }),
            ),
          ),
          // child: Icon(Icons.shopping_bag_outlined),
          backgroundColor: white,
        ),
      ),
    );
  }
}
