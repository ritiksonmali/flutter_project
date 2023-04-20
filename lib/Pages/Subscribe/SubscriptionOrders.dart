import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Controller/SubscribeProductController.dart';
import 'package:flutter_login_app/Pages/Subscribe/UpdateSubscription.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shimmer/shimmer.dart';

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
  DateTime date = DateTime.now().add(const Duration(days: 1, hours: 5));
  DateTime todayDate = DateTime.now().add(const Duration(days: 2, hours: 5));
  int? frequency;
  SubscribeProductController subscribeProductController =
      Get.put(SubscribeProductController());
  ProductController productController = Get.find();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    subscribeProductController.getSubscribeProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text("Subscriptions",
            style: Theme.of(context).textTheme.headline5!.apply(color: white)),
        centerTitle: true,
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
            icon: const Icon(Icons.menu, color: white),
            onPressed: () {
              Get.to(() => const Navbar());
            }, //=> _key.currentState!.openDrawer(),
          ),
        ],
      ),
      body: Container(
        color: grey,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: GetBuilder<SubscribeProductController>(builder: (controller) {
            return subscribeProductController.isloading.value == true
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 7.5, horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : subscribeProductController.subscribeProductDetailsList.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 300,
                          ),
                          const Text(
                            'Subscription Not Found',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: black,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'You have not Created Any subscriptiony',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: subscribeProductController
                            .subscribeProductDetailsList.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var order = subscribeProductController
                              .subscribeProductDetailsList[index];
                          // DateTime orderTime =
                          //     ;
                          // print(DateFormat("hh:mm a")
                          //     .format(DateFormat('HH:mm:ss').parse(order['time'])));
                          // DateTime startDate = DateTime.parse(order['startDate']);
                          // String time = order['time'];
                          // print(order['time']);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: white),
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
                                            image: NetworkImage(
                                                '${serverUrl}api/auth/serveproducts/${order['product']['imageUrl'].toString()}'),
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order['product']['name']
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    order['product']['weight']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                    "\₹ ${order['product']['price']}",
                                                    style: const TextStyle(
                                                        color: black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                            const SizedBox(
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
                                                          .format(DateTime
                                                                  .parse(order[
                                                                      'startDate'])
                                                              .toUtc()
                                                              .toLocal()),
                                                  style: const TextStyle(
                                                    color: black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                order['endDate'] != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5),
                                                        child: Text(
                                                          "End Date :" +
                                                              " " +
                                                              DateFormat(
                                                                      'd MMM, yyyy')
                                                                  .format(DateTime
                                                                          .parse(
                                                                              order['endDate'])
                                                                      .toUtc()
                                                                      .toLocal()),
                                                          style:
                                                              const TextStyle(
                                                            color: black,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style:
                                                              const TextStyle(
                                                            color: black,
                                                            fontSize: 10,
                                                          ),
                                                          children: <TextSpan>[
                                                            const TextSpan(
                                                                text: "* ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                            TextSpan(
                                                              text:
                                                                  "${order['quantity']} Package Coming On ",
                                                            ),
                                                            TextSpan(
                                                              text: order['frequency'] ==
                                                                      1
                                                                  ? "Everyday"
                                                                  : order['frequency'] ==
                                                                          2
                                                                      ? "Every 2nd Day"
                                                                      : order['frequency'] ==
                                                                              3
                                                                          ? "Every 3rd Day"
                                                                          : order['frequency'] == 4
                                                                              ? "Every 4th Day"
                                                                              : order['frequency'] == 5
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
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        order['endDate'] != null
                                            ? DateTime.parse(order['startDate'])
                                                    .add(Duration(
                                                        days:
                                                            order['frequency']))
                                                    .isBefore(DateTime.parse(
                                                        order['endDate']))
                                                ? Text(
                                                    "Next Delivery On :" +
                                                        " " +
                                                        DateFormat(
                                                                'd MMM, yyyy')
                                                            .format(DateTime
                                                                    .parse(order[
                                                                        'startDate'])
                                                                .add(Duration(
                                                                    days: order[
                                                                        'frequency']))
                                                                .toUtc()
                                                                .toLocal()),
                                                    style: const TextStyle(
                                                      color: black,
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : const SizedBox()
                                            : Text(
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
                                                style: const TextStyle(
                                                  color: black,
                                                  fontSize: 10,
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                                  const BoxConstraints.tightFor(
                                                      height: 30),
                                              child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  backgroundColor: buttonColour,
                                                ),
                                                onPressed: () {
                                                  Get.to(
                                                      () =>
                                                          const UpdateSubscription(),
                                                      arguments: {
                                                        "proId":
                                                            order['product']
                                                                    ['id']
                                                                .toString(),
                                                        "startDate": DateFormat(
                                                                'EEE, MMM d, yyyy')
                                                            .format(DateTime
                                                                    .parse(order[
                                                                        'startDate'])
                                                                .toUtc()
                                                                .toLocal()),
                                                        "endDate": order[
                                                                    'endDate'] !=
                                                                null
                                                            ? DateFormat(
                                                                    'EEE, MMM d, yyyy')
                                                                .format(DateTime
                                                                        .parse(order[
                                                                            'endDate'])
                                                                    .toUtc()
                                                                    .toLocal())
                                                            : null,
                                                        "time": DateFormat(
                                                                "hh:mm a")
                                                            .format(DateFormat(
                                                                    'HH:mm:ss')
                                                                .parse(order[
                                                                    'time'])),
                                                        "orderId": order['id']
                                                            .toString(),
                                                        "quantity":
                                                            order['quantity'],
                                                        "frequency":
                                                            order['frequency']
                                                      });
                                                },
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ), // <-- Text
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            ConstrainedBox(
                                              constraints:
                                                  const BoxConstraints.tightFor(
                                                      height: 30),
                                              child: ElevatedButton(
                                                style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  backgroundColor:
                                                      buttonCancelColour,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                            "Do you want to delete this Subscription ?"),
                                                        actions: [
                                                          ElevatedButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    buttonCancelColour,
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child: const Text(
                                                                  'No')),
                                                          ElevatedButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    buttonColour,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                subscribeProductController
                                                                    .updateSubscribeProductStatus(
                                                                        order['id']
                                                                            .toString());
                                                                await Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            1));
                                                                setState(() {
                                                                  subscribeProductController
                                                                      .subscribeProductDetailsList
                                                                      .clear();
                                                                  subscribeProductController
                                                                      .getSubscribeProductDetails();
                                                                });
                                                              },
                                                              child: const Text(
                                                                  'Yes'))
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
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
                                      margin: const EdgeInsets.only(
                                          right: 8,
                                          left: 12,
                                          top: 1,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: selectEveryDay ? black : white,
                                        border: Border.all(color: black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        "Everyday",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color:
                                                selectEveryDay ? white : black),
                                      ),
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
                                      margin: const EdgeInsets.only(
                                          right: 8,
                                          left: 12,
                                          top: 1,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        color: selectOnInterval ? black : white,
                                        border: Border.all(color: black),
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(5)),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        "On Interval",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: selectOnInterval
                                                ? white
                                                : black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
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
                                              const Text('Every 2nd Day'),
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
                                              const Text('Every 3rd Day'),
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
                                              const Text('Every 4th Day'),
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
                                              const Text('Every 5th Day'),
                                            ]),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Start Date'),
                                      const SizedBox(
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
                                          style: const TextStyle(
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime
                                                                  .now()
                                                              .add(
                                                                  const Duration(
                                                                      days: 1,
                                                                      hours:
                                                                          5)),
                                                          firstDate: DateTime
                                                                  .now()
                                                              .add(
                                                                  const Duration(
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
                                                child: const Icon(
                                                  Icons.date_range_outlined,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              hintText: 'Enter Date',
                                              border:
                                                  const OutlineInputBorder()),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('End Date'),
                                      const SizedBox(
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
                                          style: const TextStyle(
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate: date.add(
                                                              const Duration(
                                                                  days: 1,
                                                                  hours: 5)),
                                                          firstDate: date.add(
                                                              const Duration(
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
                                                child: const Icon(
                                                  Icons.date_range_outlined,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              hintText: 'Enter Date',
                                              border:
                                                  const OutlineInputBorder()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
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
                                                icon: const Icon(Icons.remove),
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
                                            style:
                                                const TextStyle(color: white),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: SizedBox(
                                              height: 50,
                                              width: 30,
                                              child: IconButton(
                                                icon: const Icon(Icons.add),
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
                                        child: const Text("Add",
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 16,
                                            )),
                                      ),
                              ),
                              const SizedBox(
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
