import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Controller/SubscribeProductController.dart';
import 'package:flutter_login_app/Pages/Address/AddressDetails.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/Pages/Order/Order_json.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:flutter_login_app/Pages/Wallet/Walletjson.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubscribeProductDetails extends StatefulWidget {
  const SubscribeProductDetails({Key? key}) : super(key: key);

  @override
  State<SubscribeProductDetails> createState() =>
      _SubscribeProductDetailsState();
}

class _SubscribeProductDetailsState extends State<SubscribeProductDetails> {
  var argument = Get.arguments;
  ProductController productController = Get.put(ProductController());
  SubscribeProductController subscribeProductController =
      Get.put(SubscribeProductController());
  int currentIndex = 0;
  final PageController controller = PageController();
  TextEditingController _firstNameController = new TextEditingController();
  late var formattedDate;
  var endsDate;
  DateTime? endDate;
  DateTime date = DateTime.now().add(Duration(days: 1, hours: 5));
  DateTime todayDate = DateTime.now().add(Duration(days: 2, hours: 5));
  String? SelectedAddress;
  int? id;
  String add = "add";
  String remove = "remove";
  bool isSelected = true;
  bool isLoading = false;
  bool check2nd = false;
  bool check3rd = false;
  bool check4th = false;
  bool check5th = false;
  bool selectEveryDay = false;
  bool selectOnInterval = false;
  int? addressId;
  int? frequency;
  int counter = 0;
  bool isAdded = false;

  List listItemSorting = [
    '09:00 AM',
    '02:00 PM',
    '05:00 PM',
    '08:00 PM',
  ];

  String? CurrentDate;
  String? valueChoose;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
    formattedDate = DateFormat('EEE, MMM d, yyyy').format(date);
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      subscribeProductController.getProductByIdandUserId(argument['proId']);
      this.id = id;
      apiCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    CurrentDate = DateFormat('dd-MM-yyyy').format(date);
    String finalDate = CurrentDate! + " " + "09:00";
    DateTime DateFromPicker = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate);
    String finalDate1 = CurrentDate! + " " + "14:00";
    DateTime DateFromPicker1 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate1);
    String finaltime2 = CurrentDate! + " " + "17:00";
    DateTime DateFromPicker2 = DateFormat('dd-MM-yyyy hh:mm').parse(finaltime2);
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
    return WillPopScope(
      onWillPop: () async {
        CommanDialog.showLoading();
        productController.getAllProducts();
        Timer(Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen()), // this mymainpage is your page to refresh
            (Route<dynamic> route) => false,
          );
          CommanDialog.hideLoading();
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: grey,
        appBar: PreferredSize(
            child: getAppBar(), preferredSize: Size.fromHeight(60)),
        body: getBody(),
        // bottomNavigationBar: getFooter(),
      ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      title: Text(
        "Product Details",
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
          CommanDialog.showLoading();
          productController.getAllProducts();
          Timer(Duration(seconds: 1), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()), // this mymainpage is your page to refresh
              (Route<dynamic> route) => false,
            );
            CommanDialog.hideLoading();
          });
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
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          getImages(),
        ],
      ),
    );
  }

  Widget getImages() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      // height: 350,
      child: GetBuilder<SubscribeProductController>(builder: (controller) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: subscribeProductController.subscribeProdutList.length,
            // scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              var product =
                  subscribeProductController.subscribeProdutList[index];
              return Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 280,
                      height: 180,
                      child: ImageFade(
                          image: NetworkImage(serverUrl +
                              'api/auth/serveproducts/${product['imageUrl'].toString()}'),
                          fit: BoxFit.cover,
                          // scale: 2,
                          placeholder: Image.file(
                            fit: BoxFit.cover,
                            File(
                                '${directory.path}/compress${product['imageUrl'].toString()}'),
                            gaplessPlayback: true,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'].toString(),
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop_square_sharp,
                                      color: product['isVegan'] == true
                                          ? Colors.green
                                          : Colors.red,
                                      size: 25,
                                    ),
                                    Icon(Icons.circle,
                                        color: product['isVegan'] == true
                                            ? Colors.green
                                            : Colors.red,
                                        size: 8),
                                  ],
                                ),
                                Text('${product['weight'].toString()}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium)
                              ],
                            ),
                          ],
                        ),
                        Text("\₹ ${product['price'].toString()} ",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(product['desc'].toString(),
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Duration",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: grey),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Order By : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '05:00 PM Today ',
                                            style:
                                                TextStyle(color: buttonColour)),
                                        TextSpan(
                                            text: '& get the delivery by ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        TextSpan(
                                            text: DateFormat('EEE, MMM d, yyyy')
                                                .format(
                                              todayDate.toUtc().toLocal(),
                                            ),
                                            style:
                                                TextStyle(color: buttonColour)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: size.width * 1.1,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text("Starts On",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now().add(
                                                              Duration(
                                                                  days: 1,
                                                                  hours: 5)),
                                                      firstDate: DateTime.now()
                                                          .add(Duration(
                                                              days: 1,
                                                              hours: 5)),
                                                      lastDate: DateTime(2030),
                                                    ).then((selectedDate) {
                                                      if (selectedDate !=
                                                          null) {
                                                        setState(() {
                                                          endDate = null;
                                                          endsDate = null;
                                                          date = selectedDate;
                                                          formattedDate = DateFormat(
                                                                  'EEE, MMM d, yyyy')
                                                              .format(
                                                                  selectedDate);
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  super.widget);
                                                          // print(date);
                                                          // print(formattedDate);
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    formattedDate,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        // fontWeight: FontWeight.w500,
                                                        color: buttonColour),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: black,
                                            ),
                                            Column(
                                              children: [
                                                Text("Ends On",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await showDatePicker(
                                                          context: context,
                                                          initialDate: date.add(
                                                              Duration(
                                                                  days: 2,
                                                                  hours: 5)),
                                                          firstDate: date.add(
                                                              Duration(
                                                                  days: 2,
                                                                  hours: 5)),
                                                          lastDate:
                                                              DateTime(2030),
                                                        ).then((selectedDate) {
                                                          if (selectedDate !=
                                                              null) {
                                                            setState(() {
                                                              // valueChoose = null;
                                                              endDate =
                                                                  selectedDate;
                                                              endsDate = DateFormat(
                                                                      'EEE, MMM d, yyyy')
                                                                  .format(
                                                                      selectedDate);
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      super
                                                                          .widget);
                                                              // print(date);
                                                              // print(formattedDate);
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        endsDate != null
                                                            ? endsDate
                                                            : "Optional",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            // fontWeight: FontWeight.w500,
                                                            color:
                                                                buttonColour),
                                                      ),
                                                    ),
                                                    endsDate != null
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                endsDate = null;
                                                                endDate = null;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 7),
                                                              child: Container(
                                                                // margin: EdgeInsets.all(100.0),
                                                                decoration: BoxDecoration(
                                                                    color: grey,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            decoration: BoxDecoration(
                                                color: buttonColour,
                                                border: Border.all(
                                                    color: grey, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (listItemSorting.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Text(
                                                        'There is no time slot available for today please select another days time slot'),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ));
                                                }
                                              },
                                              child: DropdownButton(
                                                underline: SizedBox(),
                                                hint: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 14),
                                                  child: Text("Select",
                                                      style: TextStyle(
                                                          color: white)),
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
                                                    valueChoose =
                                                        newValue as String;
                                                    print(
                                                        "Choosed Value is :${valueChoose}");
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            super.widget);
                                                  });
                                                },
                                                selectedItemBuilder:
                                                    (BuildContext context) {
                                                  return listItemSorting
                                                      .map((value) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 14),
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            color: white),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                                items: listItemSorting
                                                    .map((valueItem) {
                                                  return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem));
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Frequency',
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: grey),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: size.width * 0.8,
                                    child: Column(
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color: selectEveryDay
                                                          ? white
                                                          : buttonColour),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: selectEveryDay
                                                      ? buttonColour
                                                      : null,
                                                  border: Border.all(
                                                      color: buttonColour),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectOnInterval = true;
                                                  selectEveryDay = false;
                                                  frequency = null;
                                                });
                                                // bottomSheetForOninterval();
                                                buildBottomSheet();
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color: selectOnInterval
                                                          ? white
                                                          : buttonColour),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: selectOnInterval
                                                      ? buttonColour
                                                      : null,
                                                  border: Border.all(
                                                      color: buttonColour),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                        selectEveryDay == true ||
                                                check2nd == true ||
                                                check3rd == true ||
                                                check4th == true ||
                                                check5th == true
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                    height: 10,
                                                    color: buttonColour,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Interval',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall),
                                                      Text(
                                                          selectEveryDay == true
                                                              ? "Everyday"
                                                              : false ||
                                                                      check2nd ==
                                                                          true
                                                                  ? "Every 2nd Day"
                                                                  : false ||
                                                                          check3rd ==
                                                                              true
                                                                      ? "Every 3rd Day"
                                                                      : false ||
                                                                              check4th ==
                                                                                  true
                                                                          ? "Every 4th Day"
                                                                          : false ||
                                                                                  check5th ==
                                                                                      true
                                                                              ? "Every 5th Day"
                                                                              : '',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity',
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: grey),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    subscribeProductController
                                                    .subscribeProdutList[index]
                                                ['inventory']['quantity'] >
                                            0
                                        ? Container(
                                            width: 180,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: buttonColour,
                                            ),
                                            child: counter != 0
                                                ? Row(
                                                    // mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: 35,
                                                          child: IconButton(
                                                            icon: Icon(
                                                                Icons.remove),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (counter >
                                                                    1) {
                                                                  counter--;
                                                                } else {
                                                                  counter = 0;
                                                                  isAdded =
                                                                      false;
                                                                }
                                                              });
                                                            },
                                                            color: white,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        counter.toString(),
                                                        style: TextStyle(
                                                            color: white),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.0),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: 30,
                                                          child: IconButton(
                                                            icon:
                                                                Icon(Icons.add),
                                                            color: white,
                                                            onPressed: () {
                                                              if (subscribeProductController
                                                                              .subscribeProdutList[index]
                                                                          [
                                                                          'inventory']
                                                                      [
                                                                      'quantity'] >
                                                                  counter) {
                                                                setState(() {
                                                                  counter++;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        counter = 1;
                                                        isAdded = true;
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          buttonColour,
                                                    ),
                                                    child: Text("Add",
                                                        style: TextStyle(
                                                          color: white,
                                                          fontSize: 16,
                                                        )),
                                                  ),
                                          )
                                        : Text(
                                            'Out Of Stock',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .apply(
                                                  color: Colors.red,
                                                ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery Address',
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 10, right: 10),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: grey),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 00),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: SelectedAddress == null
                                              ? Text('Select Your Address')
                                              : Text(SelectedAddress.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                        ),
                                      ),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: buttonColour,
                                              minimumSize: size * 0.02),
                                          onPressed: () async {
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            final value = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressDetails()),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: GestureDetector(
                          onTap: () {
                            if (valueChoose != null) {
                              if (frequency != null) {
                                if (counter != 0) {
                                  if (addressId != null) {
                                    DateTime time2 = DateFormat("hh:mm a")
                                        .parse(valueChoose!);
                                    subscribeProductController.subscribeProduct(
                                        DateFormat('dd-MM-yyyy').format(date),
                                        endDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(endDate!)
                                            : null,
                                        DateFormat('HH:mm:ss').format(time2),
                                        frequency!,
                                        counter,
                                        this.addressId.toString(),
                                        subscribeProductController
                                            .subscribeProdutList[index]['id']
                                            .toString(),
                                        id.toString());
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 1),
                                      content:
                                          Text('Please Select Your Address'),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        'Please increase product quantity'),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Please Select Frequency'),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('Please Select time Slot'),
                                backgroundColor: Colors.redAccent,
                              ));
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                                color: buttonColour,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                "Subscribe",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            });
      }),
    );
  }

  Future buildBottomSheet() {
    return showModalBottomSheet(
      context: this.context,
      builder: (BuildContext context) {
        return BottomSheet(
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
                    height: 300,
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
                              "On Interval",
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
                          Column(
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
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    this.setState(() {});
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: buttonColour,
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

  Future showAlertMessage(double amountNeeded) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Your Wallet Amount is Low"),
        content: const Text("You need to add more amount in Your wallet"),
        actions: <Widget>[
          ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: Text(
              "Add Money",
              style: TextStyle(
                  fontSize: 14, letterSpacing: 2.2, color: Colors.white),
            ),
            onPressed: () {
              // Navigator.of(ctx).pop();
              Get.to(() => WalletScreen(),
                  arguments: {"amountNeeded": amountNeeded});
            },
          ),
        ],
      ),
    );
  }

  apiCall() async {
    var SelectedAddressFromAPi = await getSelectedApi(id!, isSelected);
    setState(() {
      SelectedAddress = SelectedAddressFromAPi;
    });
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
      setState(() {
        addressId = body['id'];
      });
      print(addressId);

      return body['address_line1'] +
          "\n" +
          body['pincode'].toString() +
          " " +
          body['city'] +
          "\n" +
          body['state'] +
          " " +
          body['country'];
    } catch (e) {
      print(e.toString());
    }
  }
}
