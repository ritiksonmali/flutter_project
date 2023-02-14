import 'dart:convert';
import 'dart:ffi';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AddressController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantUtil/globals.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final _formKey3 = GlobalKey<FormState>();
  AddressController addressController = Get.find();

  int? id;
  final String status = "ACTIVE";

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
    getCountry();
  }

  getCountry() async {
    var listFromAPi =
        await addressController.getCountryCityState('', "COUNTRY");
    setState(() {
      country = listFromAPi;
    });
  }

  getState(String parent, type) async {
    var listFromAPi1 =
        await addressController.getCountryCityState(parent, type);
    setState(() {
      state = listFromAPi1;
      MaterialPageRoute(builder: (BuildContext context) => super.widget);
    });
  }

  getCity(String parent, type) async {
    var listFromAPi2 =
        await addressController.getCountryCityState(parent, type);
    setState(() {
      city = listFromAPi2;
      MaterialPageRoute(builder: (BuildContext context) => super.widget);
    });
  }

  List dropDownListData = [
    {"title": "Home", "value": "1"},
    {"title": "Office", "value": "2"},
    {"title": "Other", "value": "3"},
  ];

  List country = [];
  List state = [];
  List city = [];

  String defaultValue = "";
  SingleValueDropDownController countryDropDownController =
      new SingleValueDropDownController();

  SingleValueDropDownController stateDropDownController =
      new SingleValueDropDownController();
  SingleValueDropDownController cityDropDownController =
      new SingleValueDropDownController();

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  TextEditingController addressLine1controller = new TextEditingController();
  TextEditingController addressLine2controller = new TextEditingController();
  TextEditingController citycontroller = new TextEditingController();
  TextEditingController statecontroller = new TextEditingController();
  TextEditingController countrycontroller = new TextEditingController();
  // TextEditingController mobilenocontroller = new TextEditingController();
  // TextEditingController telephonenocontroller = new TextEditingController();
  TextEditingController pincodecontroller = new TextEditingController();

  var ValueChoose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Address",
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
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Address line 1',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: black,
                            ),
                            children: [
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ],
                  ),
                  // hintText: "Address line 1",
                  // hintStyle: TextStyle(
                  //   fontSize: 16,
                  //   // fontWeight: FontWeight.bold,
                  //   color: black,
                  // )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: addressLine2controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Address line 2',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: black,
                            ),
                            children: [
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ],
                  ),
                  // hintText: "Address line 2",
                  // hintStyle: TextStyle(
                  //   fontSize: 16,
                  //   // fontWeight: FontWeight.bold,
                  //   color: black,
                  // )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pincodecontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 3),
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Pincode',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                              color: black,
                            ),
                            children: [
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value!.length != 6)
                    return 'Pincode must be of 6 digit';
                  else
                    return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              DropDownTextField(
                  clearOption: false,
                  controller: countryDropDownController,
                  textFieldFocusNode: textFieldFocusNode,
                  searchFocusNode: searchFocusNode,
                  // searchAutofocus: true,
                  dropDownItemCount: 8,
                  enableSearch: true,
                  textFieldDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 3),
                      labelStyle:
                          TextStyle(height: 10, fontWeight: FontWeight.bold),
                      label: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Country',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ],
                      ),
                      hintText: "Select Country"),
                  searchShowCursor: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  listSpace: 2,
                  dropDownList: country.map((valueItem) {
                    return DropDownValueModel(
                        name: valueItem['name'].toString(),
                        value: valueItem['id'].toString());
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      stateDropDownController.dropDownValue = null;
                      cityDropDownController.dropDownValue = null;
                    });
                    print(countryDropDownController.dropDownValue!.value);
                    getState(countryDropDownController.dropDownValue!.value,
                        "STATE");
                  }),
              SizedBox(
                height: 20,
              ),
              DropDownTextField(
                  clearOption: false,
                  controller: stateDropDownController,
                  textFieldFocusNode: textFieldFocusNode,
                  searchFocusNode: searchFocusNode,
                  // searchAutofocus: true,
                  dropDownItemCount: 8,
                  textFieldDecoration: InputDecoration(
                      label: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'State',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ],
                      ),
                      hintText: "Select State"),
                  enableSearch: true,
                  searchShowCursor: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  listSpace: 2,
                  dropDownList: state.map((valueItem) {
                    return DropDownValueModel(
                        name: valueItem['name'].toString(),
                        value: valueItem['id'].toString());
                  }).toList(),
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      cityDropDownController.dropDownValue = null;
                    });
                    print(stateDropDownController.dropDownValue!.value);
                    getCity(
                        stateDropDownController.dropDownValue!.value, "CITY");
                  }),
              SizedBox(
                height: 20,
              ),
              DropDownTextField(
                  controller: cityDropDownController,
                  clearOption: false,
                  textFieldFocusNode: textFieldFocusNode,
                  searchFocusNode: searchFocusNode,
                  // searchAutofocus: true,
                  dropDownItemCount: 8,
                  textFieldDecoration: InputDecoration(
                      label: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'City',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ],
                      ),
                      hintText: "Select City"),
                  enableSearch: true,
                  searchShowCursor: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  listSpace: 2,
                  dropDownList: city.map((valueItem) {
                    return DropDownValueModel(
                        name: valueItem['name'].toString(),
                        value: valueItem['id'].toString());
                  }).toList(),
                  onChanged: (value) {}),
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
          cityDropDownController.dropDownValue!.value.toString(),
          countryDropDownController.dropDownValue!.value.toString(),
          // mobilenocontroller.text.toString(),
          // telephonenocontroller.text.toString(),
          stateDropDownController.dropDownValue!.value.toString(),
          int.parse(pincodecontroller.text.toString()));
    } else {
      print('Form is Not Valid');
    }
  }

  Future addNewAddress(String addressLine1, addressLine2, city, country, state,
      int pincode) async {
    try {
      String url = serverUrl + 'api/auth/addaddress';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "address_line1": addressLine1,
            "address_line2": addressLine2,
            "city": city,
            "country": country,
            "isSelected": false,
            // "mobile_no": mobileno,
            "pincode": pincode,
            "state": state,
            // "telephone_no": telephoneno,
            "status": status,
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
