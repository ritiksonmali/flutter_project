import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/reusable_widgets/reusable_widget.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/utils/color_utils.dart';
import 'package:get/get.dart';

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

  AuthController controller = Get.put(AuthController());

  signUp() {
    if (_formKey.currentState!.validate()) {
      print("Form is valid ");
      _formKey.currentState!.save();
      print('User Sign Up Data $userSignupData');
      controller.signUp(userSignupData['email'], userSignupData['password'],
          userSignupData['username']);
    }
  }

  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  // TextEditingController _emailTextController = TextEditingController();
  // TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.lightBlue,
      //   centerTitle: true,
      //   elevation: 0,
      //   title: const Text(
      //     "Sign Up",
      //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //   hexStringToColor("CB2B93"),
          //   hexStringToColor("9546C4"),
          //   hexStringToColor("5E61F4")
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter First Name',
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
                        return 'First Name Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userSignupData['firstname'] = value!;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Last Name',
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
                        return 'Last Name Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userSignupData['lastname'] = value!;
                    },
                    keyboardType: TextInputType.text,
                  ),

                  // reusableTextField("Enter UserName", Icons.person_outline,
                  //     false, _userNameTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
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
                      userSignupData['email'] = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),

                  // reusableTextField("Enter Email Id", Icons.person_outline,
                  //     false, _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _password,
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
                      userSignupData['password'] = value!;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmpassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.black87,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black87,
                        ),
                        labelText: 'Enter Confirm Password',
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
                      if (_password.text != _confirmpassword.text) {
                        return 'Do not Match Password';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      userSignupData['confirm_password'] = value!;
                    },
                    obscureText: true,
                  ),
                  // reusableTextField("Enter Password", Icons.lock_outlined, true,
                  //     _passwordTextController),
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
                      child: Text(
                        'Sign Up',
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Colors.green;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                    ),
                  ),
                  // firebaseUIButton(context, "Sign Up", () {
                  //   FirebaseAuth.instance
                  //       .createUserWithEmailAndPassword(
                  //           email: _emailTextController.text,
                  //           password: _passwordTextController.text)
                  //       .then((value) {
                  //     print("Created New Account");
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => HomeScreen()));
                  //   }).onError((error, stackTrace) {
                  //     print("Error ${error.toString()}");
                  //   });
                  // })
                ],
              ),
            ),
          ))),
    );
  }
}
