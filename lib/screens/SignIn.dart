import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/model/User.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/screens/ResetPassword.dart';
import 'package:flutter_login_app/screens/SignUp.dart';
import 'package:flutter_login_app/utils/ColorUtils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userLoginData = {"email": "", "password": ""};

  bool isValid = false;

  Users userdata = Users();

  login() {
    if (_formKey.currentState!.validate()) {
      print("Form is valid ");

      _formKey.currentState!.save();
      // print('Data for login $userLoginData');
      // controller.logiN(userLoginData['email'], userLoginData['password']);
      EmailValidation();
      if (isValid == true) {
        RestApiTest(_emailTextController.text.toString(),
            _passwordTextController.text.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please Enter Valid Email'),
          backgroundColor: Colors.redAccent,
        ));
      }
    } else {
      print('Form is Not Valid');
    }
  }

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
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
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Email',
                        labelStyle: TextStyle(color: Colors.black54),
                        // filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: Colors.white.withOpacity(0.3),
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
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(color: Colors.black54),
                        // filled: true,
                        // floatingLabelBehavior: FloatingLabelBehavior.never,
                        // fillColor: Colors.white.withOpacity(0.3),
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
                      child: Text(
                        'Sign In',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black;
                            }
                            return black;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }

  void EmailValidation() {
    setState(() {
      isValid = EmailValidator.validate(_emailTextController.text.trim());
    });
  }

  Future RestApiTest(String email, password) async {
    try {
      print(email + " " + password);

      String url = 'http://10.0.2.2:8082/api/auth/signin';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}));

      var userDetails = jsonDecode(response.body);
      // Map user = userDetails['result'];

      var store = await SharedPreferences.getInstance(); //add when requried

      if (response.statusCode == 200) {
        print("Success");
        store.setString('userData', json.encode(userDetails['result']));
        store.setString('id', json.encode(userDetails['result']['id']));
        store.setString(
            'firstname', json.encode(userDetails['result']['firstName']));
        store.setString(
            'lastname', json.encode(userDetails['result']['lastName']));
        store.setString('email', json.encode(userDetails['result']['email']));
        // var datas = store.getString("userData");
        // var datass = jsonDecode(datas!);
        // print(datass['email']);
        // String? data = store.getString('userData');      //get instance data
        // Map<String, dynamic> userdata = jsonDecode(data!);

        // print(userdata["email"]);
        // userdata.getUsers(
        //     user['id'], user['email'], user['firstName'], user['lastName']);
        print(userDetails['result']['email']);
        Get.off(() => HomeScreen());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login SuccessFully !'),
          backgroundColor: Colors.green,
        ));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please Enter Valid Email and Password'),
          backgroundColor: Colors.redAccent,
        ));
        print("Please Enter Valid Email and Password");
      } else if (response.statusCode == 400) {
        print("Bad Request");
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
