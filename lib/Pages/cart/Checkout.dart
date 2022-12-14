import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/Pages/Order/Order_json.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantUtil/colors.dart';
import '../../ConstantUtil/globals.dart';
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
  bool? check = false;
  double WalletAmount = 0.00;
  double amountCutFromWallet = 0.00;
  double demoprice = 0.00;
  double finalPrice = 0;
  // int totalprice = 0;
  double gst = 0;

  var amountController = TextEditingController();
  String? valueChoose;

  List listItemSorting = [
    '09:00 AM',
    '02:00 PM',
    '05:00 PM',
    '08:00 PM',
  ];

  DateTime date = DateTime.now();
  late var formattedDate;

  String? CurrentDate;

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    test();
    formattedDate = DateFormat('d-MMM-yy').format(date);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    productController.setPaymentDetails(
        response.paymentId.toString(),
        "SUCCESS".toString(),
        orderDetailResponse['orderId'].toString(),
        check!);
    print("paymentId");
    print(response.paymentId);
    print(response.signature);
    print(response.orderId);
    print("Payment Done");
    Get.to(() => OrderPlacedScreen());

    // paymentId payment Status orderId
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    productController.setPaymentDetails(
        "0", "FAILED", orderDetailResponse['orderId'].toString(), check!);
    print("Payment Fail");
    print(response.toString());
    Get.to(() => OrderfailScreen());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    CurrentDate = DateFormat('dd-MM-yyyy').format(date);
    String finalDate = CurrentDate! + " " + "09:00";
    DateTime DateFromPicker = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate);
    String finalDate1 = CurrentDate! + " " + "14:00";
    DateTime DateFromPicker1 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate1);
    String finalDate2 = CurrentDate! + " " + "17:00";
    DateTime DateFromPicker2 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate2);
    String finalDate3 = CurrentDate! + " " + "20:00";
    DateTime DateFromPicker3 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate3);
    String finalDate4 = CurrentDate! + " " + "00:00";
    DateTime DateFromPicker4 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate4);
    if (now.isAfter(DateFromPicker) && now.isBefore(DateFromPicker1)) {
      listItemSorting = [
        '02:00 PM',
        '05:00 PM',
        '08:00 PM',
      ];
    } else if (now.isAfter(DateFromPicker1) && now.isBefore(DateFromPicker2)) {
      listItemSorting = [
        '05:00 PM',
        '08:00 PM',
      ];
    } else if (now.isAfter(DateFromPicker2) && now.isBefore(DateFromPicker3)) {
      listItemSorting = [
        '08:00 PM',
      ];
    } else if (now.isAfter(DateFromPicker3)) {
      listItemSorting = [];
    } else {
      listItemSorting = [
        '09:00 AM',
        '02:00 PM',
        '05:00 PM',
        '08:00 PM',
      ];
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        automaticallyImplyLeading: true,
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
            color: black,
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
                  child: Text("Delivery Address",
                      style: Theme.of(context).textTheme.titleMedium),
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
                              ? Text('Select Your Address')
                              : Text(SelectedAddress.toString(),
                                  // "538 sagar park laxmi Nagar Panchavati Nashik-422003",
                                  style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ),
                      Container(
                        decoration: new BoxDecoration(
                          color: grey,
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(backgroundColor: black),
                            onPressed: () async {
                              await Future.delayed(Duration(seconds: 1));
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
                            child:
                                Text("Select", style: TextStyle(color: white))),
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
                  child: Text("Schedule Date and Time",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // padding: EdgeInsets.only(top: 10, bottom: 10),
                            primary: Colors.black),
                        child: Text(formattedDate),
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 0)),
                            lastDate: DateTime(2030),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                // valueChoose = null;
                                date = selectedDate;
                                formattedDate =
                                    DateFormat('d-MMM-yy').format(selectedDate);
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget);
                                // print(date);
                                // print(formattedDate);
                              });
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                            child: GestureDetector(
                              onTap: () {
                                if (listItemSorting.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        'There is no time slot available for today please select another days time slot'),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              },
                              child: DropdownButton(
                                underline: SizedBox(),
                                hint: Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: Text("Select",
                                      style: TextStyle(color: white)),
                                ),
                                dropdownColor: Colors.white,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: white,
                                ),
                                iconSize: 20,
                                isExpanded: true,
                                value: valueChoose,
                                onChanged: (newValue) {
                                  setState(() {
                                    valueChoose = newValue as String;
                                    print("Choosed Value is :${valueChoose}");
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget);
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return listItemSorting.map((value) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Text(
                                        value,
                                        style: const TextStyle(color: white),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: listItemSorting.map((valueItem) {
                                  return DropdownMenuItem(
                                      value: valueItem, child: Text(valueItem));
                                }).toList(),
                              ),
                            ),
                          ),
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
                          style: Theme.of(context).textTheme.titleMedium),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                            onPressed: () {
                              Get.to(() => OrderScreen());
                            },
                            child: Row(
                              children: [],
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
                    children: List.generate(cartproducts.length, (index) {
                  var productdata = cartproducts[index];
                  total = cartproducts.length > 0
                      ? cartproducts
                          .map<int>(
                              (m) => m['product']['price'] * m['quantity'])
                          .reduce((value, element) => value + element)
                      : 0;
                  int? totalPrice = int.tryParse(total.toString());
                  gst = ((totalPrice! * 0.18));
                  if (check == false) {
                    finalPrice = gst + totalPrice + 10;
                  }

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
                                            productdata['quantity'].toString(),
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
                                            productdata['product']['price']
                                                .toString(),
                                            // "\$ " + products[index]['price'],
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
                  child: Text("Wallet",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: black,
                          checkColor: white,
                          //only check box
                          value: check, //unchecked
                          onChanged: (bool? value) {
                            setState(() {
                              if (WalletAmount != 0.00) {
                                check = value;
                                if (check == true) {
                                  if (WalletAmount >= finalPrice) {
                                    // finalPrice = WalletAmount - finalPrice;
                                    // print(WalletAmount);
                                    // print(finalPrice);
                                    double difference =
                                        WalletAmount - finalPrice;
                                    double gap = WalletAmount - difference;
                                    double finalValue = finalPrice - gap;
                                    finalPrice = finalValue.abs();
                                    amountCutFromWallet = gap.abs();
                                  } else {
                                    double difference =
                                        finalPrice - WalletAmount;
                                    double gap = finalPrice - difference;
                                    print(difference);
                                    finalPrice = finalPrice - WalletAmount;
                                    amountCutFromWallet = gap.abs();
                                  }
                                } else {}
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Low Balance',
                                    gravity: ToastGravity.BOTTOM_RIGHT,
                                    fontSize: 18,
                                    backgroundColor: Colors.red,
                                    textColor: white);
                              }
                            });
                          }),
                      Expanded(
                        child: Text(
                          "Do you want to use wallet amount for payment ?",
                          style: TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: Text(
                                    "\??? ${WalletAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Wallet Balance",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 11,
                                        color: WalletAmount == 0
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: black),
                                onPressed: () async {
                                  Get.to(() => WalletScreen());
                                },
                                child: Text("Add Money",
                                    style: TextStyle(color: white))),
                          ],
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
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sub Total",
                            style: Theme.of(context).textTheme.titleMedium),
                        Text("\???${total}",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Cost",
                            style: Theme.of(context).textTheme.titleMedium),
                        Text("\???10",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Gst(18%)",
                            style: Theme.of(context).textTheme.titleMedium),
                        Text("\???${gst.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    check == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Wallet Amount",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(
                                  "\- ???${amountCutFromWallet.toStringAsFixed(2)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
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
                            style: Theme.of(context).textTheme.titleMedium),
                        Text("\???${finalPrice.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.titleMedium),
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
                      color: black,
                      onPressed: () {
                        if (SelectedAddress != null) {
                          if (formattedDate != null && valueChoose != null) {
                            DateTime finalDate =
                                DateFormat('dd-MM-yyyy hh:mm aa')
                                    .parse(CurrentDate! + " " + valueChoose!);
                            createNewOrder(
                                DateFormat('dd-MM-yyyy HH:mm:ss')
                                    .format(finalDate),
                                check!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please Select Date and Time Slot'),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please Select Your Address'),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
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
    getWalletByUser(id);
    setState(() {
      this.id = id;
      apiCall();
    });
  }

  Future getCartproducts(userId) async {
    print("fatchProduct $userId");
    CommanDialog.showLoading();
    String url = serverUrl + 'api/auth/getcartitems/${userId}';
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

  Future createNewOrder(String dateTime, bool check) async {
    // DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm:ss a");
    // dateFormat.format(dateTime);
    String url = serverUrl + 'createNewOrder';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {"user_id": this.id, "dateTime": dateTime, "wallet": check}));

    if (response.statusCode == 200) {
      print("Success");
      print("working" + (response.body).toString());
      orderDetailResponse = jsonDecode(response.body);
      print(orderDetailResponse);
      order_id = (orderDetailResponse['orderId']);
      print(orderDetailResponse['totalPrice'] * 100);
      double value = orderDetailResponse['totalPrice'] * 100;
      String value1 = value.toStringAsFixed(2);
      print(value1);
      String orderdata = orderDetailResponse['orderId'];
      var options = {
        'key': "rzp_test_BHAChutrVpoEpO",
        'amount': value1,
        'name': 'Piyush pagar',
        'description': orderdata, // in seconds
        'prefill': {'contact': '8830218670', 'email': 'piyush@gmail.com'},
      };
      try {
        if (orderDetailResponse['totalPrice'] != 0) {
          _razorpay.open(options);
        } else {
          setPaymentDetails('', "SUCCESS".toString(),
              orderDetailResponse['orderId'].toString(), check);
        }
      } catch (e) {
        print(e.toString());
      }
      return orderDetailResponse;
    }
  }

  Future setPaymentDetails(
      String paymentId, String paymentStatus, orderId, bool check) async {
    try {
      String url = serverUrl + 'setOrderPaymentStatus';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "paymentId": paymentId,
            "paymentStatus": paymentStatus,
            "orderId": orderId,
            "iswallet": check
          }));
      print("Success payment");
      var body = jsonDecode(response.body);
      if (body['status'] == 200) {
        Get.to(() => OrderPlacedScreen());
        print("Success payment");
        print(response.body);
      } else {
        Get.to(() => OrderfailScreen());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getSelectedApi(int UserId, bool isSelected) async {
    try {
      String url =
          serverUrl + 'api/auth/getSelectedAddress/${UserId}/${isSelected}';
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

  Future getWalletByUser(int id) async {
    String url = serverUrl + 'api/auth/getWalletbyuser/${id}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      setState(() {
        WalletAmount = body['amount'];
      });
    } else {
      // print(response.body);
      print('failed');
    }
  }
}
