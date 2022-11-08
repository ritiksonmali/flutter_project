import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/Pages/Setting/Setting.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/Profile/EditProfilePage.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/colors.dart';
import '../Pages/Order/Orders.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(
                    fontSize: 30, color: black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(
              height: 35,
            ),
            ListTile(
              leading: Icon(Icons.face),
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 30, color: black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Get.to(() => EditProfilePage());
              },
            ),
            SizedBox(
              height: 35,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Orders',
                style: TextStyle(
                    fontSize: 30, color: black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Get.to(() => OrderScreen());
              },
            ),
            SizedBox(
              height: 35,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Setting',
                style: TextStyle(
                    fontSize: 30, color: black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Get.to(() => SettingsPage());
              },
            ),
            SizedBox(
              height: 35,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Sign Out',
                style: TextStyle(
                    fontSize: 30, color: black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                LoginController.logOut();
                Get.off(() => Welcome());
              },
            ),
          ]),
        )
      ],
    );
  }
  // void test() async {
  //   var store = await SharedPreferences.getInstance(); //add when requried
  //   String? data = store.getString('userData');
  //   Map<String, dynamic> userdata = jsonDecode(data!);
  //   setState(() {
  //     this.user = userdata;
  //   });
  // }

  // Map<String, dynamic>? user;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   test();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         SizedBox(
  //           height: 20,
  //         ),
  //         // UserAccountsDrawerHeader(
  //         //   decoration: BoxDecoration(color: Color.fromRGBO(217, 217, 217, 1)),
  //         //   accountName: Text(
  //         //       "user : ${user?['firstName']}" + " " + user?['lastName'],
  //         //       style: TextStyle(color: Colors.black)),
  //         //   accountEmail: Text("Email : ${user?['email']}",
  //         //       style: TextStyle(color: Colors.black)),

  //         //   currentAccountPicture: CircleAvatar(
  //         //     child: ClipOval(
  //         //       child: Container(
  //         //         color: Colors.white,
  //         //         child: Image.asset(
  //         //           "assets/profile.png",
  //         //           width: 90,
  //         //           height: 90,
  //         //           fit: BoxFit.scaleDown,
  //         //         ),
  //         //       ),
  //         //     ),
  //         //   ),
  //         //   // color: Colors.white,
  //         // ),
  //         ListTile(
  //           leading: Icon(Icons.home),
  //           title: Text('Home'),
  //           onTap: () {
  //             Get.back();
  //           },
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.face),
  //           title: Text('Profile'),
  //           onTap: () {
  //             Get.to(() => EditProfilePage());
  //           },
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.settings),
  //           title: Text('Setting'),
  //           onTap: () {
  //             Get.to(() => SettingsPage());
  //           },
  //         ),
  //         ListTile(
  //           leading: Icon(Icons.exit_to_app),
  //           title: Text('Sign Out'),
  //           onTap: () {
  //             LoginController.logOut();
  //             Get.off(() => Welcome());
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
