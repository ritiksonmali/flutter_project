import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/Orders.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../ConstantUtil/colors.dart';
import '../../utils/helper.dart';
import '../Address/AddressDetails.dart';
import '../Home/home_screen.dart';
import '../sucessOrder/OrderPlaced.dart';
import '../sucessOrder/orderFail.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  // static const routeName = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late var _razorpay;
  var amountController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("paymentId");
    print(response.paymentId);
    print(response.toString());
    print("Payment Done");
    Get.to(OrderPlacedScreen());

    // paymentId payment Status orderId
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Fail");
    print(response.toString());
    Get.to(OrderfailScreen());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Stack(
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
                child: Text(
                  "Delivery Address",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                  ),
                ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 00),
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          "538 sagar park laxmi Nagar Panchavati Nashik-422003",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => AddressDetails());
                          },
                          child: Text("change",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold))),
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
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Summary",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => OrderPage());
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
                child: Container(
                  //color: Colors.grey,
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 236, 233, 233),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromARGB(255, 240, 240, 240)
                                .withOpacity(0.25),
                          ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cash on delivery "),
                      Container(
                        width: 15,
                        height: 15,
                        //  child: IconButton(
                        //     icon: const Icon(Icons.sel),
                        //     color: Colors.black,
                        //        onPressed: () {},
                        //     ),

                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  //color: Colors.grey,
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 236, 233, 233),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromARGB(255, 240, 240, 240)
                                .withOpacity(0.25),
                          ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Online Payment"),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 15,
                width: double.infinity,
                color: Colors.grey[200],
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
                      Text(
                        "Sub Total",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "\$78",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Cost",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "\$12",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "-\$10",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
                      Text(
                        "Total",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "\$80",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
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
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: CupertinoButton(
                    child: Text("Place Order"),
                    color: Colors.black,
                    onPressed: () {
                      ///Make payment
                      var options = {
                        'key': "rzp_test_BHAChutrVpoEpO",
                        // amount will be multiple of 100
                        'amount': 5000, //So its pay 500
                        'name': 'Piyush pagar',
                        'description': 'Demo',
                        'timeout': 300, // in seconds
                        'prefill': {
                          'contact': '8830218670',
                          'email': 'piyush@gmail.com'
                        }
                      };
                      _razorpay.open(options);
                    },
                  ),
                ),
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
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }
}
