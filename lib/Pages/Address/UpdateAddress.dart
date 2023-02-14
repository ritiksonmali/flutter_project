import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AddressController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ConstantUtil/globals.dart';

class UpdateAddress extends StatefulWidget {
  const UpdateAddress({Key? key}) : super(key: key);

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  final _formKey4 = GlobalKey<FormState>();
  var address = Get.arguments;
  final String status = "ACTIVE";
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  SingleValueDropDownController? countryDropDownController;

  SingleValueDropDownController? stateDropDownController;

  SingleValueDropDownController? cityDropDownController;

  AddressController addressController = Get.find();
  TextEditingController addressLine1controller = new TextEditingController();
  TextEditingController addressLine2controller = new TextEditingController();
  TextEditingController citycontroller = new TextEditingController();
  TextEditingController statecontroller = new TextEditingController();
  TextEditingController countrycontroller = new TextEditingController();
  // TextEditingController mobilenocontroller = new TextEditingController();
  // TextEditingController telephonenocontroller = new TextEditingController();
  TextEditingController pincodecontroller = new TextEditingController();

  List country = [];
  List state = [];
  List city = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountry();
    DropDownValueModel initialCountry = DropDownValueModel(
        name: address['country'], value: address['countryId']);
    DropDownValueModel initialState =
        DropDownValueModel(name: address['state'], value: address['stateId']);
    DropDownValueModel initialCity =
        DropDownValueModel(name: address['city'], value: address['cityId']);
    countryDropDownController =
        new SingleValueDropDownController(data: initialCountry);
    stateDropDownController =
        new SingleValueDropDownController(data: initialState);
    cityDropDownController =
        new SingleValueDropDownController(data: initialCity);
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

  @override
  Widget build(BuildContext context) {
    print(address['stateId']);
    print(address['countryId']);
    print(address['cityId']);

    addressLine1controller.text = address['addressline1'];
    addressLine2controller.text = address['addressline2'];
    citycontroller.text = address['city'];
    statecontroller.text = address['state'];
    countrycontroller.text = address['country'];
    // mobilenocontroller.text = address['mobileno'];
    // telephonenocontroller.text = address['telephoneno'];
    pincodecontroller.text = address['pincode'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Address",
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
              checkvalidations();
            },
            child: Text(
              "Update Address",
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
          key: _formKey4,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              // buildTextField("AddressLine1", address['addressline1'],
              //     addressLine1controller),
              // buildTextField("AddressLine2", address['addressline2'],
              //     addressLine2controller),
              // buildTextField("Pincode", address['pincode'], pincodecontroller),
              // buildTextField("City", address['city'], citycontroller),
              // buildTextField("State", address['state'], statecontroller),
              // buildTextField("Country", address['country'], countrycontroller),
              // buildTextField("Telephone Number", address['telephoneno'],
              //     telephonenocontroller),
              // buildTextField(
              //     "Mobile Number", address['mobileno'], mobilenocontroller),
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
                  // hintText: "Pincode",
                  // hintStyle: TextStyle(
                  //   fontSize: 16,
                  //   // fontWeight: FontWeight.bold,
                  //   color: black,
                  // )
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
                  dropDownItemCount: 4,
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
                      stateDropDownController!.dropDownValue = null;
                      cityDropDownController!.dropDownValue = null;
                    });
                    print(countryDropDownController!.dropDownValue!.value);
                    getState(countryDropDownController!.dropDownValue!.value,
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
                  dropDownItemCount: 4,
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
                      cityDropDownController!.dropDownValue = null;
                    });
                    print(stateDropDownController!.dropDownValue!.value);
                    getCity(
                        stateDropDownController!.dropDownValue!.value, "CITY");
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
                  dropDownItemCount: 4,
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
              // TextFormField(
              //   controller: citycontroller,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   cursorColor: black,
              //   style: TextStyle(color: black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.only(bottom: 3),
              //     // floatingLabelBehavior: FloatingLabelBehavior.always,
              //     label: Row(
              //       children: [
              //         RichText(
              //           text: TextSpan(
              //               text: 'City',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 // fontWeight: FontWeight.bold,
              //                 color: black,
              //               ),
              //               children: [
              //                 TextSpan(
              //                     text: '*',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         color: Colors.red,
              //                         fontWeight: FontWeight.bold))
              //               ]),
              //         ),
              //       ],
              //     ),
              //     // hintText: "City",
              //     // hintStyle: TextStyle(
              //     //   fontSize: 16,
              //     //   // fontWeight: FontWeight.bold,
              //     //   color: black,
              //     // )
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Required';
              //     }
              //     return null;
              //   },
              //   obscureText: false,
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // TextFormField(
              //   controller: statecontroller,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   cursorColor: black,
              //   style: TextStyle(color: black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.only(bottom: 3),
              //     // floatingLabelBehavior: FloatingLabelBehavior.always,.
              //     label: Row(
              //       children: [
              //         RichText(
              //           text: TextSpan(
              //               text: 'State',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 // fontWeight: FontWeight.bold,
              //                 color: black,
              //               ),
              //               children: [
              //                 TextSpan(
              //                     text: '*',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         color: Colors.red,
              //                         fontWeight: FontWeight.bold))
              //               ]),
              //         ),
              //       ],
              //     ),
              //     //   hintText: "State",
              //     //   hintStyle: TextStyle(
              //     //     fontSize: 16,
              //     //     // fontWeight: FontWeight.bold,
              //     //     color: black,
              //     //   )
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Required';
              //     }
              //     return null;
              //   },
              //   obscureText: false,
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // TextFormField(
              //   controller: countrycontroller,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   cursorColor: black,
              //   style: TextStyle(color: black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.only(bottom: 3),
              //     // floatingLabelBehavior: FloatingLabelBehavior.always,
              //     label: Row(
              //       children: [
              //         RichText(
              //           text: TextSpan(
              //               text: 'Country',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 // fontWeight: FontWeight.bold,
              //                 color: black,
              //               ),
              //               children: [
              //                 TextSpan(
              //                     text: '*',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         color: Colors.red,
              //                         fontWeight: FontWeight.bold))
              //               ]),
              //         ),
              //       ],
              //     ),
              //     // hintText: "Country",
              //     // hintStyle: TextStyle(
              //     //   fontSize: 16,
              //     //   // fontWeight: FontWeight.bold,
              //     //   color: black,
              //     // )
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Required';
              //     }
              //     return null;
              //   },
              //   obscureText: false,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // TextFormField(
              //   controller: telephonenocontroller,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   cursorColor: black,
              //   style: TextStyle(color: black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.only(bottom: 3),
              //     // floatingLabelBehavior: FloatingLabelBehavior.always,
              //     label: Row(
              //       children: [
              //         RichText(
              //           text: TextSpan(
              //             text: 'Telephone Number',
              //             style: TextStyle(
              //               fontSize: 16,
              //               // fontWeight: FontWeight.bold,
              //               color: black,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     // hintText: "Telephone number",
              //     // hintStyle: TextStyle(
              //     //   fontSize: 16,
              //     //   // fontWeight: FontWeight.bold,
              //     //   color: black,
              //     // )
              //   ),
              //   inputFormatters: [
              //     FilteringTextInputFormatter.digitsOnly,
              //     LengthLimitingTextInputFormatter(11)
              //   ],
              //   obscureText: false,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // TextFormField(
              //   controller: mobilenocontroller,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   cursorColor: black,
              //   style: TextStyle(color: black),
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.only(bottom: 3),
              //     // floatingLabelBehavior: FloatingLabelBehavior.always,
              //     label: Row(
              //       children: [
              //         RichText(
              //           text: TextSpan(
              //               text: 'Mobile Number',
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 // fontWeight: FontWeight.bold,
              //                 color: black,
              //               ),
              //               children: [
              //                 TextSpan(
              //                     text: '*',
              //                     style: TextStyle(
              //                         fontSize: 20,
              //                         color: Colors.red,
              //                         fontWeight: FontWeight.bold))
              //               ]),
              //         ),
              //       ],
              //     ),
              //     // hintText: "Mobile number",
              //     // hintStyle: TextStyle(
              //     //   fontSize: 16,
              //     //   // fontWeight: FontWeight.bold,
              //     //   color: black,
              //     // )
              //   ),
              //   validator: (value) {
              //     if (value!.length != 10)
              //       return 'Mobile Number must be of 10 digit';
              //     else
              //       return null;
              //   },
              //   inputFormatters: [
              //     FilteringTextInputFormatter.digitsOnly,
              //     LengthLimitingTextInputFormatter(10)
              //   ],
              //   obscureText: false,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, var placeholder, TextEditingController controllers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controllers,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.black87,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        //   LengthLimitingTextInputFormatter(50)
        // ],
      ),
    );
  }

  checkvalidations() {
    if (_formKey4.currentState!.validate()) {
      // print("Form is valid ");
      _formKey4.currentState!.save();
      print(cityDropDownController!.dropDownValue!.value);
      print(stateDropDownController!.dropDownValue!.value);
      print(countryDropDownController!.dropDownValue!.value);
      updateAddress(
          address['addressId'],
          addressLine1controller.text.toString(),
          addressLine2controller.text.toString(),
          cityDropDownController!.dropDownValue!.value.toString(),
          countryDropDownController!.dropDownValue!.value.toString(),
          stateDropDownController!.dropDownValue!.value.toString(),
          int.parse(pincodecontroller.text.toString()));
    } else {
      print('Form is Not Valid');
    }
  }

  Future updateAddress(int addressId, String addressLine1, addressLine2, city,
      country, state, int pincode) async {
    try {
      String url = serverUrl + 'api/auth/updateAddress/${addressId}';
      var response = await http.put(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "address_line1": addressLine1,
            "address_line2": addressLine2,
            "city": city,
            "country": country,
            "isSelected": address['isselected'],
            // "mobile_no": mobileno,
            "pincode": pincode,
            "state": state,
            // "telephone_no": telephoneno,
            "status": status,
          }));

      if (response.statusCode == 200) {
        print("Success");
        addressController.getAddressApi();
        await Future.delayed(Duration(seconds: 2));
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Address Updated SuccessFully'),
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
        printError();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
