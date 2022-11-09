import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';

import '../Controller/ProductController.dart';
import 'loading.dart';

class Mainapp extends StatefulWidget {
  const Mainapp({Key? key}) : super(key: key);

  @override
  State<Mainapp> createState() => _MainappState();
}

class _MainappState extends State<Mainapp> {
    final ProductController productController = Get.put(ProductController());
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
                 productController.getAllProducts();
                   Timer(Duration(seconds: 10),(){
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()), // this mymainpage is your page to refresh
                   (Route<dynamic> route) => false,
                  );
               });
              }
                Timer(Duration(seconds: 20),(){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>
                       Welcome()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                    );
                 });
                 return LoadingScreen();
              }
          }),

    );
  }
}
