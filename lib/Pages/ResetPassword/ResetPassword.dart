import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/utils/ColorUtils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../ConstantUtil/colors.dart';
import 'Otpverification.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isValid = false;
  final _formKey10 = GlobalKey<FormState>();
  bool isVisible = false;
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey10,
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
                    'Reset Your Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Email',
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
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (value!.isEmpty) {
                        return 'Email Required';
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid Email';
                        } else {
                          return null;
                        }
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(50)
                    ],
                    onSaved: (value) {},
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    label: Text('Reset Password'), // <-- Text
                    backgroundColor: black,
                    onPressed: () {
                      ForgetPassword();
                      // Get.to(() => OtpVerification());
                    },
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  ForgetPassword() {
    if (_formKey10.currentState!.validate()) {
      sendEmailToApi();
      _formKey10.currentState!.save();
    }
  }

  Future sendEmailToApi() async {
    try {
      String url =
          serverUrl + 'api/auth/forgotpassword/${_emailTextController.text}';
      http.Response response = await http
          .post(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      var body = jsonDecode(response.body);
      print(body);

      if (body['status'] == 200) {
        emailId = _emailTextController.text.toString();
        Get.to(() => OtpVerification(),
            arguments: {'otp': body['result']['otp']});
      } else if (body['status'] == 400) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please Enter Valid Email !'),
          backgroundColor: Colors.redAccent,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please Enter Valid Email !'),
          backgroundColor: Colors.redAccent,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
