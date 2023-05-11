import 'dart:convert';

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
      SingleValueDropDownController();

  SingleValueDropDownController stateDropDownController =
      SingleValueDropDownController();
  SingleValueDropDownController cityDropDownController =
      SingleValueDropDownController();

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  TextEditingController addressLine1controller = TextEditingController();
  TextEditingController addressLine2controller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController pincodecontroller = TextEditingController();

  var ValueChoose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Address",
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
      bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 48,
          child: MaterialButton(
            onPressed: () {
              addpassword();
              if (defaultValue == "") {
                print("Please select a Address Type");
              } else {
                print("user selected Address Type $defaultValue");
              }
            },
            color: buttonColour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: const Text(
              "Add Address",
              style: TextStyle(
                color: white,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Form(
          key: _formKey3,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(15.0)
                      ),
                  contentPadding: EdgeInsets.all(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      isDense: true,
                      value: defaultValue,
                      isExpanded: true,
                      menuMaxHeight: 350,
                      items: [
                        const DropdownMenuItem(
                            value: "",
                            child: Text(
                              "Select Address Type",
                            )),
                        ...dropDownListData
                            .map<DropdownMenuItem<String>>((data) {
                          return DropdownMenuItem(
                              value: data['value'], child: Text(data['title']));
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
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: black,
              ),
              TextFormField(
                controller: addressLine1controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: const TextStyle(color: black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: addressLine2controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: const TextStyle(color: black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pincodecontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: const TextStyle(color: black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  // floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
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
                  if (value!.length != 6) {
                    return 'Pincode must be of 6 digit';
                  } else {
                    return null;
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                obscureText: false,
              ),
              const SizedBox(
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
                      contentPadding: const EdgeInsets.only(top: 3),
                      labelStyle: const TextStyle(
                          height: 10, fontWeight: FontWeight.bold),
                      label: Row(
                        children: [
                          RichText(
                            text: const TextSpan(
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
              const SizedBox(
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
                            text: const TextSpan(
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
              const SizedBox(
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
                            text: const TextSpan(
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
    } else {}
  }

  Future addNewAddress(String addressLine1, addressLine2, city, country, state,
      int pincode) async {
    try {
      String url = '${serverUrl}api/auth/addaddress';
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
            "user_id": id
          }));

      if (response.statusCode == 200) {
        print("Success");
        // setState(() {
        //   AddressDetails();
        // });
        // Get.back();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('New Address Added SuccessFully !'),
          backgroundColor: Colors.green,
        ));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please Enter Valid Data'),
          backgroundColor: Colors.redAccent,
        ));
        print("Please Enter Valid Data");
      } else if (response.statusCode == 400) {
        print("Bad Request");
      } else {
        printError();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
