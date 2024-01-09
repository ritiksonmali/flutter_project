import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/ApplicationParameterController.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:flutter_login_app/Pages/cart/deliveryInstructions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
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
  bool isLoading = true;

  var amountController = TextEditingController();
  var directionToReachController = TextEditingController();
  String? valueChoose;

  List listItemSorting = [
    // '09:00 AM',
    // '02:00 PM',
    // '05:00 PM',
    // '08:00 PM',
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
    getTimeSlots();
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
    Get.to(() => const OrderPlacedScreen());

    // paymentId payment Status orderId
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    productController.setPaymentDetails(
        "0", "FAILED", orderDetailResponse['orderId'].toString(), check!);
    print("Payment Fail");
    print(response.toString());
    Get.to(() => const OrderfailScreen());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // DateTime now = DateTime.now();
    // CurrentDate = DateFormat('dd-MM-yyyy').format(date);
    // String finalDate = "${CurrentDate!} 09:00";
    // DateTime DateFromPicker = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate);
    // String finalDate1 = "${CurrentDate!} 14:00";
    // DateTime DateFromPicker1 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate1);
    // String finalDate2 = "${CurrentDate!} 17:00";
    // DateTime DateFromPicker2 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate2);
    // String finalDate3 = "${CurrentDate!} 20:00";
    // DateTime DateFromPicker3 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate3);
    // String finalDate4 = "${CurrentDate!} 00:00";
    // DateTime DateFromPicker4 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate4);
    // if (now.isAfter(DateFromPicker) && now.isBefore(DateFromPicker1)) {
    //   listItemSorting = [
    //     '02:00 PM',
    //     '05:00 PM',
    //     '08:00 PM',
    //   ];
    // } else if (now.isAfter(DateFromPicker1) && now.isBefore(DateFromPicker2)) {
    //   listItemSorting = [
    //     '05:00 PM',
    //     '08:00 PM',
    //   ];
    // } else if (now.isAfter(DateFromPicker2) && now.isBefore(DateFromPicker3)) {
    //   listItemSorting = [
    //     '08:00 PM',
    //   ];
    // } else if (now.isAfter(DateFromPicker3)) {
    //   listItemSorting = [];
    // } else {
    //   listItemSorting = [
    //     '09:00 AM',
    //     '02:00 PM',
    //     '05:00 PM',
    //     '08:00 PM',
    //   ];
    // }
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: white),
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryGreen,
        centerTitle: true,
        title: Text(
          "Checkout",
          style: Theme.of(context).textTheme.headline5!.apply(color: white),
        ),
      ),
      body: isLoading == true
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3, // number of shimmer placeholders you want to show
                itemBuilder: (_, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 25,
                        width: 100,
                        color: Colors.white,
                      ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 00),
                            child: SizedBox(
                              width: 230,
                              height: 25,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 25,
                        width: 150,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              '',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 15,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
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
                        child: Text("Delivery Address",
                            style: Theme.of(context).textTheme.titleMedium),
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
                                child: SelectedAddress == null
                                    ? const Text('Select Your Address')
                                    : Text(SelectedAddress.toString(),
                                        // "538 sagar park laxmi Nagar Panchavati Nashik-422003",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                              ),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: buttonColour),
                                onPressed: () async {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  // ignore: unused_local_variable
                                  final value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddressDetails()),
                                  );
                                  setState(() {
                                    apiCall();
                                  });
                                },
                                child: const Text("Select",
                                    style: TextStyle(color: white))),
                          ],
                        ),
                      ),
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
                        child: Text("Schedule Date and Time",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      const SizedBox(
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
                                  primary: buttonColour),
                              child: Text(formattedDate),
                              onPressed: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 0)),
                                  lastDate: DateTime(2030),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    setState(() {
                                      // valueChoose = null;
                                      date = selectedDate;
                                      formattedDate = DateFormat('d-MMM-yy')
                                          .format(selectedDate);
                                      getTimeSlots();
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (listItemSorting.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                              'There is no time slot available for today please select another days time slot'),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                      }
                                    },
                                    child: DropdownButton(
                                      underline: const SizedBox(),
                                      hint: const Padding(
                                        padding: EdgeInsets.only(top: 14),
                                        child: Text("Select",
                                            style: TextStyle(color: white)),
                                      ),
                                      dropdownColor: Colors.white,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: white,
                                      ),
                                      iconSize: 20,
                                      isExpanded: true,
                                      value: valueChoose,
                                      onChanged: (newValue) {
                                        setState(() {
                                          valueChoose = newValue as String;
                                          print(
                                              "Choosed Value is :$valueChoose");
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  super.widget);
                                        });
                                      },
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return listItemSorting.map((value) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 14),
                                            child: Text(
                                              value,
                                              style:
                                                  const TextStyle(color: white),
                                            ),
                                          );
                                        }).toList();
                                      },
                                      items: listItemSorting.map((valueItem) {
                                        return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem));
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order Summary",
                                style: Theme.of(context).textTheme.titleMedium),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextButton(
                                  onPressed: () {
                                    Get.to(() => const OrderScreen());
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
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                          children: List.generate(cartproducts.length, (index) {
                        var productdata = cartproducts[index];
                        total = cartproducts.length > 0
                            ? cartproducts
                                .map<int>((m) =>
                                    m['product']['price'] * m['quantity'])
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
                                          padding: const EdgeInsets.all(20),
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
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Text(
                                                  productdata['product']
                                                          ['price']
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
                                activeColor: buttonColour,
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
                                          double gap =
                                              WalletAmount - difference;
                                          double finalValue = finalPrice - gap;
                                          finalPrice = finalValue.abs();
                                          amountCutFromWallet = gap.abs();
                                        } else {
                                          double difference =
                                              finalPrice - WalletAmount;
                                          double gap = finalPrice - difference;
                                          print(difference);
                                          finalPrice =
                                              finalPrice - WalletAmount;
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
                            const Expanded(
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          "\₹ ${WalletAmount.toStringAsFixed(2)}",
                                          style: const TextStyle(
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
                                          backgroundColor: buttonColour),
                                      onPressed: () async {
                                        Get.to(() => const WalletScreen());
                                      },
                                      child: const Text("Add Money",
                                          style: TextStyle(color: white))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text("\₹$total",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          const SizedBox(
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
                          const SizedBox(
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
                          const SizedBox(
                            height: 5,
                          ),
                          check == true
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Wallet Amount",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    Text(
                                        "\- ₹${amountCutFromWallet.toStringAsFixed(2)}",
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
                                      Theme.of(context).textTheme.titleMedium),
                              Text("\₹${finalPrice.toStringAsFixed(2)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Instruction",
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: height * 0.12,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: instructionData.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                var instruction = instructionData[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (instruction.id == 3) {
                                          directionToReachPopup();
                                        } else {
                                          if (instruction.id == 5) {
                                            setState(() {
                                              instructionData[0].active = false;
                                              instructionData[1].active = false;
                                            });
                                          } else if (instruction.id == 1 ||
                                              instruction.id == 2) {
                                            setState(() {
                                              instructionData[4].active = false;
                                            });
                                          }
                                          if (instruction.active == false) {
                                            setState(() {
                                              instruction.active = true;
                                            });
                                          } else if (instruction.active ==
                                              true) {
                                            setState(() {
                                              instruction.active = false;
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 8,
                                            left: 8,
                                            top: 0,
                                            bottom: 0),
                                        width: width * 0.22,
                                        height: height * 0.12,
                                        decoration: BoxDecoration(
                                          border: instruction.active
                                              ? Border.all(
                                                  color: buttonColour,
                                                )
                                              : Border.all(color: grey),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                          color: instruction.active
                                              ? kLightGreen
                                              : white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(instruction.icon),
                                            const SizedBox(height: 2),
                                            Text(
                                              instruction.name,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })),
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
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: CupertinoButton(
                            color: buttonColour,
                            onPressed: () {
                              if (ApplicationParameterController
                                  .isOrdersEnable.value) {
                                if (SelectedAddress != null) {
                                  if (formattedDate != null &&
                                      valueChoose != null) {
                                    String pickedDate =
                                        DateFormat("dd-MM-yyyy").format(date);
                                    DateTime finalDate =
                                        DateFormat('dd-MM-yyyy hh:mm aa').parse(
                                            "$pickedDate ${valueChoose!}");
                                    createNewOrder(
                                        DateFormat('dd-MM-yyyy HH:mm:ss')
                                            .format(finalDate),
                                        check!);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please Select Date and Time Slot'),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Please Select Your Address'),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Sorry currently You cannot placed order'),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            },
                            child: const Text("Place Order"),
                          ),
                        ),
                      ),
                      const SizedBox(
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

  Future directionToReachPopup() {
    return showModalBottomSheet(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Directions to reach",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .apply(color: black),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 10,
                          color: black,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(color: black),
                                controller: directionToReachController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                  hintText: 'e.g. Ring the bell',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(color: kGreyShade1),
                                  filled: false,
                                ),
                                maxLines: 5,
                                maxLength: 200,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please enter data';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (instructionData[2].id == 3) {
                                    if (directionToReachController
                                        .text.isNotEmpty) {
                                      setState(() {
                                        instructionData[2].active = true;
                                      });
                                    } else {
                                      setState(() {
                                        instructionData[2].active = false;
                                      });
                                    }
                                  }
                                  Get.back();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: buttonColour,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Center(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
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
    // CommanDialog.showLoading();
    String url = '${serverUrl}api/auth/getcartitems/$userId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);
    // CommanDialog.hideLoading();
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
      isLoading = false;
    });
  }

  Future createNewOrder(String dateTime, bool check) async {
    String url = '${serverUrl}createNewOrder';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": id,
          "dateTime": dateTime,
          "wallet": check,
          "avoidRinging": instructionData[0].active,
          "leaveAtDoor": instructionData[1].active,
          "deliveryInstructions": directionToReachController.text.toString(),
          "avoidCalling": instructionData[2].active,
          "leaveWithSecurity": instructionData[4].active,
        }));

    if (response.statusCode == 200) {
      orderDetailResponse = jsonDecode(response.body);
      // print(orderDetailResponse);
      order_id = (orderDetailResponse['orderId']);
      // print(orderDetailResponse['totalPrice'] * 100);
      double value = orderDetailResponse['totalPrice'] * 100;
      String value1 = value.toStringAsFixed(2);
      String orderdata = orderDetailResponse['orderId'];
      var options = {
        'key': "rzp_test_BHAChutrVpoEpO",
        'amount': value1,
        'name': 'Piyush pagar',
        'description': orderdata, // in seconds
        'prefill': {
          'contact': '8530838580',
          'email': 'sonmalirutik001@gmail.com'
        },
      };
      try {
        if (orderDetailResponse['totalPrice'] != 0) {
          _razorpay.open(options);
        } else {
          setPaymentDetails('', "SUCCESS".toString(),
              orderDetailResponse['orderId'].toString(), check);
        }
      } catch (e) {
        e.printError();
      }
      return orderDetailResponse;
    }
  }

  Future setPaymentDetails(
      String paymentId, String paymentStatus, orderId, bool check) async {
    try {
      String url = '${serverUrl}setOrderPaymentStatus';
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
        Get.to(() => const OrderPlacedScreen());
      } else {
        Get.to(() => const OrderfailScreen());
      }
    } catch (e) {
      e.printError();
    }
  }

  getSelectedApi(int UserId, bool isSelected) async {
    try {
      String url =
          '${serverUrl}api/auth/getSelectedAddress/$UserId/$isSelected';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      // print(body);
      return body['address_line1'] +
          "," +
          "\n" +
          body["address_line2"] +
          "," +
          "\n" +
          body['city'] +
          " " +
          body['pincode'].toString() +
          "\n" +
          body['state'] +
          " " +
          body['country'];
    } catch (e) {
      print(e.toString());
    }
  }

  Future getWalletByUser(int id) async {
    String url = '${serverUrl}api/auth/getWalletbyuser/$id';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.body);
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

  getTimeSlots() async {
    List<String> selectedTimeSLots = [];
    String dropdownName = "APPLICATION_PARAMETER";
    String parentCode = "TIME_SLOT";
    String url =
        '${serverUrl}api/auth/fetchDropDown?dropdownName=$dropdownName&param=$parentCode';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      selectedTimeSLots.clear();
      List<dynamic> timeSlotList = jsonDecode(response.body);
      DateTime currentDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(DateTime.now().toString());
      for (var slot in timeSlotList) {
        DateTime selectedDate = DateFormat("dd-MMM-yy").parse(formattedDate);
        String parsedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
        DateTime pickedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse("$parsedDate ${slot['shortDesc']}");
        if (currentDate.isAfter(pickedDate) &&
            pickedDate.year == currentDate.year &&
            pickedDate.month == currentDate.month &&
            pickedDate.day != currentDate.day) {
          String finalTimeSLot = DateFormat("hh:mm a").format(pickedDate);
          setState(() {
            selectedTimeSLots.add(finalTimeSLot);
          });
        } else if (currentDate.isBefore(pickedDate)) {
          String finalTimeSLot = DateFormat("hh:mm a").format(pickedDate);
          selectedTimeSLots.add(finalTimeSLot);
        }
      }
      setState(() {
        listItemSorting = selectedTimeSLots;
      });
    } else {
      print('failed');
    }
  }
}
