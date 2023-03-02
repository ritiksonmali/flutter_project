import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/screens/SetNewPassword.dart';
import 'package:flutter_login_app/utils/ColorUtils.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formKey10 = GlobalKey<FormState>();
  bool isVisible = false;
  TextEditingController _otpTextController = TextEditingController();
  var argument = Get.arguments;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Form(
        key: _formKey10,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: grey,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 140,
                  ),
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                        color: black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _otpTextController,
                    cursorColor: Colors.black87,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline_sharp,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter otp',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.blue))),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    validator: (value) {
                      if (value != null)
                        return 'Otp Required';
                      else
                        return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    label: Text('Verifly Otp'), // <-- Text
                    backgroundColor: buttonColour,
                    onPressed: () {
                      checkOtp();
                    },
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  checkOtp() {
    if (_formKey10.currentState!.validate()) {
      print(argument['otp']);
      print('gdjhgrdhg' + _otpTextController.text);
      if (argument['otp'].toString() == _otpTextController.text.toString()) {
        print('success');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Otp Validated Successfully'),
          backgroundColor: Colors.green,
        ));
        Get.to(() => SetNewPassword());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please Enter Valid Otp'),
          backgroundColor: Colors.redAccent,
        ));
      }
      _formKey10.currentState!.save();
    }
  }
}
