import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AllOrdersForDeliveryManager.dart';
import 'package:flutter_login_app/Controller/OrderController.dart';
import 'package:flutter_login_app/Pages/Order/OrderDatailsDeliveryManager.dart';
import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreenDeliveryManager extends StatefulWidget {
  const OrderScreenDeliveryManager({Key? key}) : super(key: key);

  @override
  State<OrderScreenDeliveryManager> createState() =>
      _OrderScreenDeliveryManagerState();
}

class _OrderScreenDeliveryManagerState
    extends State<OrderScreenDeliveryManager> {
  AllOrdersForDeliveryManager allOrdersForDeliveryManager =
      Get.put(AllOrdersForDeliveryManager());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  Future<void> test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    // getAllOrdersByUser(id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delivery",
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
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            GetBuilder<AllOrdersForDeliveryManager>(
                // init: AllOrdersForDeliveryManager(),
                builder: (controller) {
              return ListView.builder(
                  itemCount: allOrdersForDeliveryManager.allOrders.length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var order = allOrdersForDeliveryManager.allOrders[index];
                    return FadeIn(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColor.secondary.withOpacity(0.05)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "#Order Id: " + order.id.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      order.orderStatus.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              order.orderStatus != "DELIVERED"
                                                  ? Colors.red
                                                  : Colors.green),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    itemCount: allOrdersForDeliveryManager
                                        .allOrders[index].orderItem.length,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int position) {
                                      var orderItems =
                                          allOrdersForDeliveryManager
                                              .allOrders[index]
                                              .orderItem[position];
                                      return Row(
                                        children: [
                                          Container(
                                            width: size.width * 0.6,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        orderItems.product.name
                                                                .toString() +
                                                            " " +
                                                            "?? " +
                                                            orderItems.quantity
                                                                .toString(),
                                                        // currentOrderList[index]['name'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total : \???" +
                                          order.totalprice.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // order.orderStatus == "INPROGRESS"
                                        //     ? Padding(
                                        //         padding:
                                        //             const EdgeInsets.only(
                                        //                 right: 8.0),
                                        //         child: ElevatedButton(
                                        //           onPressed: () async {},
                                        //           style:
                                        //               TextButton.styleFrom(
                                        //             backgroundColor: black,
                                        //           ),
                                        //           child: Text("Delivered"),
                                        //         ),
                                        //       )
                                        //     : Text(''),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.to(
                                                () =>
                                                    OrderDetailsDeliveryManager(),
                                                popGesture: true,
                                                arguments: {
                                                  'orderItem':
                                                      allOrdersForDeliveryManager
                                                          .allOrders[index]
                                                          .orderItem,
                                                  'orderStatus':
                                                      allOrdersForDeliveryManager
                                                          .allOrders[index]
                                                          .orderStatus,
                                                  'orderId':
                                                      allOrdersForDeliveryManager
                                                          .allOrders[index].id,
                                                  'address': order.address
                                                          .addressLine1 +
                                                      "\n" +
                                                      order.address
                                                          .addressLine2 +
                                                      "-" +
                                                      order.address.pincode
                                                          .toString() +
                                                      "\n" +
                                                      order.address.city +
                                                      "\n" +
                                                      order.address.state +
                                                      " " +
                                                      order.address.country +
                                                      "\n" +
                                                      order.address.mobileNo
                                                          .toString(),
                                                  'totalPrice': order.totalprice
                                                      .toString()
                                                });
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: black,
                                          ),
                                          child: Text("Details"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.createdDate != null
                                          ? DateFormat('dd-MM-yyyy hh:mm a')
                                              .format(order.createdDate)
                                          : "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }
}
