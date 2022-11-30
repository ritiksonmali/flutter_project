import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Search/Search.dart';
import 'package:flutter_login_app/Pages/Order/ItemData.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Filter/Filter.dart';
import '../cart/cart_screen.dart';

class SearchProductList extends StatefulWidget {
  const SearchProductList({Key? key}) : super(key: key);

  @override
  State<SearchProductList> createState() => _SearchProductListState();
}

class _SearchProductListState extends State<SearchProductList> {
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
        backgroundColor: Colors.white,
        title: Text('Product List', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
       
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
                onPressed: () {
                  Get.to(() => FilterPage());
                },
              ),
            )
          ],
        ),
        Expanded(
           child: GetBuilder<PopularProductController>
           (builder: (controller) {
          return ListView.builder(
               itemCount: productController.productsearchResponseList.length,
              itemBuilder: (context, index) {
                var popular = productController.productsearchResponseList[index];
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
                                  'http://158.85.243.11:8082/api/auth/serveproducts/${productController.productsearchResponseList[index]['imageUrl'].toString()}')
                              // image: AssetImage("assets/shoe_1.webp"),
                              ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 productController.productsearchResponseList[index]['name'].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹" + productController.productsearchResponseList[index]['price'].toString(),
                                  // "49999rs",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "₹" +
                                     productController.productsearchResponseList[index]['price'].toString() +
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
                                  productController.productsearchResponseList[index]['desc'].toString(),
                                  // "Discription",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          productController.productsearchResponseList[index]['cartQauntity'] !=0 
                                                            ? Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  IconButton(
                                                                    icon: Icon(Icons
                                                                        .remove),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        productController.increasequantity(
                                                                            this.id!,
                                                                           productController.productsearchResponseList[index]['id'],
                                                                            this.remove);
                                                                        if (productController.productsearchResponseList[index]['cartQauntity'] >
                                                                            1) {
                                                                          productController.productsearchResponseList[index]['cartQauntity']=productController.productsearchResponseList[index]['cartQauntity']-1;
                                                                        } else {
                                                                           productController.productsearchResponseList[index]['cartQauntity']=0;
                                                                          productController
                                                                              .productsearchResponseList[index]['added']
                                                                               = false;
                                                                        }
                                                                      });
                                                                    },
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  Text(  productController.productsearchResponseList[index]['cartQauntity'].toString(),),
                                                                  IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                    color: Colors
                                                                        .black,
                                                                    onPressed:
                                                                        () {
                                                                      productController.increasequantity(
                                                                          this.id!,
                                                                         productController.productsearchResponseList[index]['id'],
                                                                          this.add);
                                                                      setState(
                                                                          () {
                                                                             productController.productsearchResponseList[index]['cartQauntity']= productController.productsearchResponseList[index]['cartQauntity']+1;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            : ElevatedButton(
                                                                onPressed: () {
                                                                  productController.increasequantity(
                                                                      this.id!,
                                                                      productController.productsearchResponseList[index]['id'],
                                                                      this.add);
                                                                  setState(() {
                                                                    productController
                                                                        .productsearchResponseList[index]['cartQauntity'] =1;
                                                                    productController
                                                                        .productsearchResponseList[index]['added'] = true;
                                                                  });
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                child: Text(
                                                                    "Add to Cart"),
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
          floatingActionButton: AnimatedOpacity(
           duration: Duration(milliseconds: 1000), 
           opacity: 1.0,
           child: FloatingActionButton( 
              onPressed: () {  
                 Get.to(() => CartScreen());
              },
              child: Icon(Icons.shopping_bag_outlined),
              backgroundColor: Colors.black,
           ), 
         ),);
  }
}
