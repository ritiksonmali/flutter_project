import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AddressController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateAddress extends StatefulWidget {
  const UpdateAddress({Key? key}) : super(key: key);

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  final _formKey4 = GlobalKey<FormState>();
  var address = Get.arguments;
  final String status = "ACTIVE";
  AddressController addressController = Get.find();
  TextEditingController addressLine1controller = new TextEditingController();
  TextEditingController addressLine2controller = new TextEditingController();
  TextEditingController citycontroller = new TextEditingController();
  TextEditingController statecontroller = new TextEditingController();
  TextEditingController countrycontroller = new TextEditingController();
  TextEditingController mobilenocontroller = new TextEditingController();
  TextEditingController telephonenocontroller = new TextEditingController();
  TextEditingController pincodecontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(address['isselected']);
    print(address['addressId']);
    print(address['userId']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Your Address",
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
              if (addressLine1controller.text.isNotEmpty ||
                  addressLine2controller.text.isNotEmpty ||
                  citycontroller.text.isNotEmpty ||
                  countrycontroller.text.isNotEmpty ||
                  mobilenocontroller.text.isNotEmpty ||
                  telephonenocontroller.text.isNotEmpty ||
                  statecontroller.text.isNotEmpty ||
                  pincodecontroller.text.isNotEmpty) {
                updateAddress(
                    address['addressId'],
                    addressLine1controller.text.isEmpty
                        ? address['addressline1']
                        : addressLine1controller.text.toString(),
                    addressLine2controller.text.isEmpty
                        ? address['addressline2']
                        : addressLine2controller.text.toString(),
                    citycontroller.text.isEmpty
                        ? address['city']
                        : citycontroller.text.toString(),
                    countrycontroller.text.isEmpty
                        ? address['country']
                        : countrycontroller.text.toString(),
                    mobilenocontroller.text.isEmpty
                        ? address['mobileno']
                        : mobilenocontroller.text.toString(),
                    telephonenocontroller.text.isEmpty
                        ? address['telephoneno']
                        : telephonenocontroller.text.toString(),
                    statecontroller.text.isEmpty
                        ? address['state']
                        : statecontroller.text.toString(),
                    pincodecontroller.text.isEmpty
                        ? int.parse(address['pincode'])
                        : int.parse(pincodecontroller.text.toString()));
              }
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Address line 1",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['addressline1'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Address line 2",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['addressline2'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Pincode",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['pincode'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: citycontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "City",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['city'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: statecontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "State",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['state'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: countrycontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Country",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['country'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
                obscureText: false,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: telephonenocontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Telephone number",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['telephoneno'],
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
                height: 20,
              ),
              TextFormField(
                controller: mobilenocontroller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: black,
                style: TextStyle(color: black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: "Mobile number",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    hintText: address['mobileno'],
                    hintStyle: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: black,
                    )),
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

  Future updateAddress(int addressId, String addressLine1, addressLine2, city,
      country, mobileno, telephoneno, state, int pincode) async {
    try {
      String url = 'http://10.0.2.2:8082/api/auth/updateAddress/${addressId}';
      var response = await http.put(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "address_line1": addressLine1,
            "address_line2": addressLine2,
            "city": city,
            "country": country,
            "isSelected": address['isselected'],
            "mobile_no": mobileno,
            "pincode": pincode,
            "state": state,
            "telephone_no": telephoneno,
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
