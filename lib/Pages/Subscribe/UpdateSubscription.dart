// ignore_for_file: unnecessary_const

import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/ApplicationParameterController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Controller/SubscribeProductController.dart';
import 'package:flutter_login_app/Pages/Address/AddressDetails.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_fade/image_fade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class UpdateSubscription extends StatefulWidget {
  const UpdateSubscription({Key? key}) : super(key: key);

  @override
  State<UpdateSubscription> createState() => _UpdateSubscriptionState();
}

class _UpdateSubscriptionState extends State<UpdateSubscription> {
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
  DateTime date = DateTime.now().add(const Duration(days: 1, hours: 5));
  DateTime todayDate = DateTime.now().add(const Duration(days: 2, hours: 5));
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
  bool _selected = true;

  List listItemSorting = [
    // '09:00 AM',
    // '02:00 PM',
    // '05:00 PM',
    // '08:00 PM',
  ];

  String? CurrentDate;
  String? valueChoose;
  // String? initialValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimeSlots();
    valueChoose = argument['time'] as String;
    print(valueChoose);
    test();
    // formattedDate = DateFormat('EEE, MMM d, yyyy').format(date);
    formattedDate =
        argument['startDate'] != null ? argument['startDate'] : null;
    endsDate = argument['endDate'] != null ? argument['endDate'] : null;
    counter = argument['quantity'];
    argument['frequency'] == 1 ? selectEveryDay = true : null;
    argument['frequency'] >= 2 ? selectOnInterval = true : null;
    argument['frequency'] == 2 ? check2nd = true : null;
    argument['frequency'] == 3 ? check3rd = true : null;
    argument['frequency'] == 4 ? check4th = true : null;
    argument['frequency'] == 5 ? check5th = true : null;
    frequency = argument['frequency'];
    // argument['time'] == '9:00 AM' ? valueChoose = listItemSorting[0] : null;
    // argument['time'] == '2:00 PM' ? valueChoose = listItemSorting[1] : null;
    // argument['time'] == '5:00 PM' ? valueChoose = listItemSorting[2] : null;
    // argument['time'] == '8:00 PM' ? valueChoose = listItemSorting[3] : null;
    // valueChoose = listItemSorting[0];
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
    // DateTime now = DateTime.now();
    // CurrentDate = DateFormat('dd-MM-yyyy').format(date);
    // String finalDate = CurrentDate! + " " + "09:00";
    // DateTime DateFromPicker = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate);
    // String finalDate1 = CurrentDate! + " " + "14:00";
    // DateTime DateFromPicker1 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate1);
    // String finaltime2 = CurrentDate! + " " + "17:00";
    // DateTime DateFromPicker2 = DateFormat('dd-MM-yyyy hh:mm').parse(finaltime2);
    // String finalDate3 = CurrentDate! + " " + "20:00";
    // DateTime DateFromPicker3 = DateFormat('dd-MM-yyyy hh:mm').parse(finalDate3);
    // String finalDate4 = CurrentDate! + " " + "00:00";
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text(
          "Product Details",
          style: Theme.of(context).textTheme.headline5!.apply(color: white),
        ),
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
        child: SizedBox(
          // height: 350,
          child: GetBuilder<SubscribeProductController>(builder: (controller) {
            return controller.isloading.value
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                margin: const EdgeInsets.only(top: 30),
                                width: 280,
                                height: 180,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[100],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 50,
                                          height: 15,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 80,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 10, right: 10),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[300],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 20,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 250,
                                      height: 15,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 200,
                                      height: 15,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 10, right: 10),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[300],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 200,
                                      height: 15,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 10, right: 10),
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[300],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 15,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: 200,
                                      height: 15,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        subscribeProductController.subscribeProdutList.length,
                    // scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      var product =
                          subscribeProductController.subscribeProdutList[index];
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: grey),
                              width: 350,
                              height: 180,
                              child: ImageFade(
                                  image: NetworkImage(
                                      '${serverUrl}api/auth/serveproducts/${product['imageUrl'].toString()}'),
                                  fit: BoxFit.fitHeight,
                                  // scale: 2,
                                  placeholder: Image.file(
                                    fit: BoxFit.fitHeight,
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['name'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                color:
                                                    product['isVegan'] == true
                                                        ? Colors.green
                                                        : Colors.red,
                                                size: 8),
                                          ],
                                        ),
                                        Text('${product['weight'].toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium)
                                      ],
                                    ),
                                  ],
                                ),
                                Text("\₹ ${product['price'].toString()} ",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Duration",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          ),
                          const SizedBox(
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
                                      color: white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
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
                                                const TextSpan(
                                                    text: '05:00 PM Today ',
                                                    style: const TextStyle(
                                                        color: buttonColour)),
                                                TextSpan(
                                                    text:
                                                        '& get the delivery by ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                                TextSpan(
                                                    text: DateFormat(
                                                            'EEE, MMM d, yyyy')
                                                        .format(
                                                      todayDate
                                                          .toUtc()
                                                          .toLocal(),
                                                    ),
                                                    style: const TextStyle(
                                                        color: buttonColour)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Starts On",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await showDatePicker(
                                                              context: context,
                                                              initialDate: DateTime
                                                                      .now()
                                                                  .add(const Duration(
                                                                      days: 1,
                                                                      hours:
                                                                          5)),
                                                              firstDate: DateTime
                                                                      .now()
                                                                  .add(const Duration(
                                                                      days: 1,
                                                                      hours:
                                                                          5)),
                                                              lastDate:
                                                                  DateTime(
                                                                      2030),
                                                            ).then(
                                                                (selectedDate) {
                                                              if (selectedDate !=
                                                                  null) {
                                                                setState(() {
                                                                  endDate =
                                                                      null;
                                                                  endsDate =
                                                                      null;
                                                                  date =
                                                                      selectedDate;
                                                                  formattedDate =
                                                                      DateFormat(
                                                                              'EEE, MMM d, yyyy')
                                                                          .format(
                                                                              selectedDate);
                                                                  getTimeSlots();
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
                                                            formattedDate,
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                // fontWeight: FontWeight.w500,
                                                                color: buttonColour),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward,
                                                      color: black,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("Ends On",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate: date.add(
                                                                      const Duration(
                                                                          days:
                                                                              2,
                                                                          hours:
                                                                              5)),
                                                                  firstDate: date.add(
                                                                      const Duration(
                                                                          days:
                                                                              2,
                                                                          hours:
                                                                              5)),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2030),
                                                                ).then(
                                                                    (selectedDate) {
                                                                  if (selectedDate !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      // valueChoose = null;
                                                                      endDate =
                                                                          selectedDate;
                                                                      endsDate = DateFormat(
                                                                              'EEE, MMM d, yyyy')
                                                                          .format(
                                                                              selectedDate);
                                                                      MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              super.widget);
                                                                      // print(date);
                                                                      // print(formattedDate);
                                                                    });
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                endsDate ??
                                                                    "Optional",
                                                                style: const TextStyle(
                                                                    fontSize: 13,
                                                                    // fontWeight: FontWeight.w500,
                                                                    color: buttonColour),
                                                              ),
                                                            ),
                                                            endsDate != null
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        endsDate =
                                                                            null;
                                                                        endDate =
                                                                            null;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              7),
                                                                      child:
                                                                          Container(
                                                                        // margin: EdgeInsets.all(100.0),
                                                                        decoration: const BoxDecoration(
                                                                            color:
                                                                                white,
                                                                            shape:
                                                                                BoxShape.circle),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .clear,
                                                                          size:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    decoration: BoxDecoration(
                                                        color: buttonColour,
                                                        border: Border.all(
                                                            color: buttonColour,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (listItemSorting
                                                            .isEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            content: const Text(
                                                                'There is no time slot available for today please select another days time slot'),
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          ));
                                                        }
                                                      },
                                                      child: DropdownButton(
                                                        underline:
                                                            const SizedBox(),
                                                        hint: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 14),
                                                          child: Text('select',
                                                              style: TextStyle(
                                                                  color:
                                                                      white)),
                                                        ),
                                                        dropdownColor:
                                                            Colors.white,
                                                        icon: const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: white,
                                                        ),
                                                        iconSize: 20,
                                                        isExpanded: true,
                                                        value: valueChoose,

                                                        // onChanged: (newValue) {
                                                        //   setState(() {
                                                        //     valueChoose =
                                                        //         newValue as String;
                                                        //     print(
                                                        //         "Choosed Value is :${valueChoose}");
                                                        //     MaterialPageRoute(
                                                        //         builder: (BuildContext
                                                        //                 context) =>
                                                        //             super.widget);
                                                        //   });
                                                        // },
                                                        selectedItemBuilder:
                                                            (BuildContext
                                                                context) {
                                                          return listItemSorting
                                                              .map((value) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 14),
                                                              child: Text(
                                                                value,
                                                                style: const TextStyle(
                                                                    color:
                                                                        white),
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                        items: listItemSorting
                                                            .map((valueItem) {
                                                          return DropdownMenuItem(
                                                              value: valueItem,
                                                              child: Text(
                                                                  valueItem));
                                                        }).toList(),
                                                        onChanged: (value) =>
                                                            setState(
                                                          () {
                                                            if (value != null) {
                                                              valueChoose = value
                                                                  .toString();
                                                            }
                                                          },
                                                        ),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                      color: white),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectEveryDay = true;
                                                          selectOnInterval =
                                                              false;
                                                          check2nd = false;
                                                          check3rd = false;
                                                          check4th = false;
                                                          check5th = false;
                                                          frequency = 1;
                                                        });
                                                        // bottomSheetForEveryDay();
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 8,
                                                            left: 12,
                                                            top: 1,
                                                            bottom: 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: selectEveryDay
                                                              ? buttonColour
                                                              : null,
                                                          border: Border.all(
                                                              color:
                                                                  buttonColour),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        child: Text(
                                                          "Everyday",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color: selectEveryDay
                                                                  ? white
                                                                  : buttonColour),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectOnInterval =
                                                              true;
                                                          selectEveryDay =
                                                              false;
                                                          frequency = null;
                                                        });
                                                        buildBottomSheet();
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 8,
                                                            left: 12,
                                                            top: 1,
                                                            bottom: 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              selectOnInterval
                                                                  ? buttonColour
                                                                  : null,
                                                          border: Border.all(
                                                              color:
                                                                  buttonColour),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        child: Text(
                                                          "On Interval",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color: selectOnInterval
                                                                  ? white
                                                                  : buttonColour),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                // const Divider(
                                                //   thickness: 1,
                                                //   height: 10,
                                                //   color: black,
                                                // ),
                                                selectEveryDay == true ||
                                                        check2nd == true ||
                                                        check3rd == true ||
                                                        check4th == true ||
                                                        check5th == true
                                                    ? Column(
                                                        children: [
                                                          const SizedBox(
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
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text('Interval',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .titleSmall),
                                                              Text(
                                                                  selectEveryDay ==
                                                                          true
                                                                      ? "Everyday"
                                                                      : false ||
                                                                              check2nd == true
                                                                          ? "Every 2nd Day"
                                                                          : false || check3rd == true
                                                                              ? "Every 3rd Day"
                                                                              : false || check4th == true
                                                                                  ? "Every 4th Day"
                                                                                  : false || check5th == true
                                                                                      ? "Every 5th Day"
                                                                                      : '',
                                                                  style: Theme.of(context).textTheme.titleSmall),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                      color: white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            subscribeProductController.subscribeProdutList[
                                                                    index]
                                                                ['inventory']
                                                            ['quantity'] >
                                                        0 &&
                                                    ApplicationParameterController
                                                        .isOrdersEnable.value
                                                ? Container(
                                                    width: 180,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
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
                                                                    EdgeInsets
                                                                        .zero,
                                                                child: SizedBox(
                                                                  height: 50,
                                                                  width: 35,
                                                                  child:
                                                                      IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .remove),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (counter >
                                                                            1) {
                                                                          counter--;
                                                                        } else {
                                                                          Fluttertoast.showToast(
                                                                              msg: 'quantity always greater than 1',
                                                                              fontSize: 18,
                                                                              backgroundColor: buttonColour,
                                                                              textColor: white);
                                                                          // counter = 0;
                                                                          // isAdded = false;
                                                                        }
                                                                      });
                                                                    },
                                                                    color:
                                                                        white,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                counter
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color:
                                                                        white),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                child: SizedBox(
                                                                  height: 50,
                                                                  width: 30,
                                                                  child:
                                                                      IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .add),
                                                                    color:
                                                                        white,
                                                                    onPressed:
                                                                        () {
                                                                      if (subscribeProductController.subscribeProdutList[index]['inventory']
                                                                              [
                                                                              'quantity'] >
                                                                          counter) {
                                                                        setState(
                                                                            () {
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
                                                            style: TextButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  buttonColour,
                                                            ),
                                                            child: const Text(
                                                                "Add",
                                                                style:
                                                                    TextStyle(
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                      color: white),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 00),
                                                child: SizedBox(
                                                  child: SelectedAddress == null
                                                      ? const Text(
                                                          'Select Your Address')
                                                      : Text(
                                                          SelectedAddress
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge),
                                                ),
                                              ),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          buttonColour),
                                                  onPressed: () async {
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    final value =
                                                        // ignore: use_build_context_synchronously
                                                        await Navigator.push(
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
                                                      style: TextStyle(
                                                          color: white))),
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
                                            DateTime time2 =
                                                DateFormat("hh:mm a")
                                                    .parse(valueChoose!);
                                            subscribeProductController
                                                .updateSubscription(
                                                    argument['orderId'],
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(DateFormat(
                                                                "EEE, MMM d, yyyy")
                                                            .parse(
                                                                formattedDate)),
                                                    endDate != null
                                                        ? DateFormat(
                                                                'dd-MM-yyyy')
                                                            .format(DateFormat(
                                                                    "EEE, MMM d, yyyy")
                                                                .parse(
                                                                    endsDate))
                                                        : null,
                                                    DateFormat('HH:mm:ss')
                                                        .format(time2),
                                                    frequency!,
                                                    counter)
                                                .then((value) {
                                              subscribeProductController
                                                  .subscribeProductDetailsList
                                                  .clear();
                                              subscribeProductController
                                                  .getSubscribeProductDetails();
                                              Get.back();
                                            });
                                            // subscribeProductController
                                            //     .subscribeProduct(
                                            //         DateFormat('dd-MM-yyyy')
                                            //             .format(date),
                                            //         endDate != null
                                            //             ? DateFormat('dd-MM-yyyy')
                                            //                 .format(endDate!)
                                            //             : null,
                                            //         DateFormat('HH:mm:ss')
                                            //             .format(time2),
                                            //         frequency!,
                                            //         counter,
                                            //         this.addressId.toString(),
                                            //         subscribeProductController
                                            //             .subscribeProdutList[index]
                                            //                 ['id']
                                            //             .toString(),
                                            //         id.toString());
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  'Please Select Your Address'),
                                              backgroundColor: Colors.redAccent,
                                            ));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            duration:
                                                const Duration(seconds: 1),
                                            content: Text(
                                                'Please increase product quantity'),
                                            backgroundColor: Colors.redAccent,
                                          ));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          duration: Duration(seconds: 1),
                                          content:
                                              Text('Please Select Frequency'),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: const Text(
                                            'Please Select time Slot'),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: buttonColour,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Center(
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
        ),
      ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
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
                              const SizedBox(
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
                                    child: const Center(
                                      child: const Text(
                                        "Submit",
                                        style: const TextStyle(
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

  apiCall() async {
    var SelectedAddressFromAPi = await getSelectedApi(id!, isSelected);
    setState(() {
      SelectedAddress = SelectedAddressFromAPi;
    });
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
      List<dynamic> timeSlotList = jsonDecode(response.body);
      DateTime currentDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(DateTime.now().toString());
      for (var slot in timeSlotList) {
        DateTime selectedDate =
            DateFormat("EEE, MMM d, yyyy").parse(formattedDate);
        String parsedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
        DateTime pickedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse("$parsedDate ${slot['shortDesc']}");
        if (currentDate.isAfter(pickedDate) &&
            pickedDate.year == currentDate.year &&
            pickedDate.month == currentDate.month &&
            pickedDate.day != currentDate.day) {
          String finalTimeSLot = DateFormat("hh:mm a").format(pickedDate);
          print(finalTimeSLot);
          setState(() {
            selectedTimeSLots.add(finalTimeSLot);
          });
        } else if (currentDate.isBefore(pickedDate)) {
          String finalTimeSLot = DateFormat("hh:mm a").format(pickedDate);
          print(pickedDate);
          setState(() {
            selectedTimeSLots.add(finalTimeSLot);
          });
        }
        setState(() {
          listItemSorting = selectedTimeSLots;
        });
      }
    } else {
      print('failed');
    }
  }
}
