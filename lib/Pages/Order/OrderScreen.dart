import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/Pages/Order/colors.dart';
import 'package:get/get.dart';

import '../../Controller/OrderController.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: GetX<OrderController>(builder: (controller) {
        return ListView.builder(
            itemCount: orderController.orders.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var order = orderController.orders[index];
              return FadeIn(
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
                                order.id.toString(),
                                // currentOrderList[index]['date'],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                order.orderStatus.toString(),
                                // "Delivery Processing",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              itemCount: orderController
                                  .orders[index].orderItem.length,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                var orderItems = orderController
                                    .orders[index].orderItem[position];
                                return Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.6,
                                      child: Row(
                                        children: [
                                          // Container(
                                          //   width: 90,
                                          //   height: 90,
                                          //   child: Stack(
                                          //     children: [
                                          //       Positioned(
                                          //         top: 10,
                                          //         child: Container(
                                          //           width: 80,
                                          //           height: 80,
                                          //           decoration: BoxDecoration(
                                          //               borderRadius:
                                          //                   BorderRadius.circular(8),
                                          //               border: Border.all(
                                          //                   color:
                                          //                       secondary.withOpacity(0.1)),
                                          //               color: white),
                                          //         ),
                                          //       ),
                                          //       Container(
                                          //         width: 80,
                                          //         height: 80,
                                          //         decoration: BoxDecoration(
                                          //             image: DecorationImage(
                                          //                 image: AssetImage(
                                          //                     currentOrderList[index]
                                          //                         ['image']),
                                          //                 fit: BoxFit.cover)),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  orderItems.product.name
                                                      .toString(),
                                                  // currentOrderList[index]['name'],
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                  maxLines: 2,
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Text(
                                                //       "\$",
                                                //       style: TextStyle(
                                                //           color: red,
                                                //           fontSize: 16,
                                                //           fontWeight:
                                                //               FontWeight.w500),
                                                //     ),
                                                //     Text(
                                                //       orderItems.product!.price
                                                //           .toString(),
                                                //       // currentOrderList[index]['price'],
                                                //       style: TextStyle(
                                                //           fontSize: 16,
                                                //           fontWeight:
                                                //               FontWeight.w600),
                                                //     ),
                                                //   ],
                                                // )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          // Container(
                                          //   width: 1,
                                          //   height: 60,
                                          //   decoration: BoxDecoration(
                                          //       color: secondary
                                          //           .withOpacity(0.15)),
                                          // ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Items: " +
                                                    orderItems.quantity
                                                        .toString(),
                                                // "Total Items: 1",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              // Text(
                                              //   orderItems.createdDate
                                              //       .toString(),
                                              //   // currentOrderList[index]['time'],
                                              //   style: TextStyle(
                                              //       fontSize: 12,
                                              //       color: secondary
                                              //           .withOpacity(0.5)),
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total : " + order.totalprice.toString(),
                                // pastOrderList[index]['price'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => OrderDetailsScreen(),
                                      arguments: {'orderId': order.id.toInt()});
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                ),
                                child: Text("Details"),
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
    );
  }
}
