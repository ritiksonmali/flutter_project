import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:get/get.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  List dropDownListData = [
    {"title": "HOME", "value": "1"},
    {"title": "OFFICE", "value": "2"},
    {"title": "Other", "value": "3"},
  ];

  String defaultValue = "";

  var ValueChoose;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Address",
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
      bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 48,
          child: MaterialButton(
            onPressed: () {
              if (defaultValue == "") {
                print("Please select a course");
              } else {
                print("user selected course $defaultValue");
              }
              print("hello");
              // checkoutProvider.validator(context, myType);
            },
            child: Text(
              "Add Address",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(15.0)
                    ),
                contentPadding: const EdgeInsets.all(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isDense: true,
                    value: defaultValue,
                    isExpanded: true,
                    menuMaxHeight: 350,
                    items: [
                      const DropdownMenuItem(
                          child: Text(
                            "Select Course",
                          ),
                          value: ""),
                      ...dropDownListData.map<DropdownMenuItem<String>>((data) {
                        return DropdownMenuItem(
                            child: Text(data['title']), value: data['value']);
                      }).toList(),
                    ],
                    onChanged: (value) {
                      print("selected Value $value");
                      setState(() {
                        defaultValue = value!;
                      });
                    }),
              ),
            ),
            // DropdownButton(
            //     alignment: Alignment.center,
            //     hint: Text("Select Address Type"),
            //     dropdownColor: Colors.white,
            //     icon: Icon(Icons.arrow_drop_down),
            //     iconSize: 36,
            //     isExpanded: true,
            //     items: AddressType.map((valueitem) {
            //       return DropdownMenuItem(
            //         alignment: Alignment.bottomLeft,
            //         value: valueitem,
            //         child: Text(valueitem),
            //       );
            //     }).toList(),
            //     value: ValueChoose,
            //     onChanged: (newValue) {
            //       setState(() {
            //         ValueChoose = newValue;
            //       });
            //     }),
            TextField(
              decoration: InputDecoration(
                labelText: "Address line 1",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "address line 2",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Pincode",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "city",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "State",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Country",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Telephone Number",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Mobile Number",
              ),
            ),
            InkWell(
              onTap: () {
                //  Navigator.of(context).push(
                //     MaterialPageRoute(
                //       // builder: (context) => CostomGoogleMap(),
                //     ),
                //   );
              },
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
