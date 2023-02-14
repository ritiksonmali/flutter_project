import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/OrderDetailsController.dart';
import 'package:flutter_login_app/Pages/Order/Order_json.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantUtil/colors.dart';
import '../../ConstantUtil/globals.dart';
import '../../utils/helper.dart';
import '../Address/AddressDetails.dart';
import '../Home/home_screen.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    // double? total = double.tryParse(orderId['totalPrice']);
    // print(total);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   orderDetailsController.getOrderDetails(orderId['orderId']);
    // });
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        automaticallyImplyLeading: true,
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Order Details",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  SafeArea(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Address",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      SizedBox(
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
                                    // "538 sagar park laxmi Nagar Panchavati Nashik-422003",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 15,
                        width: double.infinity,
                        color: grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order Summary",
                                style: Theme.of(context).textTheme.titleLarge),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextButton(
                                  onPressed: () {
                                    // Get.to(() => OrderPage());
                                  },
                                  child: Row(
                                    children: [
                                      // Icon(Icons.add),
                                      // Text("Add Cart",
                                      // style:
                                      //   TextStyle(
                                      //     fontSize: 15,
                                      //     fontWeight: FontWeight.bold)
                                      //     ),
                                    ],
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
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  "Quantity",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  "Price",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
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
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              color: black.withOpacity(0.1),
                                              blurRadius: 2)
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 10,
                                                child: Text(
                                                  productdata['product']['name']
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 15,
                        width: double.infinity,
                        color: grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sub Total",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text("\₹${total}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery Cost",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text("\₹10",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Gst(18%)",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text("\₹${gst.toStringAsFixed(2)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          SizedBox(
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
                                    Text("\- ₹${orderId['priceCutFromWallet']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 10,
                            color: Color.fromARGB(255, 137, 136, 136),
                          ),
                          SizedBox(
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
                          SizedBox(
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
    String url = serverUrl + 'getOrderDetailsbyid/${orderId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    print(body);
    return body['orderItem'];
  }
}
