import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/api/SignInAuto.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  SignInApi signInApi = new SignInApi();
  var argument = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey1,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 140,
                  ),
                  Text(
                    'Add Mobile Number',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IntlPhoneField(
                    flagsButtonPadding: EdgeInsets.only(left: 15),
                    showDropdownIcon: false,
                    obscureText: false,
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    decoration: InputDecoration(
                        counterText: '',
                        labelText: 'Enter Mobile Number',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.blue))),
                    countries: <String>['IN'],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: mobileNumberController,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    validator: (value) {
                      if (value != null)
                        return 'Mobile Number must be of 10 digit';
                      else
                        return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    label: Text('Add Mobile Number'), // <-- Text
                    backgroundColor: black,
                    onPressed: () {
                      login();
                    },
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  login() {
    if (_formKey1.currentState!.validate()) {
      print("Form is valid ");
      _formKey1.currentState!.save();
      UpdateMobileNumber(
          argument['uId'], mobileNumberController.text.toString());
    } else {
      print('form is not valid');
    }
  }

  Future UpdateMobileNumber(int id, String mobileNo) async {
    try {
      String url =
          serverUrl + 'api/auth/updateMobileNumber/${id}?mobileNo=${mobileNo}';
      http.Response response = await http
          .put(Uri.parse(url), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print("response body is :" + response.body);
        Get.off(() => HomeScreen());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('SignUp SuccessFully'),
          backgroundColor: Colors.green,
        ));
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
