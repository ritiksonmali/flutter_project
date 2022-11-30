import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';

import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/OrderController.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // final OrderController orderController = Get.put(OrderController());

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
          "Order History",style:TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),),
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
            GetX<OrderController>(
                init: OrderController(),
                builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.orders.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var order = controller.orders[index];
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
                                      style: TextStyle( fontSize: 20,
                                           fontWeight: FontWeight.w500,),
                                        ),
                                        
                                        Text(
                                          order.orderStatus.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: order.orderStatus !=
                                                      "DELIVERED"
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                        
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                        itemCount: controller
                                            .orders[index].orderItem.length,
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context,
                                            int position) {
                                          var orderItems = controller
                                              .orders[index]
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
                                                            orderItems.product
                                                                    .name
                                                                    .toString() +
                                                                " " +
                                                                "× " +
                                                                orderItems
                                                                    .quantity
                                                                    .toString(),
                                                            // currentOrderList[index]['name'],
                                                            style:Theme.of(context).textTheme.bodyMedium,
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
                                          "Total : \₹" +
                                              order.totalprice.toString(),
                                          style: TextStyle( fontSize: 20,
                                           fontWeight: FontWeight.w500,),
                                          
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            order.orderStatus == "INPROGRESS"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        controller
                                                            .setOrderCancelled(
                                                                order.id);
                                                        await Future.delayed(
                                                            Duration(
                                                                seconds: 2));
                                                        setState(() {
                                                          controller.orders
                                                              .clear();
                                                          controller.onReady();
                                                        });
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor: black,
                                                      ),
                                                      child: Text("Cancel"),
                                                    ),
                                                  )
                                                : Text(''),
                                            ElevatedButton(
                                              onPressed: () {
                                                controller.update();
                                                Get.to(
                                                    () => OrderDetailsScreen(),
                                                    popGesture: true,
                                                    arguments: {
                                                      'orderItem': controller
                                                          .orders[index]
                                                          .orderItem,
                                                      'orderId': controller
                                                          .orders[index].id,
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
                                                          order
                                                              .address.country +
                                                          "\n" +
                                                          order.address.mobileNo
                                                              .toString(),
                                                      'totalPrice': order
                                                          .totalprice
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.createdDate != null
                                              ? DateFormat('dd-MM-yyyy hh:mm a')
                                                  .format(order.createdDate)
                                              : "",
                                              style:Theme.of(context).textTheme.bodyMedium,
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

  List orders = [];

  Future getAllOrdersByUser(int userId) async {
    String url = 'http://158.85.243.11:8082/getOrderDetailsbyuser/${userId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    return body;
  }
}
