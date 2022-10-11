import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/EditProfilePage.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Pages/Setting.dart';

class NavBar extends StatelessWidget {
  // Url for Logout current user
  String url = 'http://10.0.2.2:8082/api/auth/signout';
Future test() async{ 
   var store = await SharedPreferences.getInstance();//add when requried
   String? data = store.getString('userData');      //get instance data 
        Map<String, dynamic> userdata = jsonDecode(data!);
        String data11=(userdata["email"]).toString();
   return await data11; 
}

  // DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      
      child: ListView(  
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
               decoration: BoxDecoration(color: Color.fromARGB(255, 217, 217, 217)),
            accountName: Text('user',
             style: TextStyle(color: Colors.black)),
            accountEmail: Text('email',style: TextStyle(color: Colors.black)
            ),
            
            currentAccountPicture: CircleAvatar(
              child: ClipOval(  
                child: Container(
                        color: Colors.white,
                             
                child: Image.asset(
                  "assets/profile.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.scaleDown,
                   ),
                ),
              ),
            ),
             // color: Colors.white,
          ),
           ListTile(
            
            leading: Icon(Icons.face),
            title: Text('Home'),
            onTap: () {
              // final provider = Provider.of<SignInApi>(context, listen: false);
              // provider.logout(url);
              Get.to(() => HomeScreen());
            },
          ),
          ListTile(
            
            leading: Icon(Icons.face),
            title: Text('Edit Profile'),
            onTap: () {
              // final provider = Provider.of<SignInApi>(context, listen: false);
              // provider.logout(url);
              Get.to(() => EditProfilePage());
            },
          ),
          ListTile(
            
            leading: Icon(Icons.face),
            title: Text('Setting'),
            onTap: () {
              // final provider = Provider.of<SignInApi>(context, listen: false);
              // provider.logout(url);
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
