import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Home/Search.dart';
import 'package:flutter_login_app/Pages/Order/ItemData.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/cart_screen.dart';

class PopularProductList extends StatefulWidget {
  const PopularProductList({Key? key}) : super(key: key);

  @override
  State<PopularProductList> createState() => _PopularProductListState();
}

class _PopularProductListState extends State<PopularProductList> {
  final productController = Get.put(ProductController());
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
        backgroundColor: Colors.white,
        title: Text('Product List', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              child: IconButton(
                icon: Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Get.to(() => CartScreen());
                },
              ),
              badgeContent: Text(
                "6",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(child: GetX<PopularProductController>(builder: (controller) {
          return ListView.builder(
              itemCount: controller.popular.length,
              itemBuilder: (context, index) {
                var popular = controller.popular[index];
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
                                  'http://10.0.2.2:8082/api/auth/serveproducts/${popular.imageUrl.toString()}')
                              // image: AssetImage("assets/shoe_1.webp"),
                              ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  popular.name.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹" + popular.price.toString(),
                                  // "49999rs",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹" +
                                      popular.price.toString() +
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
                                  popular.desc.toString(),
                                  // "Discription",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "only stock" +
                                      popular.inventory.quantity.toString(),
                                  // "only stock 5",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          controller.popular[index].isAdded
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(Icons.remove),
                                                      onPressed: () {
                                                        setState(() {
                                                          productController
                                                              .increasequantity(
                                                                  this.id!,
                                                                  popular.id,
                                                                  this.remove);
                                                          if (controller
                                                                  .popular[
                                                                      index]
                                                                  .counter >
                                                              1) {
                                                            controller
                                                                .popular[index]
                                                                .counter--;
                                                          } else {
                                                            controller
                                                                .popular[index]
                                                                .isAdded = false;
                                                          }
                                                        });
                                                      },
                                                      color: Colors.black,
                                                    ),
                                                    Text(controller
                                                        .popular[index].counter
                                                        .toString()),
                                                    IconButton(
                                                      icon: Icon(Icons.add),
                                                      color: Colors.black,
                                                      onPressed: () {
                                                        productController
                                                            .increasequantity(
                                                                this.id!,
                                                                popular.id,
                                                                this.add);
                                                        setState(() {
                                                          controller
                                                              .popular[index]
                                                              .counter++;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    productController
                                                        .increasequantity(
                                                            this.id!,
                                                            popular.id,
                                                            this.add);
                                                    setState(() {
                                                      controller.popular[index]
                                                          .isAdded = true;
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                  child: Text("Add to Cart"),
                                                ),
                                        ]))
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
    );
  }
}
