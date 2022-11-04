import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/Pages/Order/Order_json.dart';
import 'package:flutter_login_app/Pages/Order/colors.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future getAllProducts(int userId) async {
    String url =
        'http://10.0.2.2:8082/api/auth/fetchlistofproductbyfilter?pagenum=0&pagesize=10&status=active';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar:
          PreferredSize(child: getAppBar(), preferredSize: Size.fromHeight(60)),
      body: getBody(),
      // bottomNavigationBar: getFooter(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      title: Text(
        "Your Orders",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          getTabs(),
          SizedBox(
            height: 30,
          ),
          pageIndex == 0 ? getListCurrentOrders() : getListPastOrders()
        ],
      ),
    );
  }

  Widget getTabs() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: secondary.withOpacity(0.05)),
      child: Row(children: [
        pageIndex == 0
            ? Flexible(
                child: ElasticIn(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: (size.width - 45) / 2,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                  color: secondary.withOpacity(0.15),
                                  blurRadius: 5,
                                  offset: Offset(0, 5))
                            ]),
                        child: Center(
                          child: Text(
                            "Current Orders",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      width: (size.width - 45) / 2,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Current Orders",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: secondary.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        pageIndex == 1
            ? Flexible(
                child: ElasticIn(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: (size.width - 45) / 2,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                  color: secondary.withOpacity(0.15),
                                  blurRadius: 5,
                                  offset: Offset(0, 5))
                            ]),
                        child: Center(
                          child: Text(
                            "Past Orders",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      width: (size.width - 45) / 2,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Past Orders",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: secondary.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ]),
    );
  }

  Widget getListCurrentOrders() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: List.generate(pastOrderList.length, (index) {
        return FadeIn(
          duration: Duration(milliseconds: 1000 * index),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: secondary.withOpacity(0.05)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pastOrderList[index]['date'],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Delivered",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.orangeAccent),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.6,
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   pastOrderList[index]['name'] +
                                    //       "×" +
                                    //       pastOrderList[index]['rate'],
                                    //   style: TextStyle(fontSize: 16),
                                    //   maxLines: 10,
                                    // ),
                                    ListView.builder(
                                        itemCount: 10,
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Text(
                                              "product name " + "×" + "1");
                                        }),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "\$",
                                    //       style: TextStyle(
                                    //           color: red,
                                    //           fontSize: 16,
                                    //           fontWeight: FontWeight.w500),
                                    //     ),
                                    //     // Text(
                                    //     //   pastOrderList[index]['price'],
                                    //     //   style: TextStyle(
                                    //     //       fontSize: 16,
                                    //     //       fontWeight: FontWeight.w600),
                                    //     // ),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Flexible(
                        //     child: Row(
                        //   children: [
                        //     Container(
                        //       width: 1,
                        //       height: 60,
                        //       decoration: BoxDecoration(
                        //           color: secondary.withOpacity(0.15)),
                        //     ),
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           "Total Items: 1",
                        //           style: TextStyle(fontSize: 13),
                        //         ),
                        //         Text(
                        //           pastOrderList[index]['time'],
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: secondary.withOpacity(0.5)),
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pastOrderList[index]['price'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => OrderDetailsScreen());
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          child: Text("Details"),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 30),
                    //       child: Container(
                    //         width: 100,
                    //         height: 40,
                    //         decoration: BoxDecoration(
                    //             color: secondary,
                    //             borderRadius: BorderRadius.circular(12)),
                    //         child: Center(
                    //           child: Text(
                    //             "Reorder",
                    //             style: TextStyle(
                    //                 color: white,
                    //                 fontSize: 17,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget getListPastOrders() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: List.generate(pastOrderList.length, (index) {
        return FadeIn(
          duration: Duration(milliseconds: 1000 * index),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: secondary.withOpacity(0.05)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pastOrderList[index]['date'],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Delivered",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.orangeAccent),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.6,
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   pastOrderList[index]['name'] +
                                    //       "×" +
                                    //       pastOrderList[index]['rate'],
                                    //   style: TextStyle(fontSize: 16),
                                    //   maxLines: 10,
                                    // ),
                                    ListView.builder(
                                        itemCount: 10,
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Text(
                                              "product name " + "×" + "1");
                                        }),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "\$",
                                    //       style: TextStyle(
                                    //           color: red,
                                    //           fontSize: 16,
                                    //           fontWeight: FontWeight.w500),
                                    //     ),
                                    //     // Text(
                                    //     //   pastOrderList[index]['price'],
                                    //     //   style: TextStyle(
                                    //     //       fontSize: 16,
                                    //     //       fontWeight: FontWeight.w600),
                                    //     // ),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Flexible(
                        //     child: Row(
                        //   children: [
                        //     Container(
                        //       width: 1,
                        //       height: 60,
                        //       decoration: BoxDecoration(
                        //           color: secondary.withOpacity(0.15)),
                        //     ),
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           "Total Items: 1",
                        //           style: TextStyle(fontSize: 13),
                        //         ),
                        //         Text(
                        //           pastOrderList[index]['time'],
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: secondary.withOpacity(0.5)),
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pastOrderList[index]['price'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => OrderDetailsScreen());
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          child: Text("Details"),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 30),
                    //       child: Container(
                    //         width: 100,
                    //         height: 40,
                    //         decoration: BoxDecoration(
                    //             color: secondary,
                    //             borderRadius: BorderRadius.circular(12)),
                    //         child: Center(
                    //           child: Text(
                    //             "Reorder",
                    //             style: TextStyle(
                    //                 color: white,
                    //                 fontSize: 17,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Widget getFooter() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
  //     child: Container(
  //       width: double.infinity,
  //       height: 55,
  //       decoration: BoxDecoration(
  //           color: secondary, borderRadius: BorderRadius.circular(12)),
  //       child: Center(
  //         child: Text(
  //           "Reorder",
  //           style: TextStyle(
  //               color: white, fontSize: 17, fontWeight: FontWeight.w500),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
