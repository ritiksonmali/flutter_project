import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/api/SignInAuto.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/screens/SignIn.dart';
import 'package:flutter_login_app/screens/SignUp.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: grey,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget('assets/logo111.png'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: buttonColour,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 40.0, left: 40.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => const SignInScreen());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          height: 1,
                          color: grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: 1,
                          color: grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: TextButton(
                              onPressed: () {
                                final provider = Provider.of<SignInApi>(context,
                                    listen: false);
                                provider.SignInwithGoogle();
                              },
                              child: Image.asset('assets/google.png'))),
                      const SizedBox(width: 24),
                      Flexible(
                          child: TextButton(
                              onPressed: () {
                                final provider = Provider.of<SignInApi>(context,
                                    listen: false);
                                provider.signinwithfacebook();
                              },
                              child: Image.asset('assets/facebook.png'))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?",
                        style: TextStyle(color: black)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignUpScreen());
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ))),
    );
  }
}
