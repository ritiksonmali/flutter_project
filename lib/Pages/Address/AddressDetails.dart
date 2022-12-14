import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AddressController.dart';
import 'package:flutter_login_app/Pages/Address/AddAddress.dart';
import 'package:flutter_login_app/Pages/Address/UpdateAddress.dart';
import 'package:flutter_login_app/Pages/cart/Checkout.dart';
import 'package:flutter_login_app/Pages/cart/cart_screen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    // TODO: implement initState
    super.initState();
    test();
    addressController.getAddressApi();
  }

  List address = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Address",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: black,
        child: Icon(Icons.add),
        onPressed: () async {
          final value = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Address()),
          );
          setState(() {
            // test();
            addressController.getAddressApi();
          });
        },
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          child: GetBuilder<AddressController>(builder: (controller) {
            return ListView.builder(
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
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    alladdress["address_line1"] +
                                        "\n" +
                                        alladdress["address_line2"] +
                                        "\n" +
                                        "City : " +
                                        alladdress["city"] +
                                        "\n"
                                            "Pincode : " +
                                        alladdress["pincode"].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    alladdress["state"] +
                                        " " +
                                        alladdress["country"] +
                                        "\n" +
                                        "telephone / Mobile no : " +
                                        alladdress["telephone_no"] +
                                        " / " +
                                        alladdress["mobile_no"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                setState(() {
                                                  test();
                                                });
                                                Get.to(() => UpdateAddress(),
                                                    arguments: {
                                                      'addressId':
                                                          alladdress['id'],
                                                      'userId': this.userId,
                                                      'addressline1':
                                                          alladdress[
                                                              'address_line1'],
                                                      'addressline2':
                                                          alladdress[
                                                              'address_line2'],
                                                      'pincode':
                                                          alladdress['pincode']
                                                              .toString(),
                                                      'city':
                                                          alladdress['city'],
                                                      'state':
                                                          alladdress['state'],
                                                      'country':
                                                          alladdress['country'],
                                                      'telephoneno': alladdress[
                                                              'telephone_no']
                                                          .toString(),
                                                      'mobileno': alladdress[
                                                              'mobile_no']
                                                          .toString(),
                                                      'isselected': alladdress[
                                                          'isSelected'],
                                                    });
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () async {
                                                addressController
                                                    .setAddressStatusInactive(
                                                        alladdress['id']);
                                                await Future.delayed(
                                                    Duration(seconds: 1));
                                                setState(() {
                                                  test();
                                                  addressController.address
                                                      .clear();
                                                  addressController.onReady();
                                                });
                                              },
                                              icon: Icon(Icons.delete)),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            alladdress['isSelected'] == true
                                                ? Text('Selected',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16))
                                                : ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        checkAddressIsSelected(
                                                            this.userId!,
                                                            alladdress['id']);
                                                      });
                                                      await Future.delayed(
                                                          Duration(seconds: 2));
                                                      // Navigator.pushAndRemoveUntil(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           CheckoutScreen()), // this mymainpage is your page to refresh
                                                      //   (Route<dynamic> route) =>
                                                      //       true,
                                                      // );
                                                      Navigator.pop(context);
                                                      addressController
                                                          .getAddressApi();
                                                      // Navigator.pop(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             CartScreen()));
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: black,
                                                    ),
                                                    child: Text(
                                                      'Select',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
      this.userId = id;
      // address = AddressFromApi;
    });
  }

  getAddressApi(int id) async {
    try {
      String url = serverUrl + 'api/auth/getaddressbyuser/${id}';
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
        serverUrl + 'api/auth/updateaddressIsSelected/${addressId}/${userId}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
