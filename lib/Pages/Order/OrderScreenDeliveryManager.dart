import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/AllOrdersForDeliveryManager.dart';
import 'package:flutter_login_app/Controller/OrderController.dart';
import 'package:flutter_login_app/Pages/Order/OrderDatailsDeliveryManager.dart';
import 'package:flutter_login_app/model/OrderHistory.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class OrderScreenDeliveryManager extends StatefulWidget {
  const OrderScreenDeliveryManager({Key? key}) : super(key: key);

  @override
  State<OrderScreenDeliveryManager> createState() =>
      _OrderScreenDeliveryManagerState();
}

class _OrderScreenDeliveryManagerState
    extends State<OrderScreenDeliveryManager> {
  final OrderController orderController = Get.put(OrderController());
  int counter = 1;
  int _page = 0;

  int _limit = 5;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  late final ScrollController _controller = ScrollController();

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      print('loading called');
      _page += 1;
      try {
        var store = await SharedPreferences.getInstance();
        var iddata = store.getString('id');
        int userId = jsonDecode(iddata!);
        String url =
            '${serverUrl}fetchOrderListfilter?pagenum=$_page&pagesize=$_limit&orderStatus=INPROGRESS&sorting=dateTime&isDesc=true';
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );
        var body = jsonDecode(response.body);
        List records = body['records'];
        if (records.isNotEmpty) {
          setState(() {
            for (Map i in body['records']) {
              orderController.orders.add(OrderHistory.fromJson(i));
            }
          });
        } else {
          setState(() {
            _hasNextPage = false;
            Fluttertoast.showToast(
                msg: "You have Fetched all The records",
                backgroundColor: Colors.black87);
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    orderController.getAllOrders().then((value) {
      setState(() {
        _isFirstLoadRunning = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    test();
    // orderController.getAllOrdersByUser();
    _firstLoad();
    _controller.addListener(_loadMore);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   test();
  //   orderController.getAllOrders();
  // }

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
      backgroundColor: grey,
      appBar: AppBar(
        title: Text("Delivery",
            style: Theme.of(context).textTheme.headline5!.apply(color: white)),
        centerTitle: true,
        backgroundColor: kPrimaryGreen,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu),
            onPressed: () {
              Get.to(() => const Navbar());
            }, //=> _key.currentState!.openDrawer(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            GetX<OrderController>(
                // init: AllOrdersForDeliveryManager(),
                builder: (controller) {
              return controller.isLoading.value
                  ? ListView.builder(
                      itemCount: 5,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width * 0.7,
                                      height: 20,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: size.width,
                                      height: 100,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: size.width,
                                      height: 20,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : controller.orders.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 300,
                            ),
                            Center(
                              child: Text(
                                'Orders Not Found',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: orderController.orders.length,
                          physics: const ClampingScrollPhysics(),
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
                                      color:
                                          AppColor.secondary.withOpacity(0.05)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "#Order Id: ${order.id}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.builder(
                                            itemCount: orderController
                                                .orders[index].orderItem.length,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int position) {
                                              var orderItems = orderController
                                                  .orders[index]
                                                  .orderItem[position];
                                              return Row(
                                                children: [
                                                  Container(
                                                    width: size.width * 0.6,
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
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
                                                                "${orderItems.product.name} × ${orderItems.quantity}",
                                                                // currentOrderList[index]['name'],
                                                                style: Theme.of(
                                                                        context)
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
                                              "Total : \₹${order.totalprice + order.priceCutFromWallet}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => OrderDetailsDeliveryManager(
                                                              address:
                                                                  "${order.addressResponse.addressLine1}\n${order.addressResponse.addressLine2}-${order.addressResponse.pincode}\n${order.addressResponse.city}\n${order.addressResponse.state} ${order.addressResponse.country}",
                                                              orderStatus:
                                                                  orderController
                                                                      .orders[
                                                                          index]
                                                                      .orderStatus,
                                                              orderId:
                                                                  orderController
                                                                      .orders[
                                                                          index]
                                                                      .id)),
                                                    ).then((_) {
                                                      setState(() {
                                                        orderController.orders
                                                            .clear();
                                                        _hasNextPage = true;
                                                        counter = 1;
                                                        _page = 0;
                                                        _limit = 5;
                                                        _firstLoad();
                                                        _controller.addListener(
                                                            _loadMore);
                                                      });
                                                    });
                                                    // Get.to(
                                                    //     () =>
                                                    //         const OrderDetailsDeliveryManager(),
                                                    //     popGesture: true,
                                                    //     arguments: {
                                                    //       'orderItem':
                                                    //           orderController
                                                    //               .orders[index]
                                                    //               .orderItem,
                                                    //       'orderStatus':
                                                    //           orderController
                                                    //               .orders[index]
                                                    //               .orderStatus,
                                                    //       'orderId':
                                                    //           orderController
                                                    //               .orders[index]
                                                    //               .id,
                                                    //       'address':
                                                    //           "${order.addressResponse.addressLine1}\n${order.addressResponse.addressLine2}-${order.addressResponse.pincode}\n${order.addressResponse.city}\n${order.addressResponse.state} ${order.addressResponse.country}",
                                                    //       'totalPrice': order
                                                    //           .totalprice
                                                    //           .toString()
                                                    //     });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        buttonColour,
                                                  ),
                                                  child: const Text("Details"),
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
                                                  ? DateFormat(
                                                          'dd-MM-yyyy hh:mm a')
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
            if (_isLoadMoreRunning == true)
              ListView.builder(
                  itemCount: 5,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.7,
                                  height: 20,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: size.width,
                                  height: 100,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: size.width,
                                  height: 20,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
          ],
        ),
      ),
    );
  }
}
