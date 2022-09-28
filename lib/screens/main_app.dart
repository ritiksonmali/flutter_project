import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/welcome.dart';

class Mainapp extends StatefulWidget {
  const Mainapp({Key? key}) : super(key: key);

  @override
  State<Mainapp> createState() => _MainappState();
}

class _MainappState extends State<Mainapp> {
  final logincontroller = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: logincontroller.tryAutoLogin(),
          builder: (context, authResult) {
            if (authResult.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
              );
            } else {
              if (authResult.data == true) {
                return HomeScreen();
              }
              return Welcome();
            }
          }),

      // body: StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return Center(child: CircularProgressIndicator());
      //       } else if (snapshot.hasData) {
      //         return HomeScreen();
      //       } else if (snapshot.hasError) {
      //         return Center(
      //             child: CommanDialog.showErrorDialog(
      //                 description: 'Something Went Wrong'));
      //       } else {
      //         return Welcome();
      //       }
      //       // return Welcome();
      //     }),
    );
  }
}
