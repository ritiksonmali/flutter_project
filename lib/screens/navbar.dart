import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/ProfilePage.dart';
import 'package:flutter_login_app/api/signin.dart';
import 'package:flutter_login_app/reusable_widgets/Data_controller.dart';
import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
import 'package:flutter_login_app/screens/signin_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:flutter_login_app/screens/profile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  // Url for Logout current user
  String url = 'http://10.0.2.2:8082/api/auth/signout';

  // DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      child: ListView(  
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
               decoration: BoxDecoration(color: Color.fromARGB(255, 217, 217, 217)),
            accountName: Text('User : xyz',
             style: TextStyle(color: Colors.black)),
            accountEmail: Text('Email Id : example@gmail.com',style: TextStyle(color: Colors.black)
            ),
            
            currentAccountPicture: CircleAvatar(
              child: ClipOval(  
                child: Container(
                        color: Colors.white,
                             
                child: Image.asset(
                  "assets/profile.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.values[2],
                   ),
                ),
              ),
            ),
             // color: Colors.white,
          ),
          
          ListTile(
            
            leading: Icon(Icons.face),
            title: Text('Profile'),
            onTap: () {
              // final provider = Provider.of<SignInApi>(context, listen: false);
              // provider.logout(url);
              Get.off(() => ProfilePage());
            },
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
              LoginController.logOut();
              Get.off(() => Welcome());
            },
          ),
        ],
      ),
    );
  }
}
