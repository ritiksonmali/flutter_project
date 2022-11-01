import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_login_app/Pages/Address/AddAddress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({Key? key}) : super(key: key);

  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  List address = [
    {
      "createdDate": "2022-10-10",
      "lastModifiedDate": "2022-10-10",
      "id": 4,
      "address_line1": "Add Your Address",
      "address_line2": "",
      "pincode": "",
      "city": "",
      "state": "",
      "country": "",
      "telephone_no": "",
      "mobile_no": ""
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Address",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => Address());
        },
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
              itemCount: address.length,
              itemBuilder: (context, index) {
                var alladdress = address[index];
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
                                      " "
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
                                      fontWeight: FontWeight.w400),
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      alladdress['isSelected']
                                          ? ElevatedButton(
                                              onPressed: () {
                                                // productController.addtoCart(
                                                //     this.id!, allproduct);
                                                // cartController.addtoCart(
                                                //     productController
                                                //         .productData[index]);
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.black,
                                              ),
                                              child: Text(
                                                'Select',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            )
                                          : Text("selected"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              })),
    );
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    var AddressFromApi = await getAddressApi(id);
    setState(() {
      address = AddressFromApi;
    });
  }

  getAddressApi(int id) async {
    try {
      String url = 'http://10.0.2.2:8082/api/auth/getaddressbyuser/${id}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      var body = jsonDecode(response.body);
      print(body);
      return body;
    } catch (e) {
      print(e.toString());
    }
  }
}



// body: ListView(
//         children: [
//           ListTile(
//             title: Text("Address"),
//           ),
//           Divider(
//             height: 1,
//           ),
          
//         ],
//       ),