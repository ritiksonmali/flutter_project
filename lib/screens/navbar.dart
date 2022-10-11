import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/api/signin.dart';
import 'package:flutter_login_app/reusable_widgets/Data_controller.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/screens/signin_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  getdata() async {
    var store = await SharedPreferences.getInstance();
    // String? data = store.getString('userData');
    // Map<String, dynamic> userdata = jsonDecode(data!);
    // return userdata;
  }

  // Url for Logout current user
  String url = 'http://10.0.2.2:8082/api/auth/signout';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('User : xyz'),
            accountEmail: Text('Email Id : example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/profile.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Profile'),
            onTap: (() => null),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            // onTap: () => FirebaseAuth.instance.signOut().then((value) {
            //       print("Signed Out");
            //       // Navigator.push(
            //       //     context,
            //       //     MaterialPageRoute(
            //       //         builder: (context) => SignInScreen()));
            //       Get.off(() => Welcome());
            //     })
            onTap: () {
              // final provider = Provider.of<SignInApi>(context, listen: false);
              // provider.logout(url);
              print(getdata());
              LoginController.logOut();
              Get.off(() => Welcome());
            },
          ),
        ],
      ),
    );
  }
}
