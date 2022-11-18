import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Pages/Address/AddAddress.dart';
import 'package:flutter_login_app/Pages/cart/Checkout.dart';
import 'package:flutter_login_app/Pages/cart/cart_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({Key? key}) : super(key: key);

  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  int? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
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
            test();
          });
        },
        // onPressed: () {

        //   // Get.to(() => Address());
        // },
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
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        alladdress["address_line1"] +
                                            "\n" +
                                            alladdress["address_line2"] +
                                            "\n" +
                                            alladdress["city"] ,
                                        style: Theme.of(context).textTheme.bodyMedium
                                      ),
                                    ),
                                  
                                  IconButton(onPressed: () {

                                  },
                                  icon: Icon(
                                      Icons.delete,
                                      color: black,
                                    ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        alladdress["state"] +
                                            " " +
                                            alladdress["country"] +
                                            "\n" +
                                             alladdress["pincode"].toString()+
                                             "\n"+
                                            "Telephone :" +
                                            alladdress["telephone_no"]+ "\n"+"Mobile no : "+
                                            alladdress["mobile_no"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                   
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                    padding:  const EdgeInsets.only( right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        alladdress['isSelected'] == true
                                            ? ElevatedButton(
                                              child: Text(
                                                  'Selected',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                 style: TextButton.styleFrom(
                                                  backgroundColor: black,
                                                ),
                                               onPressed: () {}
                                            )
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    checkAddressIsSelected(
                                                        this.userId!,
                                                        alladdress['id']);
                                                  });
                                                  await Future.delayed(
                                                      Duration(seconds: 2));
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: black,
                                                ),
                                                child: Text(
                                                  'Select',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              )
                                      ],
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
      this.userId = id;
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
      return body;
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkAddressIsSelected(int userId, addressId) async {
    String url =
        'http://10.0.2.2:8082/api/auth/updateaddressIsSelected/${addressId}/${userId}';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
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
