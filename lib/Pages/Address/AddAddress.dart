import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final _formKey3 = GlobalKey<FormState>();

  int? id;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);

    setState(() {
      this.id = id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  List dropDownListData = [
    {"title": "HOME", "value": "1"},
    {"title": "OFFICE", "value": "2"},
    {"title": "Other", "value": "3"},
  ];

  String defaultValue = "";

  TextEditingController addressLine1controller = new TextEditingController();
  TextEditingController addressLine2controller = new TextEditingController();
  TextEditingController citycontroller = new TextEditingController();
  TextEditingController statecontroller = new TextEditingController();
  TextEditingController countrycontroller = new TextEditingController();
  TextEditingController mobilenocontroller = new TextEditingController();
  TextEditingController telephonenocontroller = new TextEditingController();
  TextEditingController pincodecontroller = new TextEditingController();

  var ValueChoose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Address",
          style: TextStyle(fontSize: 18, color: black),
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
      bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 48,
          child: MaterialButton(
            onPressed: () {
              addpassword();
              if (defaultValue == "") {
                print("Please select a Address Type");
              } else {
                print("user selected Address Type $defaultValue");
              }
              print("hello");
              // checkoutProvider.validator(context, myType);
            },
            child: Text(
              "Add Address",
              style: TextStyle(
                color: white,
              ),
            ),
            color: black,
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
        child: Form(
          key: _formKey3,
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
                              "Select Address Type",
                            ),
                            value: ""),
                        ...dropDownListData
                            .map<DropdownMenuItem<String>>((data) {
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
              SizedBox(
                height: 10,
              ),
              Divider(
                color: black,
              ),
              TextFormField(
                controller: addressLine1controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Address line 1",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: addressLine2controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Address line 2",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: pincodecontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Pincode",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: citycontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "City",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: statecontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "State",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: countrycontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Country",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: telephonenocontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Telephone number",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(20)
                ],
                obscureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: mobilenocontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Mobile number",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                obscureText: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  addpassword() {
    if (_formKey3.currentState!.validate()) {
      print("Form is valid ");
      _formKey3.currentState!.save();
      addNewAddress(
          addressLine1controller.text.toString(),
          addressLine2controller.text.toString(),
          citycontroller.text.toString(),
          countrycontroller.text.toString(),
          mobilenocontroller.text.toString(),
          telephonenocontroller.text.toString(),
          statecontroller.text.toString(),
          int.parse(pincodecontroller.text.toString()));
    } else {
      print('Form is Not Valid');
    }
  }

  Future addNewAddress(String addressLine1, addressLine2, city, country,
      mobileno, telephoneno, state, int pincode) async {
    try {
      String url = 'http://10.0.2.2:8082/api/auth/addaddress';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "address_line1": addressLine1,
            "address_line2": addressLine2,
            "city": city,
            "country": country,
            "isSelected": false,
            "mobile_no": mobileno,
            "pincode": pincode,
            "state": state,
            "telephone_no": telephoneno,
            "user_id": this.id
          }));

      if (response.statusCode == 200) {
        print("Success");
        // setState(() {
        //   AddressDetails();
        // });
        // Get.back();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('New Address Added SuccessFully !'),
          backgroundColor: Colors.green,
        ));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please Enter Valid Data'),
          backgroundColor: Colors.redAccent,
        ));
        print("Please Enter Valid Data");
      } else if (response.statusCode == 400) {
        print("Bad Request");
      } else {
        print(this.id);
        printError();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
