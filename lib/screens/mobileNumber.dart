import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SignInApi signInApi = SignInApi();
  var argument = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Form(
        key: _formKey1,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: grey,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 140,
                  ),
                  const Text(
                    'Add Mobile Number',
                    style: TextStyle(
                        color: black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IntlPhoneField(
                    flagsButtonPadding: const EdgeInsets.only(left: 15),
                    showDropdownIcon: false,
                    obscureText: false,
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    decoration: InputDecoration(
                        counterText: '',
                        labelText: 'Enter Mobile Number',
                        labelStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.blue))),
                    // countries: const <String>['IN'],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: mobileNumberController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    validator: (value) {
                      if (value != null) {
                        return 'Mobile Number must be of 10 digit';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    label: const Text('Add Mobile Number'), // <-- Text
                    backgroundColor: buttonColour,
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
          '${serverUrl}api/auth/updateMobileNumber/$id?mobileNo=$mobileNo';
      http.Response response = await http
          .put(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        Get.off(() => const HomeScreen());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: const Text('SignUp SuccessFully'),
          backgroundColor: Colors.green,
        ));
      } else {
        print("failed");
      }
    } catch (e) {
      e.printError();
    }
  }
}
