import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ConstantUtil/colors.dart';
import '../../ConstantUtil/globals.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);
  // static const routeName = '/checkout';

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  var total;
  double gst = 0;
  double finalPrice = 0;
  bool isLoading = true;

  var orderId = Get.arguments;
  bool isAvoidRingingBell = false;
  bool isLeaveAtTheDoor = false;
  bool isAvoidCalling = false;
  bool isLeaveWithSecurity = false;
  String isdeliveryInstruction = '';

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: white),
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryGreen,
        centerTitle: true,
        title: Text(
          "Order Details",
          style: Theme.of(context).textTheme.headline5!.apply(color: white),
        ),
      ),
      body: isLoading == true
          ? Container(
              color: grey,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: grey,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    SafeArea(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Address",
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 00),
                                child: SizedBox(
                                  width: 230,
                                  child: Text(orderId['address'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isAvoidRingingBell == false &&
                                isLeaveAtTheDoor == false &&
                                isAvoidCalling == false &&
                                isLeaveWithSecurity == false &&
                                isdeliveryInstruction == ''
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, top: 15),
                                child: Text("Delivery Instructions",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        isAvoidRingingBell
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  width: width,
                                  // height: height * 0.06,
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color: black.withOpacity(0.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.notifications_active,
                                          size: height * 0.02,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Avoid ringing bell',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        isLeaveAtTheDoor
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  width: width,
                                  // height: height * 0.06,
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color: black.withOpacity(0.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.door_front_door,
                                          size: height * 0.02,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Leave at the door',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        isdeliveryInstruction != ""
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  width: width,
                                  // height: height * 0.06,
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color: black.withOpacity(0.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.directions,
                                          size: height * 0.02,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            isdeliveryInstruction,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        isAvoidCalling
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  width: width,
                                  // height: height * 0.06,
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color: black.withOpacity(0.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.call,
                                          size: height * 0.02,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Avoid Calling',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        isLeaveWithSecurity
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  width: width,
                                  // height: height * 0.06,
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color: black.withOpacity(0.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.security,
                                          size: height * 0.02,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Leave with Security",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Order Summary",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                    onPressed: () {
                                      // Get.to(() => OrderPage());
                                    },
                                    child: Row(
                                      children: const [],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Text(
                                    "Product Name",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Text(
                                    "Quantity",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Text(
                                    "Price",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                            children:
                                List.generate(selectedOrder.length, (index) {
                          var productdata = selectedOrder[index];
                          total = selectedOrder.length > 0
                              ? selectedOrder
                                  .map<int>((m) =>
                                      m['product']['price'] * m['quantity'])
                                  .reduce((value, element) => value + element)
                              : 0;
                          int? totalPrice = int.tryParse(total.toString());
                          gst = ((totalPrice! * 0.18));
                          finalPrice = gst + totalPrice + 10;
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                    child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: grey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 1,
                                                color: black.withOpacity(0.1),
                                                blurRadius: 2)
                                          ]),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 10,
                                                  child: Text(
                                                    productdata['product']
                                                            ['name']
                                                        .toString(),
                                                    // "\$ " + products[index]['price'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: Text(
                                                    productdata['quantity']
                                                        .toString(),
                                                    // "\$ " + products[index]['price'],
                                                    // style: Theme.of(context).textTheme.bodyMedium,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: Text(
                                                    productdata['product']
                                                            ['price']
                                                        .toString()
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          );
                        })),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 15,
                          width: double.infinity,
                          color: grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Sub Total",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text("₹$total",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery Cost",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text("\₹10",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Gst(18%)",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text("\₹${gst.toStringAsFixed(2)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            orderId['priceCutFromWallet'] != 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Wallet Amount",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      Text(
                                          "\- ₹${orderId['priceCutFromWallet']}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              height: 10,
                              color: Color.fromARGB(255, 137, 136, 136),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Text(
                                    "\₹${(finalPrice - orderId['priceCutFromWallet']).abs().toStringAsFixed(2)}",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        Container(
                          height: 10,
                          width: double.infinity,
                          color: grey,
                        ),
                      ],
                    )),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   child: NavBar(),
                    // )
                  ],
                ),
              ),
            ),
    );
  }

  apiCall() async {
    var SelectedOrderFromAPi = await getOrderDetails(orderId['orderId']);
    setState(() {
      selectedOrder = SelectedOrderFromAPi;
      isLoading = false;
    });
  }

  List selectedOrder = [];

  Future getOrderDetails(orderId) async {
    String url = '${serverUrl}getOrderDetailsbyid/$orderId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    setState(() {
      isAvoidRingingBell = body['avoidRinging'] ?? false;
      isLeaveAtTheDoor = body['leaveAtDoor'] ?? false;
      isAvoidCalling = body['avoidCalling'] ?? false;
      isLeaveWithSecurity = body['leaveWithSecurity'] ?? false;
      isdeliveryInstruction = body['deliveryInstructions'] ?? '';
    });
    return body['orderItem'];
  }
}
