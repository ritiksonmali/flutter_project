import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/CategoryProductController.dart';
import 'package:flutter_login_app/Pages/Home/Search.dart';
import 'package:flutter_login_app/Pages/Order/ItemData.dart';
import 'package:get/get.dart';

class CategoryProductList extends StatefulWidget {
  const CategoryProductList({Key? key}) : super(key: key);

  @override
  State<CategoryProductList> createState() => _CategoryProductListState();
}

class _CategoryProductListState extends State<CategoryProductList> {
  final CategoryProductcontroller cpcontrol =
      Get.put(CategoryProductcontroller());
  @override
  Widget build(BuildContext context) {
    var categoryId = Get.arguments;
    print(categoryId);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cpcontrol.getDetails(categoryId['categoryId']);
    });
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
                  Get.to(() => SearchPage());
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
        Expanded(child: GetBuilder<CategoryProductcontroller>(
          builder: (controller) {
            return ListView.builder(
                itemCount: cpcontrol.products.length,
                itemBuilder: (context, index) {
                  var product = cpcontrol.products[index];
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
                                    'http://10.0.2.2:8082/api/auth/serveproducts/${product.imageUrl.toString()}')
                                // image: AssetImage("assets/shoe_1.webp"),
                                ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    product.price.toString(),
                                    // "49999rs",
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    product.price.toString() +
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
                                    product.desc.toString(),
                                    // "Discription",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "only stock" +
                                        product.inventory.quantity.toString(),
                                    // "only stock 5",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  // CounterButton(
                                  //           loading: false,
                                  //            onChange: (int val) {
                                  //                  setState(() {
                                  //                    = val;
                                  //               });
                                  //             },
                                  //           count: _counterValue,
                                  //              countColor: Colors.purple,
                                  //              buttonColor: Colors.purpleAccent,
                                  //              progressColor: Colors.purpleAccent,
                                  //    ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                        onTap: () {
                                          print(index);
                                          // print(productinfo[index].toString());
                                          // print(productinfo[index].toString());
                                          // print(productinfo[index]);
                                          print('1');
                                          // print(productUnit[index].toString());
                                          // print(productImage[index].toString());
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                          ),
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              itemData[index].ShouldVisible
                                                  ? Center(
                                                      child: Container(
                                                      height: 30,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white70)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (itemData[
                                                                              index]
                                                                          .Counter <
                                                                      2) {
                                                                    itemData[
                                                                            index]
                                                                        .ShouldVisible = !itemData[
                                                                            index]
                                                                        .ShouldVisible;
                                                                  } else {
                                                                    itemData[
                                                                            index]
                                                                        .Counter--;
                                                                  }
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .green,
                                                                size: 18,
                                                              )),
                                                          Text(
                                                            '${itemData[index].Counter}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  itemData[
                                                                          index]
                                                                      .Counter++;
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .green,
                                                                size: 18,
                                                              )),
                                                        ],
                                                      ),
                                                    ))
                                                  : Center(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        height: 30,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white70)),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  itemData[
                                                                          index]
                                                                      .ShouldVisible = !itemData[
                                                                          index]
                                                                      .ShouldVisible;
                                                                });
                                                              },
                                                              child: Text(
                                                                'ADD',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white70),
                                                              ),
                                                            ),
                                                            // InkWell(
                                                            //     onTap: () {
                                                            //       setState(() {
                                                            //         itemData[
                                                            //                 index]
                                                            //             .ShouldVisible = !itemData[
                                                            //                 index]
                                                            //             .ShouldVisible;
                                                            //       });
                                                            //     },
                                                            //     child: Center(
                                                            //         child: Icon(
                                                            //       Icons.add,
                                                            //       color: Colors
                                                            //           .green,
                                                            //       size: 18,
                                                            //     )))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              // Padding(
                                              //   padding: EdgeInsets.zero,
                                              //   child: IconButton(
                                              //     icon: Icon(Icons.remove,
                                              //         color: Colors.white),
                                              //     onPressed: () {

                                              //       Get.to(() => SearchPage());
                                              //     },
                                              //   ),
                                              // ),
                                              //  Obx(()=>Text("${myProductController.},
                                              // Text(
                                              //   "1",
                                              //   style: TextStyle(
                                              //       color: Colors.white),
                                              // ),
                                              // Padding(
                                              //   padding: EdgeInsets.zero,
                                              //   child: IconButton(
                                              //     icon: Icon(Icons.add,
                                              //         color: Colors.white),
                                              //     onPressed: () {
                                              //       Get.to(() => SearchPage());
                                              //     },
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                });
          },
        ))
      ]),
    );
  }
}
