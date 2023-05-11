// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Pages/Order/OrdersForWallet.dart';
import 'package:flutter_login_app/Pages/Wallet/PaymentFailed.dart';
import 'package:flutter_login_app/Pages/Wallet/PaymentSuccessful.dart';
import 'package:flutter_login_app/Pages/Wallet/Walletjson.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _formKey6 = GlobalKey<FormState>();
  var _razorpay;
  var total;
  var order_id;
  var orderDetailResponse;
  int finalValue = 0;
  double WalletAmount = 0.0;
  bool isLoading = true;
  var argument = Get.arguments;
  int? userId;

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    test();
    if (argument != null) {
      setState(() {
        amountController.text = argument['amountNeeded'].toString();
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setPaymentDetailsForWallet(response.paymentId.toString(),
        "SUCCESS".toString(), orderDetailResponse['orderId'].toString());
    // print("paymentId");
    // print(response.paymentId);
    // print(response.signature);
    // print(response.orderId);
    // print("Payment Done");
    Get.to(() => const PaymentSuessfulScreen());

    // paymentId payment Status orderId
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setPaymentDetailsForWallet(
        "0", "FAILED", orderDetailResponse['orderId'].toString());
    print("Payment Fail");
    print(response.toString());
    Get.to(() => const PaymentFailedScreen());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    getWalletByUser(id);
    setState(() {
      userId = id;
    });
  }

  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Wallet",
          style: Theme.of(context).textTheme.headline5!.apply(color: white),
        ),
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
      ),
      body: isLoading
          ? Container(
              color: grey,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            "\₹ ${WalletAmount.toStringAsFixed(2)}",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .apply(color: black),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Current Balance",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(
                                    color: WalletAmount == 0
                                        ? kAlertColor
                                        : kLightGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Topup Wallet',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey6,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: TextFormField(
                        controller: amountController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Colors.black87,
                        style: const TextStyle(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 5, top: 0, bottom: 0, right: 5),
                          // filled: true,
                          label: RichText(
                            text: const TextSpan(
                                text: 'Enter Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: kAlertColor,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                          // labelText: 'Enter Amount',
                          prefixIcon: const Icon(Icons.currency_rupee),
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Amount';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'Recommended',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: recordlist.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            var record = recordlist[index];
                            return Hero(
                              tag: "anim$index",
                              child: GestureDetector(
                                onTap: () async {
                                  int value = jsonDecode(record['name']);
                                  setState(() {
                                    amountController.text = value.toString();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 8, left: 12, top: 1, bottom: 0),
                                  decoration: BoxDecoration(
                                      // color: Colors.black54,
                                      border: Border.all(color: black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(2)),
                                      boxShadow: const []),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      "₹ ${record['name']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: black),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(12, 10, 12, 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(90)),
                    child: ElevatedButton(
                      onPressed: () {
                        checkValidations();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return buttonColour;
                            }
                            return buttonColour;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                      child: const Text(
                        'Proceed To Topup',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const OrdersForWallet());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          color: kGreyShade1,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                                // color: Colors.grey[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              FontAwesomeIcons.exchange,
                              color: white,
                              size: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Wallet Transaction History",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .apply(color: white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                // color: Colors.grey[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: white,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  checkValidations() {
    if (_formKey6.currentState!.validate()) {
      print("Form is valid ");
      _formKey6.currentState!.save();
      createNewOrderForWallet();
    } else {
      print('Form is Not Valid');
    }
  }

  Future createNewOrderForWallet() async {
    String url =
        '${serverUrl}createOrderForWallet?amount=${amountController.text}&userId=$userId';
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      orderDetailResponse = jsonDecode(response.body);
      order_id = (orderDetailResponse['orderId']);
      print(orderDetailResponse['totalPrice']);
      String orderdata = orderDetailResponse['orderId'];
      var options = {
        'key': "rzp_test_BHAChutrVpoEpO",
        'amount': orderDetailResponse['totalPrice'] * 100,
        'name': 'Piyush pagar',
        'description': orderdata, // in seconds
        'prefill': {
          'contact': '8530838580',
          'email': 'sonmalirutik001@gmail.com'
        },
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
      return orderDetailResponse;
    }
  }

  Future setPaymentDetailsForWallet(
      String paymentId, String paymentStatus, String orderId) async {
    String url = '${serverUrl}setOrderPaymentStatusForWallet';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "orderId": orderId,
          "paymentId": paymentId,
          "paymentStatus": paymentStatus
        }));
    if (response.statusCode == 200) {
      print("Success payment");
    }
  }

  Future getWalletByUser(int id) async {
    String url = '${serverUrl}api/auth/getWalletbyuser/$id';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      setState(() {
        WalletAmount = body['amount'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
    }
  }
}
