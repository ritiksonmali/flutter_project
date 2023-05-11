// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AddressController.dart';
import 'package:flutter_login_app/Pages/Address/AddAddress.dart';
import 'package:flutter_login_app/Pages/Address/UpdateAddress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../ConstantUtil/globals.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({Key? key}) : super(key: key);

  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  int? userId;

  AddressController addressController = Get.put(AddressController());
  @override
  void initState() {
    super.initState();
    test();
    addressController.getAddressApi();
  }

  List address = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Address",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColour,
        child: const Icon(Icons.add),
        onPressed: () async {
          final value = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Address()),
          );
          setState(() {
            // test();
            addressController.getAddressApi();
          });
        },
      ),
      body: Container(
          color: grey,
          padding: const EdgeInsets.all(5),
          child: GetBuilder<AddressController>(builder: (controller) {
            return addressController.isloading.value == true
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          5, // number of shimmer placeholders you want to show
                      itemBuilder: (_, __) => Card(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 150,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 250,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 100,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 20,
                                        width: 150,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 70,
                                                color: Colors.grey[300],
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                height: 30,
                                                width: 70,
                                                color: Colors.grey[300],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                            width: 100,
                                            color: Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : addressController.address.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 300,
                          ),
                          const Text(
                            'Add Your Address',
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
                            'Address is not added please add your address',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: addressController.address.length,
                        itemBuilder: (context, index) {
                          var alladdress = addressController.address[index];
                          return Card(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            alladdress["address_line1"] +
                                                "," +
                                                "\n" +
                                                alladdress["address_line2"] +
                                                "," +
                                                "\n" +
                                                alladdress["city"] +
                                                "," +
                                                "\n" +
                                                alladdress["pincode"]
                                                    .toString() +
                                                ",",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          // SizedBox(height: 10),
                                          Text(
                                            alladdress["state"] +
                                                " " +
                                                alladdress["country"],
                                            //  +
                                            // "\n" +
                                            // "telephone / Mobile no : " +
                                            // alladdress["telephone_no"],
                                            //  +
                                            // " / " +
                                            // alladdress["mobile_no"],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  // IconButton(
                                                  //     onPressed: () async {
                                                  //       setState(() {
                                                  //         test();
                                                  //       });
                                                  //       Get.to(
                                                  //           () =>
                                                  //               UpdateAddress(),
                                                  //           arguments: {
                                                  //             'addressId':
                                                  //                 alladdress[
                                                  //                     'id'],
                                                  //             'userId':
                                                  //                 this.userId,
                                                  //             'addressline1':
                                                  //                 alladdress[
                                                  //                     'address_line1'],
                                                  //             'addressline2':
                                                  //                 alladdress[
                                                  //                     'address_line2'],
                                                  //             'pincode': alladdress[
                                                  //                     'pincode']
                                                  //                 .toString(),
                                                  //             'city':
                                                  //                 alladdress[
                                                  //                     'city'],
                                                  //             'state':
                                                  //                 alladdress[
                                                  //                     'state'],
                                                  //             'country':
                                                  //                 alladdress[
                                                  //                     'country'],
                                                  //             'countryId': alladdress[
                                                  //                     'countryId']
                                                  //                 .toString(),
                                                  //             'stateId': alladdress[
                                                  //                     'stateId']
                                                  //                 .toString(),
                                                  //             'cityId': alladdress[
                                                  //                     'cityId']
                                                  //                 .toString(),
                                                  //             'isselected':
                                                  //                 alladdress[
                                                  //                     'isSelected'],
                                                  //           });
                                                  //     },
                                                  //     icon: Icon(Icons.edit)),
                                                  ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints
                                                                .tightFor(
                                                            height: 30),
                                                    child: ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        backgroundColor:
                                                            buttonColour,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          test();
                                                        });
                                                        Get.to(
                                                            () =>
                                                                const UpdateAddress(),
                                                            arguments: {
                                                              'addressId':
                                                                  alladdress[
                                                                      'id'],
                                                              'userId': userId,
                                                              'addressline1':
                                                                  alladdress[
                                                                      'address_line1'],
                                                              'addressline2':
                                                                  alladdress[
                                                                      'address_line2'],
                                                              'pincode': alladdress[
                                                                      'pincode']
                                                                  .toString(),
                                                              'city':
                                                                  alladdress[
                                                                      'city'],
                                                              'state':
                                                                  alladdress[
                                                                      'state'],
                                                              'country':
                                                                  alladdress[
                                                                      'country'],
                                                              'countryId': alladdress[
                                                                      'countryId']
                                                                  .toString(),
                                                              'stateId': alladdress[
                                                                      'stateId']
                                                                  .toString(),
                                                              'cityId': alladdress[
                                                                      'cityId']
                                                                  .toString(),
                                                              'isselected':
                                                                  alladdress[
                                                                      'isSelected'],
                                                            });
                                                      },
                                                      child: const Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ), // <-- Text
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints
                                                                .tightFor(
                                                            height: 30),
                                                    child: ElevatedButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        backgroundColor:
                                                            buttonCancelColour,
                                                      ),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Alert"),
                                                              content: const Text(
                                                                  "Do you want to delete this address"),
                                                              actions: [
                                                                ElevatedButton(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          buttonCancelColour,
                                                                    ),
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
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
                                                                      addressController
                                                                          .setAddressStatusInactive(
                                                                              alladdress['id']);
                                                                      await Future.delayed(const Duration(
                                                                          seconds:
                                                                              1));
                                                                      setState(
                                                                          () {
                                                                        test();
                                                                        // addressController
                                                                        //     .address
                                                                        //     .clear();
                                                                        addressController
                                                                            .onReady();
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
                                                                FontWeight
                                                                    .normal),
                                                      ), // <-- Text
                                                    ),
                                                  ),
                                                  // IconButton(
                                                  //     onPressed: () async {
                                                  //       showDialog(
                                                  //         context: context,
                                                  //         builder: (context) {
                                                  //           return AlertDialog(
                                                  //             title:
                                                  //                 Text("Alert"),
                                                  //             content: Text(
                                                  //                 "Do you want to delete this address"),
                                                  //             actions: [
                                                  //               ElevatedButton(
                                                  //                   style: TextButton
                                                  //                       .styleFrom(
                                                  //                     backgroundColor:
                                                  //                         black,
                                                  //                   ),
                                                  //                   onPressed: () =>
                                                  //                       Navigator.of(context)
                                                  //                           .pop(),
                                                  //                   child: Text(
                                                  //                       'No')),
                                                  //               ElevatedButton(
                                                  //                   style: TextButton
                                                  //                       .styleFrom(
                                                  //                     backgroundColor:
                                                  //                         black,
                                                  //                   ),
                                                  //                   onPressed:
                                                  //                       () async {
                                                  //                     Navigator.of(
                                                  //                             context)
                                                  //                         .pop();
                                                  //                     addressController
                                                  //                         .setAddressStatusInactive(
                                                  //                             alladdress['id']);
                                                  //                     await Future.delayed(Duration(
                                                  //                         seconds:
                                                  //                             1));
                                                  //                     setState(
                                                  //                         () {
                                                  //                       test();
                                                  //                       // addressController
                                                  //                       //     .address
                                                  //                       //     .clear();
                                                  //                       addressController
                                                  //                           .onReady();
                                                  //                     });
                                                  //                   },
                                                  //                   child: Text(
                                                  //                       'Yes'))
                                                  //             ],
                                                  //           );
                                                  //         },
                                                  //       );
                                                  //     },
                                                  //     icon: Icon(Icons.delete)),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    alladdress['isSelected'] ==
                                                            true
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: const Text(
                                                                'Selected',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16)),
                                                          )
                                                        : ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                checkAddressIsSelected(
                                                                    userId!,
                                                                    alladdress[
                                                                        'id']);
                                                              });
                                                              await Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          2));
                                                              // Navigator.pushAndRemoveUntil(
                                                              //   context,
                                                              //   MaterialPageRoute(
                                                              //       builder: (context) =>
                                                              //           CheckoutScreen()), // this mymainpage is your page to refresh
                                                              //   (Route<dynamic> route) =>
                                                              //       true,
                                                              // );
                                                              Navigator.pop(
                                                                  context);
                                                              addressController
                                                                  .getAddressApi();
                                                              // Navigator.pop(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) =>
                                                              //             CartScreen()));
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  buttonColour,
                                                            ),
                                                            child: const Text(
                                                              'Select',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
          })),
    );
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    // var AddressFromApi = await getAddressApi(id);
    setState(() {
      userId = id;
      // address = AddressFromApi;
    });
  }

  getAddressApi(int id) async {
    try {
      String url = '${serverUrl}api/auth/getaddressbyuser/$id';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      return body;
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkAddressIsSelected(int userId, addressId) async {
    String url =
        '${serverUrl}api/auth/updateaddressIsSelected/$addressId/$userId';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
