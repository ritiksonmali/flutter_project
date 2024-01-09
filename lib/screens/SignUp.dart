import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/screens/SignIn.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import '../ConstantUtil/globals.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userSignupData = {
    "firstname": "",
    "lastname": "",
    "email": "",
    "password": "",
    "confirm_password": "",
  };

  bool sos = false;
  bool isValid = false;

  // AuthController controller = Get.put(AuthController());

  signUp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      RestApiTest(
          _firstnamecontroller.text.toString(),
          _lastnamecontroller.text.toString(),
          _emailcontroller.text.toString(),
          _passwordcontroller.text.toString(),
          _mobileNocontroller.text.toString(),
          sos);
    } else {
      print('form is not valid');
    }
  }

  final TextEditingController _firstnamecontroller = TextEditingController();
  final TextEditingController _lastnamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _mobileNocontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _firstnamecontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter First Name',
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
                      if (value == null || value.isEmpty) {
                        return 'First Name Required';
                      }
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      LengthLimitingTextInputFormatter(15)
                    ],
                    onSaved: (value) {
                      // userSignupData['firstname'] = value!;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _lastnamecontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Last Name',
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
                      if (value == null || value.isEmpty) {
                        return 'Last Name Required';
                      }
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      LengthLimitingTextInputFormatter(15)
                    ],
                    onSaved: (value) {
                      // userSignupData['lastname'] = value!;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailcontroller,
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
                        // filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: white.withOpacity(0.3),
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
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(50)
                    ],
                    onSaved: (value) {
                      // userSignupData['email'] = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
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
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.blue))),
                    // countries: const <String>['IN'],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _mobileNocontroller,
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
                  TextFormField(
                    controller: _passwordcontroller,
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
                        // fillColor: white.withOpacity(0.3),
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
                      RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Password Required';
                      } else {
                        if (!regex.hasMatch(value)) {
                          return 'Enter valid password';
                        } else {
                          return null;
                        }
                      }
                    },
                    onSaved: (value) {
                      // userSignupData['password'] = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmpasswordcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Confirm Password',
                        labelStyle: const TextStyle(color: Colors.black54),
                        // filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: white.withOpacity(0.3),
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
                      if (_passwordcontroller.text !=
                          _confirmpasswordcontroller.text) {
                        return 'Do not Match Password';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      // userSignupData['confirm_password'] = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(90)),
                    child: ElevatedButton(
                      onPressed: () {
                        signUp();
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
                        'Sign Up',
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
    );
  }

  Future RestApiTest(
      String firstname, lastname, email, password, mobileNo, bool sos) async {
    try {
      String url = '${serverUrl}api/auth/signup';
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'firstName': firstname,
            'lastName': lastname,
            'email': email,
            'mobileNo': mobileNo,
            'password': password,
            'sos': sos,
          }));

      if (response.statusCode == 200) {
        print("sign up Success");
        Get.off(() => const SignInScreen());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('SignUp SuccessFully'),
          backgroundColor: Colors.green,
        ));
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email is already in use !'),
          backgroundColor: Colors.redAccent,
        ));
        print("Email is already in use !");
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something Went Wrong !'),
          backgroundColor: Colors.redAccent,
        ));
        print("Email is already in use!");
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
