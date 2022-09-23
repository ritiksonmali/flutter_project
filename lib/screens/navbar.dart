import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/api/googlesignin.dart';
import 'package:flutter_login_app/reusable_widgets/Data_controller.dart';
import 'package:flutter_login_app/screens/signin_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text('User : ${controller.userProfileData['userName']}'),
            accountEmail:
                Text('Email Id : ${controller.userProfileData['email']}'),
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
              final provider =
                  Provider.of<GoogleSignInApi>(context, listen: false);
              provider.logout();
              Get.off(() => Welcome());
            },
          ),
        ],
      ),
    );
  }
}
