import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/utils/ColorUtils.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import 'Otpverification.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isValid = false;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  TextEditingController _emailTextController = TextEditingController();

  Map<String, String> userLoginData = {"email": ""};

  AuthController controller = Get.put(AuthController());

  ForgetPassword() {
    if (_formKey.currentState!.validate()) {
      print("forget Password");
      _formKey.currentState!.save();
      print('Data for login $userLoginData');
      controller.ForgetPassword(userLoginData['email']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
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
                      if (value == null || value.isEmpty) {
                        return 'Email Required';
                      }
                      return null;
                    },
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
                      Get.to(() => OtpVerification());
                    },
                  ),
                ],
              ),
            ))),
      ),
    );
  }
}
