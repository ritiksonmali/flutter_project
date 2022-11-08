import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/Orders.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantUtil/colors.dart';
import '../../Controller/ProductController.dart';
import '../Address/AddressDetails.dart';
import '../sucessOrder/OrderPlaced.dart';
import '../sucessOrder/orderFail.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  // static const routeName = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ProductController productController = Get.put(ProductController());
  var _razorpay;
  var total;
  var order_id;
  var orderDetailResponse;
  // int totalprice = 0;
  double gst = 0;
  double finalPrice = 0;
  var amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    test();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    productController.setPaymentDetails(response.paymentId.toString(),
        "SUCCESS".toString(), orderDetailResponse['orderId'].toString());
    print("paymentId");
    print(response.paymentId);
    print(response.signature);
    print(response.orderId);
    print("Payment Done");
    Get.to(OrderPlacedScreen());

    // paymentId payment Status orderId
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    productController.setPaymentDetails("0", "FAILED", "si");
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
      body: SingleChildScrollView(
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
                          child: SelectedAddress == null
                              ? null
                              : Text(
                                  SelectedAddress.toString(),
                                  // "538 sagar park laxmi Nagar Panchavati Nashik-422003",
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
                            onPressed: () async {
                              final value = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressDetails()),
                              );

                              setState(() {
                                apiCall();
                              });
                            },
                            // onPressed: () {

                            //   Get.to(() => AddressDetails());
                            // },
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 10,
                          child: Text(
                            "Product Name",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.grey[800],
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            "Quantity",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.grey[800],
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            "Price",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.grey[800],
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                    children: List.generate(cartproducts.length, (index) {
                  var productdata = cartproducts[index];

                  // totalprice =
                  //     productdata['product']['price'] * productdata['quantity'];
                  // print(((totalprice + 10) * 18) / 100);

                  total = cartproducts.length > 0
                      ? cartproducts
                          .map<int>(
                              (m) => m['product']['price'] * m['quantity'])
                          .reduce((value, element) => value + element)
                      : 0;
                  int? totalPrice = int.tryParse(total.toString());
                  gst = ((totalPrice! + 10) * 18) / 100;
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
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: Text(
                                            productdata['quantity'].toString(),
                                            // "\$ " + products[index]['price'],
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: Text(
                                            productdata['product']['price']
                                                .toString(),
                                            // "\$ " + products[index]['price'],
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
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
                          "\₹${total}",
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
                          "\₹10",
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
                          "Gst(18%)",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "\₹${gst}",
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
                          "\₹${finalPrice}",
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
                        createNewOrder();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
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

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }

  List cartproducts = [];

  int? id;
  bool isSelected = true;
  String? SelectedAddress;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      this.id = id;
      apiCall();
    });
  }

  Future getCartproducts(userId) async {
    print("fatchProduct $userId");
    CommanDialog.showLoading();
    String url = 'http://10.0.2.2:8082/api/auth/getcartitems/${userId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    CommanDialog.hideLoading();
    // print(body['totalCost']);
    // print(body['cartItems']);

    return body['cartItems'];
  }

  apiCall() async {
    var allproductsfromapi = await getCartproducts(id);
    var SelectedAddressFromAPi = await getSelectedApi(id!, isSelected);
    setState(() {
      cartproducts = allproductsfromapi;
      SelectedAddress = SelectedAddressFromAPi;
    });
  }

  Future createNewOrder() async {
    String url = 'http://10.0.2.2:8082/createNewOrder';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"user_id": this.id}));

    if (response.statusCode == 200) {
      print("Success");
      print("working" + (response.body).toString());
      orderDetailResponse = jsonDecode(response.body);
      print(orderDetailResponse);
      order_id = (orderDetailResponse['orderId']);
      print(orderDetailResponse['totalPrice']);
      String orderdata = orderDetailResponse['orderId'];
      var options = {
        'key': "rzp_test_BHAChutrVpoEpO",
        'amount': orderDetailResponse['totalPrice'] * 100,
        'name': 'Piyush pagar',
        'description': orderdata, // in seconds
        'prefill': {'contact': '8830218670', 'email': 'piyush@gmail.com'},
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
      return orderDetailResponse;
    }
  }

  //  Future setPaymentDetails(String paymentId ,String paymentStatus,orderId) async {
  //   try {
  //     String url = 'http://localhost:8082/setOrderPaymentStatus';
  //     var response = await http.post(Uri.parse(url),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode({
  //           "paymentId": paymentId,
  //           "paymentStatus":paymentStatus,
  //           "orderId":orderId
  //         }));
  //           print("Success payment");
  //     if (response.statusCode == 200) {
  //       print("Success payment");
  //      print(response.body);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  getSelectedApi(int UserId, bool isSelected) async {
    try {
      String url =
          'http://10.0.2.2:8082/api/auth/getSelectedAddress/${UserId}/${isSelected}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);

      return body['address_line1'] +
          "\n" +
          body['pincode'].toString() +
          " " +
          body['city'] +
          "\n" +
          body['state'] +
          " " +
          body['country'] +
          "\n" +
          body['mobile_no'];
    } catch (e) {
      print(e.toString());
    }
  }
}
