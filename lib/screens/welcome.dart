import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/api/signin.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/screens/signin_screen.dart';
import 'package:flutter_login_app/screens/signup_screen.dart';
import 'package:flutter_login_app/utils/ColorUtils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text(
      //     "Login App",
      //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              // children: [
              //   Text(
              //     'Welcome to Home Page',
              //     style: TextStyle(color: Colors.black, fontSize: 22),
              //   ),
              // ],
              children: <Widget>[
                logoWidget('assets/pngegg.png'),
                SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, right: 40.0, left: 40.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => SignInScreen());
                  },
                ),
                SizedBox(
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
                          color: Colors.grey,
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
                          color: Colors.grey,
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
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?",
                        style: TextStyle(color: Colors.black)),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => SignUpScreen()));
                        Get.to(() => SignUpScreen());
                      },
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
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
