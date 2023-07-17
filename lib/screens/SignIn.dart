import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/PushNotificationController.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/Pages/ResetPassword/ResetPassword.dart';
import 'package:flutter_login_app/screens/SignUp.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userLoginData = {"email": "", "password": ""};

  bool isValid = false;
  String deviceType = 'Android';

  // Users userdata = Users();

  login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      RestApiTest(_emailTextController.text.toString(),
          _passwordTextController.text.toString());
    } else {
      print('Form is Not Valid');
    }
  }

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // logoWidget("assets/profile.png"),
                  const SizedBox(
                    height: 150,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Email',
                        labelStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.blue))),
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (value!.isEmpty) {
                        return 'Email Required';
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid Email Id';
                        } else {
                          return null;
                        }
                      }
                    },
                    onSaved: (value) {
                      // userLoginData['email'] = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // reusableTextField("Enter UserName", Icons.person_outline,
                  //     false, _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordTextController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Password',
                        labelStyle: const TextStyle(color: Colors.black54),
                        // filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.blue))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // userLoginData['password'] = value!;
                    },
                    obscureText: true,
                  ),
                  // reusableTextField("Enter Password", Icons.lock_outline, true,
                  //     _passwordTextController),
                  const SizedBox(
                    height: 5,
                  ),
                  forgetPassword(context),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(90)),
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return buttonColour;
                            }
                            return buttonColour;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),

                  signUpOption()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(color: black)),
        GestureDetector(
          onTap: () {
            Get.to(() => const SignUpScreen());
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }

  Future RestApiTest(String email, password) async {
    try {
      CommanDialog.showLoading();
      var userDetails;
      String? roleFrompreference = "";
      var store = await SharedPreferences.getInstance();
      print(email + " " + password);
      String url = '${serverUrl}api/auth/signin';
      var client = http.Client();
      client
          .post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'email': email, 'password': password}))
          .timeout(const Duration(seconds: 10), onTimeout: () {
        CommanDialog.hideLoading();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Server is not Responding'),
          backgroundColor: kAlertColor,
        ));
        throw TimeoutException("Server is not responding");
      }).then((response) => {
                userDetails = jsonDecode(response.body),
                // Map user = userDetails['result'];
                // List<String> roles = userDetails['roles'];

                // print(userDetails['result']['role']);//add when requried

                if (response.statusCode == 200)
                  {
                    CommanDialog.hideLoading(),
                    print("Success"),
                    store.setString(
                        'userData', json.encode(userDetails['result'])),
                    store.setString(
                        'id', json.encode(userDetails['result']['id'])),
                    store.setString('firstname',
                        json.encode(userDetails['result']['firstName'])),
                    store.setString('lastname',
                        json.encode(userDetails['result']['lastName'])),
                    store.setString(
                        'email', json.encode(userDetails['result']['email'])),
                    print(userDetails['result']['email']),
                    store.setString(
                        'role', json.encode(userDetails['result']['role'])),
                    roleFrompreference = store.getString('role'),
                    role = jsonDecode(roleFrompreference!),
                    pushNotificationController.sendNotificationData(
                        deviceToken, deviceType),
                    // Timer(const Duration(seconds: 2), () {
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                    ),
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Login SuccessFully !'),
                      backgroundColor: buttonColour,
                    )),
                    // });
                  }
                else if (response.statusCode == 401)
                  {
                    CommanDialog.hideLoading(),
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please Enter Valid Email and Password'),
                      backgroundColor: kAlertColor,
                    )),
                    print("Please Enter Valid Email and Password")
                  }
                else if (response.statusCode == 400)
                  {CommanDialog.hideLoading(), print("Bad Request")}
                else
                  {CommanDialog.hideLoading(), print("failed")}
              });
      // var response = await http.post(Uri.parse(url),
      //     headers: {'Content-Type': 'application/json'},
      //     body: json.encode({'email': email, 'password': password}));
    } catch (e) {
      CommanDialog.hideLoading();
      print(e);
    }
  }
}
