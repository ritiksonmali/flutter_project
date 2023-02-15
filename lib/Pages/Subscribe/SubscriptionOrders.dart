import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Controller/SubscribeProductController.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/Pages/Subscribe/UpdateSubscription.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';

class SubscriptionOrderDetails extends StatefulWidget {
  const SubscriptionOrderDetails({Key? key}) : super(key: key);

  @override
  State<SubscriptionOrderDetails> createState() =>
      _SubscriptionOrderDetailsState();
}

class _SubscriptionOrderDetailsState extends State<SubscriptionOrderDetails> {
  bool selectEveryDay = false;
  bool selectOnInterval = false;
  bool check2nd = false;
  bool check3rd = false;
  bool check4th = false;
  bool check5th = false;
  int counter = 0;
  bool isAdded = false;
  DateTime date = DateTime.now().add(Duration(days: 1, hours: 5));
  DateTime todayDate = DateTime.now().add(Duration(days: 2, hours: 5));
  int? frequency;
  SubscribeProductController subscribeProductController =
      Get.put(SubscribeProductController());
  ProductController productController = Get.find();
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscribeProductController.getSubscribeProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscriptions",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
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
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu, color: black),
            onPressed: () {
              Get.to(() => Navbar());
            }, //=> _key.currentState!.openDrawer(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: GetBuilder<SubscribeProductController>(builder: (controller) {
          return subscribeProductController.isloading.value == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: subscribeProductController
                      .subscribeProductDetailsList.length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var order = subscribeProductController
                        .subscribeProductDetailsList[index];
                    // DateTime startDate = DateTime.parse(order['startDate']);
                    String time = order['time'];
                    print(DateFormat.jm().format(DateFormat('hh:mm')
                        .parse(order['time'])
                        .toUtc()
                        .toLocal()));
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.secondary.withOpacity(0.05)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 90,
                                  child: ImageFade(
                                      image: NetworkImage(serverUrl +
                                          'api/auth/serveproducts/${order['product']['imageUrl'].toString()}'),
                                      fit: BoxFit.cover,
                                      // scale: 2,
                                      placeholder: Image.file(
                                        fit: BoxFit.cover,
                                        File(
                                            '${directory.path}/compress${order['product']['imageUrl'].toString()}'),
                                        gaplessPlayback: true,
                                      )),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order['product']['name'].toString(),
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              order['product']['weight']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                              "\₹ " +
                                                  order['product']['price']
                                                      .toString(),
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Start Date :" +
                                                " " +
                                                DateFormat('d MMM, yyyy')
                                                    .format(DateTime.parse(
                                                            order['startDate'])
                                                        .toUtc()
                                                        .toLocal()),
                                            style: TextStyle(
                                              color: black,
                                              fontSize: 10,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          order['endDate'] != null
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Text(
                                                    "End Date :" +
                                                        " " +
                                                        DateFormat(
                                                                'd MMM, yyyy')
                                                            .format(DateTime
                                                                    .parse(order[
                                                                        'endDate'])
                                                                .toUtc()
                                                                .toLocal()),
                                                    style: TextStyle(
                                                      color: black,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: new RichText(
                                                  text: new TextSpan(
                                                    style: TextStyle(
                                                      color: black,
                                                      fontSize: 10,
                                                    ),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text: "* ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                      new TextSpan(
                                                        text: order['quantity']
                                                                .toString() +
                                                            " " +
                                                            "Package Coming On ",
                                                      ),
                                                      new TextSpan(
                                                        text: order['frequency'] ==
                                                                1
                                                            ? "Everyday"
                                                            : order['frequency'] ==
                                                                    2
                                                                ? "Every 2nd Day"
                                                                : order['frequency'] ==
                                                                        3
                                                                    ? "Every 3rd Day"
                                                                    : order['frequency'] ==
                                                                            4
                                                                        ? "Every 4th Day"
                                                                        : order['frequency'] ==
                                                                                5
                                                                            ? "Every 5th Day"
                                                                            : "",
                                                        // style: TextStyle(
                                                        //   color: black,
                                                        //   fontSize: 10,
                                                        // )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  order['endDate'] != null
                                      ? DateTime.parse(order['startDate'])
                                              .add(Duration(
                                                  days: order['frequency']))
                                              .isBefore(DateTime.parse(
                                                  order['endDate']))
                                          ? Text(
                                              "Next Delivery On :" +
                                                  " " +
                                                  DateFormat('d MMM, yyyy')
                                                      .format(DateTime.parse(
                                                              order[
                                                                  'startDate'])
                                                          .add(Duration(
                                                              days: order[
                                                                  'frequency']))
                                                          .toUtc()
                                                          .toLocal()),
                                              style: TextStyle(
                                                color: black,
                                                fontSize: 10,
                                              ),
                                            )
                                          : SizedBox()
                                      : Text(
                                          "Next Delivery On :" +
                                              " " +
                                              DateFormat('d MMM, yyyy').format(
                                                  DateTime.parse(
                                                          order['startDate'])
                                                      .add(Duration(
                                                          days: order[
                                                              'frequency']))
                                                      .toUtc()
                                                      .toLocal()),
                                          style: TextStyle(
                                            color: black,
                                            fontSize: 10,
                                          ),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ConstrainedBox(
                                        constraints:
                                            BoxConstraints.tightFor(height: 30),
                                        child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(4),
                                            backgroundColor: buttonColour,
                                          ),
                                          onPressed: () {
                                            Get.to(() => UpdateSubscription(),
                                                arguments: {
                                                  "proId": order['product']
                                                          ['id']
                                                      .toString(),
                                                  "startDate": DateFormat(
                                                          'EEE, MMM d, yyyy')
                                                      .format(DateTime.parse(
                                                              order[
                                                                  'startDate'])
                                                          .toUtc()
                                                          .toLocal()),
                                                  "endDate": order['endDate'] !=
                                                          null
                                                      ? DateFormat(
                                                              'EEE, MMM d, yyyy')
                                                          .format(DateTime
                                                                  .parse(order[
                                                                      'endDate'])
                                                              .toUtc()
                                                              .toLocal())
                                                      : null,
                                                  "time": DateFormat.jm()
                                                      .format(DateFormat(
                                                              'hh:mm')
                                                          .parse(order['time'])
                                                          .toUtc()
                                                          .toLocal()),
                                                  "orderId":
                                                      order['id'].toString(),
                                                  "quantity": order['quantity'],
                                                  "frequency":
                                                      order['frequency']
                                                });
                                            // setState(() {
                                            //   startDateController.text =
                                            //       DateFormat('d MMM, yyyy')
                                            //           .format(startDate
                                            //               .toUtc()
                                            //               .toLocal());
                                            //   order['endDate'] != null
                                            //       ? endDateController.text =
                                            //           DateFormat('d MMM, yyyy')
                                            //               .format(endDate
                                            //                   .toUtc()
                                            //                   .toLocal())
                                            //       : endDateController.clear();
                                            // });
                                            // buildBottomSheet(
                                            //     order['id'].toString(),
                                            //     order['quantity']);
                                          },
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ), // <-- Text
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      ConstrainedBox(
                                        constraints:
                                            BoxConstraints.tightFor(height: 30),
                                        child: ElevatedButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(4),
                                            backgroundColor: buttonCancelColour,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  
                                                  content: Text(
                                                      "Do you want to delete this Subscription ?"),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              black,
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text('No')),
                                                    ElevatedButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              black,
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          subscribeProductController
                                                              .updateSubscribeProductStatus(
                                                                  order['id']
                                                                      .toString());
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 1));
                                                          setState(() {
                                                            subscribeProductController
                                                                .subscribeProductDetailsList
                                                                .clear();
                                                            subscribeProductController
                                                                .getSubscribeProductDetails();
                                                          });
                                                        },
                                                        child: Text('Yes'))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ), // <-- Text
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
        }),
      ),
    );
  }

  Future buildBottomSheet(String id, int quantity) {
    print(quantity);
    return showModalBottomSheet(
      context: this.context,
      builder: (BuildContext context) {
        return BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (BuildContext context) {
            bool b = false;
            return StatefulBuilder(builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Update Subscription",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectEveryDay = true;
                                        selectOnInterval = false;
                                        check2nd = false;
                                        check3rd = false;
                                        check4th = false;
                                        check5th = false;
                                        frequency = 1;
                                      });
                                      // bottomSheetForEveryDay();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 8,
                                          left: 12,
                                          top: 1,
                                          bottom: 0),
                                      child: Text(
                                        "Everyday",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color:
                                                selectEveryDay ? white : black),
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectEveryDay ? black : null,
                                        border: Border.all(color: black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectOnInterval = true;
                                        selectEveryDay = false;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 8,
                                          left: 12,
                                          top: 1,
                                          bottom: 0),
                                      child: Text(
                                        "On Interval",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: selectOnInterval
                                                ? white
                                                : black),
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectOnInterval ? black : null,
                                        border: Border.all(color: black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              selectOnInterval
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              Transform.scale(
                                                  scale: 0.7,
                                                  child: CupertinoSwitch(
                                                    value: check2nd,
                                                    onChanged: (bool val) {
                                                      setState(() {
                                                        check2nd = val;
                                                        check3rd = false;
                                                        check4th = false;
                                                        check5th = false;
                                                        frequency = 2;
                                                      });
                                                    },
                                                  )),
                                              Text('Every 2nd Day'),
                                            ]),
                                            Row(children: [
                                              Transform.scale(
                                                  scale: 0.7,
                                                  child: CupertinoSwitch(
                                                    value: check3rd,
                                                    onChanged: (bool val) {
                                                      setState(() {
                                                        check3rd = val;
                                                        check2nd = false;
                                                        check4th = false;
                                                        check5th = false;
                                                        frequency = 3;
                                                      });
                                                    },
                                                  )),
                                              Text('Every 3rd Day'),
                                            ]),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              Transform.scale(
                                                  scale: 0.7,
                                                  child: CupertinoSwitch(
                                                    value: check4th,
                                                    onChanged: (bool val) {
                                                      setState(() {
                                                        check4th = val;
                                                        check3rd = false;
                                                        check2nd = false;
                                                        check5th = false;
                                                        frequency = 4;
                                                      });
                                                    },
                                                  )),
                                              Text('Every 4th Day'),
                                            ]),
                                            Row(children: [
                                              Transform.scale(
                                                  scale: 0.7,
                                                  child: CupertinoSwitch(
                                                    value: check5th,
                                                    onChanged: (bool val) {
                                                      setState(() {
                                                        check5th = val;
                                                        check3rd = false;
                                                        check4th = false;
                                                        check2nd = false;
                                                        frequency = 5;
                                                      });
                                                    },
                                                  )),
                                              Text('Every 5th Day'),
                                            ]),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Start Date'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: startDateController,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          cursorColor: Colors.black87,
                                          style:
                                              TextStyle(color: Colors.black87),
                                          decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now()
                                                                  .add(Duration(
                                                                      days: 1,
                                                                      hours:
                                                                          5)),
                                                          firstDate:
                                                              DateTime.now()
                                                                  .add(Duration(
                                                                      days: 1,
                                                                      hours:
                                                                          5)),
                                                          lastDate:
                                                              DateTime(2101));
                                                  if (pickedDate != null) {
                                                    print(pickedDate);
                                                    String formattedDate =
                                                        DateFormat(
                                                                'd MMM, yyyy')
                                                            .format(pickedDate);
                                                    print(formattedDate);
                                                    setState(() {
                                                      date = pickedDate;
                                                      endDateController.clear();
                                                      startDateController.text =
                                                          formattedDate; //set output date to TextField value.
                                                    });
                                                  } else {
                                                    print(
                                                        "Date is not selected");
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.date_range_outlined,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              hintText: 'Enter Date',
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('End Date'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: endDateController,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          cursorColor: Colors.black87,
                                          style:
                                              TextStyle(color: Colors.black87),
                                          decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate: date.add(
                                                              Duration(
                                                                  days: 1,
                                                                  hours: 5)),
                                                          firstDate: date.add(
                                                              Duration(
                                                                  days: 1,
                                                                  hours: 5)),
                                                          lastDate:
                                                              DateTime(2101));
                                                  if (pickedDate != null) {
                                                    print(pickedDate);
                                                    String formattedDate =
                                                        DateFormat(
                                                                'd MMM, yyyy')
                                                            .format(pickedDate);
                                                    print(formattedDate);

                                                    setState(() {
                                                      endDateController.text =
                                                          formattedDate; //set output date to TextField value.
                                                    });
                                                  } else {
                                                    print(
                                                        "Date is not selected");
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.date_range_outlined,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              hintText: 'Enter Date',
                                              border: OutlineInputBorder()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 180,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: black,
                                ),
                                child: quantity != 0
                                    ? Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: SizedBox(
                                              height: 50,
                                              width: 35,
                                              child: IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (quantity > 1) {
                                                      quantity--;
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'quantity always greater than 1',
                                                          fontSize: 18,
                                                          backgroundColor:
                                                              Colors.black54,
                                                          textColor: white);
                                                      // quantity = 0;
                                                      // isAdded = false;
                                                    }
                                                  });
                                                },
                                                color: white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            quantity.toString(),
                                            style: TextStyle(color: white),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: SizedBox(
                                              height: 50,
                                              width: 30,
                                              child: IconButton(
                                                icon: Icon(Icons.add),
                                                color: white,
                                                onPressed: () {
                                                  setState(() {
                                                    quantity++;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            quantity = 1;
                                            isAdded = true;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: black,
                                        ),
                                        child: Text("Add",
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 16,
                                            )),
                                      ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // Get.back();
                                    // print(DateFormat('dd-MM-yyyy').format(
                                    //     new DateFormat("d MMM, yyyy")
                                    //         .parse(startDateController.text)));
                                    // subscribeProductController
                                    //     .updateSubscription(
                                    //         id,
                                    //         DateFormat('dd-MM-yyyy').format(
                                    //             new DateFormat("d MMM, yyyy")
                                    //                 .parse(startDateController
                                    //                     .text)
                                    //                 .toUtc()
                                    //                 .toLocal()),
                                    //         DateFormat('dd-MM-yyyy').format(
                                    //             new DateFormat("d MMM, yyyy")
                                    //                 .parse(
                                    //                     endDateController.text)
                                    //                 .toUtc()
                                    //                 .toLocal()),
                                    //         frequency!,
                                    //         quantity)
                                    //     .then((value) {
                                    //   subscribeProductController
                                    //       .subscribeProductDetailsList
                                    //       .clear();
                                    //   subscribeProductController
                                    //       .getSubscribeProductDetails();
                                    //   Get.back();
                                    // });
                                    // subscribeProductController.subscribeProduct(
                                    //     DateFormat('dd-MM-yyyy').format(date),
                                    //     endDate != null
                                    //         ? DateFormat('dd-MM-yyyy')
                                    //             .format(endDate!)
                                    //         : null,
                                    //     DateFormat('HH:mm:ss').format(time2),
                                    //     frequency!,
                                    //     counter,
                                    //     this.addressId.toString(),
                                    //     subscribeProductController
                                    //         .subscribeProdutList[index]['id']
                                    //         .toString(),
                                    //     id.toString());
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: black,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
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
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }
}
