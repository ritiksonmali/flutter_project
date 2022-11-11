import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Home/Search.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/cart_screen.dart';

class PopularProductList extends StatefulWidget {
  const PopularProductList({Key? key}) : super(key: key);

  @override
  State<PopularProductList> createState() => _PopularProductListState();
}

class _PopularProductListState extends State<PopularProductList> {
  final ProductController productController = Get.put(ProductController());
  final PopularProductController popularproductController = Get.find();

  int? id;
  String add = "add";
  String remove = "remove";

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
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text('Product List', style: TextStyle(color: black)),
        iconTheme: IconThemeData(color: black),
        centerTitle: true,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Get.to(() => SearchPage());
            },
          ),
          // Center(
          //   // child: Badge(
          //   //   position: BadgePosition.topEnd(top: 0, end: 3),
          //     child: IconButton(
          //       icon: Icon(Icons.shopping_bag_outlined),
          //       onPressed: () {
          //         Get.to(() => CartScreen());
          //       },
          //     ),
          //     // badgeContent: Text(
          //     //   "6",
          //     //   style: TextStyle(color: white),
          //     //),
          //  // ),
          // ),
        ],
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Filter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                onPressed: () {},
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
            child: GetBuilder<PopularProductController>(builder: (controller) {
          return ListView.builder(
              itemCount: productController.productResponseList.length,
              itemBuilder: (context, index) {
                var popular = productController.productResponseList[index];
                // itemCount:
                // productImage.length;

                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(
                                  'http://10.0.2.2:8082/api/auth/serveproducts/${productController.productResponseList[index]['imageUrl'].toString()}')
                              // image: AssetImage("assets/shoe_1.webp"),
                              ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productController.productResponseList[index]
                                          ['name']
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹" +
                                      productController
                                          .productResponseList[index]['price']
                                          .toString(),
                                  // "49999rs",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹" +
                                      productController
                                          .productResponseList[index]['price']
                                          .toString() +
                                      "\n" +
                                      "rs 36% off",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  productController.productResponseList[index]
                                          ['desc']
                                      .toString(),
                                  // "Discription",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 160),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: black,
                                    ),
                                    child: productController
                                                    .productResponseList[index]
                                                ['cartQauntity'] !=
                                            0
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    productController
                                                        .increasequantity(
                                                            this.id!,
                                                            productController
                                                                    .productResponseList[
                                                                index]['id'],
                                                            this.remove);
                                                    if (productController
                                                                .productResponseList[
                                                            index]['cartQauntity'] >
                                                        1) {
                                                      productController
                                                                      .productResponseList[
                                                                  index]
                                                              ['cartQauntity'] =
                                                          productController
                                                                          .productResponseList[
                                                                      index][
                                                                  'cartQauntity'] -
                                                              1;
                                                    } else {
                                                      productController
                                                                  .productResponseList[
                                                              index]
                                                          ['cartQauntity'] = 0;
                                                      productController
                                                              .productResponseList[
                                                          index]['added'] = false;
                                                    }
                                                  });
                                                },
                                                color: white,
                                              ),
                                              Text(
                                                productController
                                                    .productResponseList[index]
                                                        ['cartQauntity']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: white),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                color: white,
                                                onPressed: () {
                                                  if (productController.productResponseList[
                                                                  index]
                                                              ['cartQauntity'] <
                                                          5 &&
                                                      productController.productResponseList[
                                                                      index]
                                                                  ['inventory']
                                                              ['quantity'] >
                                                          productController
                                                                      .productResponseList[
                                                                  index][
                                                              'cartQauntity']) {
                                                    productController
                                                        .increasequantity(
                                                            this.id!,
                                                            productController
                                                                    .productResponseList[
                                                                index]['id'],
                                                            this.add);
                                                    setState(() {
                                                      productController
                                                                      .productResponseList[
                                                                  index]
                                                              ['cartQauntity'] =
                                                          productController
                                                                          .productResponseList[
                                                                      index][
                                                                  'cartQauntity'] +
                                                              1;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              productController.increasequantity(
                                                  this.id!,
                                                  productController
                                                          .productResponseList[
                                                      index]['id'],
                                                  this.add);
                                              setState(() {
                                                productController
                                                        .productResponseList[
                                                    index]['cartQauntity'] = 1;
                                                productController
                                                        .productResponseList[
                                                    index]['added'] = true;
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: black,
                                            ),
                                            child: Text("Add to Cart"),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              });
        }))
      ]),
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: 1.0,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => CartScreen());
          },
          child: Icon(Icons.shopping_bag_outlined),
          backgroundColor: black,
        ),
      ),
    );
  }
}
