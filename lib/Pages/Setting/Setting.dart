import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Pages/Address/AddAddress.dart';
import 'package:flutter_login_app/Pages/Address/AddressDetails.dart';
import 'package:flutter_login_app/Pages/Home/home.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantUtil/globals.dart';
import '../../Controller/LoginController.dart';
import '../../screens/welcome.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey1 = GlobalKey<FormState>();
  bool isValid = false;
  var versionInfo;

  getVersions() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionInfo = '${packageInfo.version} + ${packageInfo.buildNumber}';
    });
  }

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    String? data = store.getString('userData');
    String? email = store.getString('email');
    Map<String, dynamic> userdata = jsonDecode(data!);
    setState(() {
      this.user = userdata;
      this.email = email;
    });
  }

  Map<String, dynamic>? user;
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersions();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Setting",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Get.to(() => HomePage());
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Text(
          'Version : ${versionInfo}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            // Text(
            //   "Settings",
            //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            // ),
            // SizedBox(
            //   height: 40,
            // ),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.person,
            //       color: Colors.black,
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     Text(
            //       "Account",
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            // Divider(
            //   height: 15,
            //   thickness: 2,
            // ),
            SizedBox(
              height: 10,
            ),
            showpassword(context, "Change password"),
            // buildAccountOptionRow(context, "Change password"),
            // AddressRow(context, "Address"),
            // OrdersRow(context, "Orders"),
            SizedBox(
              height: 40,
            ),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.volume_up_outlined,
            //       color: Colors.black,
            //     ),
            //     SizedBox(
            //       width: 8,
            //     ),
            //     Text(
            //       "Notifications",
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            // Divider(
            //   height: 15,
            //   thickness: 2,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // buildNotificationOptionRow("New for you", true),
            // buildNotificationOptionRow("Account activity", true),
            // buildNotificationOptionRow("Opportunity", false),
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector AddressRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddressDetails());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector OrdersRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Get.to(() => OrderScreen());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController oldpasswordcontroller = new TextEditingController();
  TextEditingController newpasswordcontroller = new TextEditingController();
  TextEditingController confirmpasswordcontroller = new TextEditingController();

  GestureDetector showpassword(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey1,
                  child: AlertDialog(
                    title: Text(title),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: oldpasswordcontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black87,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Enter Old Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: black,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                ),
                              ],
                            ),

                            // hintText: "Enter Old Password",
                            // hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: newpasswordcontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black87,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Enter New Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: black,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                ),
                              ],
                            ),
                            // hintText: "Enter New Password",
                            // hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: confirmpasswordcontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          cursorColor: Colors.black87,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            // floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Confirm New Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: black,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                ),
                              ],
                            ),
                            // hintText: "Confirm New Password",
                            // hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (newpasswordcontroller.text !=
                                confirmpasswordcontroller.text) {
                              return 'Do not Match Password';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  changepassword();
                                },
                              ),
                              SizedBox(
                                width: 55,
                              ),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  changepassword() {
    if (_formKey1.currentState!.validate()) {
      print("Form is valid ");
      _formKey1.currentState!.save();
      ResetPasswordApi(oldpasswordcontroller.text.toString(),
          newpasswordcontroller.text.toString());
    } else {
      print('Form is Not Valid');
    }
  }

  Future ResetPasswordApi(String oldpassword, newpassword) async {
    try {
      print(oldpassword + " " + newpassword);

      String url = serverUrl + 'api/auth/resetpassword';
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "email": user!['email'],
            'oldpassword': oldpassword,
            'newpassword': newpassword,
          }));

      if (response.statusCode == 200) {
        print("password Reset Successfully");
        print("response body is :" + response.body);
        // Get.off(() => SignInScreen());
        Navigator.of(context).pop();
        CommanDialog.showErrorDialog(
            description: "Reset Password SuccessFully....!", title: "Success");
      } else if (response.statusCode == 400) {
        CommanDialog.showErrorDialog(description: "Old Password Not Match");
        print("Old password Not Match");
      } else if (response.statusCode == 500) {
        print("something went wrong!");
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
