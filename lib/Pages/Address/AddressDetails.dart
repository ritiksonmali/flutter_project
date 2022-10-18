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
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
            height: 20,
          ),
          itemCount: address.length,
          itemBuilder: (context, index) {
            var alladdress = address[index];
            return ListTile(
              title: Text(alladdress["address_line1"] +
                  "\n" +
                  alladdress["address_line2"] +
                  "\n" +
                  "City : " +
                  alladdress["city"] +
                  " "
                      "Pincode : " +
                  alladdress["pincode"].toString()),
              subtitle: Text(alladdress["state"] +
                  " " +
                  alladdress["country"] +
                  "\n" +
                  "telephone / Mobile no : " +
                  alladdress["telephone_no"] +
                  " / " +
                  alladdress["mobile_no"]),
            );
          },
        ),
      ),
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