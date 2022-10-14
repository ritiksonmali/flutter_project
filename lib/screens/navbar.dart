import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/Profile/EditProfilePage.dart';
import 'package:flutter_login_app/Pages/Setting.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    String? data = store.getString('userData');
    Map<String, dynamic> userdata = jsonDecode(data!);
    setState(() {
      this.user = userdata;
    });
  }

  Map<String, dynamic>? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 20,
          ),
          // UserAccountsDrawerHeader(
          //   decoration: BoxDecoration(color: Color.fromRGBO(217, 217, 217, 1)),
          //   accountName: Text(
          //       "user : ${user?['firstName']}" + " " + user?['lastName'],
          //       style: TextStyle(color: Colors.black)),
          //   accountEmail: Text("Email : ${user?['email']}",
          //       style: TextStyle(color: Colors.black)),

          //   currentAccountPicture: CircleAvatar(
          //     child: ClipOval(
          //       child: Container(
          //         color: Colors.white,
          //         child: Image.asset(
          //           "assets/profile.png",
          //           width: 90,
          //           height: 90,
          //           fit: BoxFit.scaleDown,
          //         ),
          //       ),
          //     ),
          //   ),
          //   // color: Colors.white,
          // ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Profile'),
            onTap: () {
              Get.to(() => EditProfilePage());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Setting'),
            onTap: () {
              Get.to(() => SettingsPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              LoginController.logOut();
              Get.off(() => Welcome());
            },
          ),
        ],
      ),
    );
  }
}
