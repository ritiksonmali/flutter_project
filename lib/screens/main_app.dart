import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LocalImagesController.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Controller/PushNotificationController.dart';
import 'package:flutter_login_app/Notification/LocalNotificationService.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';

import 'loading.dart';

class Mainapp extends StatefulWidget {
  const Mainapp({Key? key}) : super(key: key);

  @override
  State<Mainapp> createState() => _MainappState();
}

class _MainappState extends State<Mainapp> {
  String deviceTokenToSendPushNotification = '';

  String deviceType = "Android";
  LocalImagesController localImagesController =
      Get.put(LocalImagesController());
  // final PopularProductController popularproductController =
  //     Get.put(PopularProductController());
  // final OfferController offerController = Get.put(OfferController());
  // final CategoryController categoryController = Get.put(CategoryController());
  // final ProductController productController = Get.put(ProductController());
  final PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());
  final logincontroller = LoginController();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: logincontroller.tryAutoLogin(),
          builder: (context, authResult) {
            if (authResult.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
              );
            } else {
              if (authResult.data == true) {
                print('called');
                pushNotificationController.sendNotificationData(
                    deviceTokenToSendPushNotification, deviceType);
                List<FileSystemEntity> dirContents = directory.listSync();
                if (dirContents.length == 0) {
                  print('Directory is empty');
                  Timer(const Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  print('Directory is not empty');
                  Timer(const Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  });
                }
              } else {
                Timer(const Duration(seconds: 1), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Welcome()),
                    (Route<dynamic> route) => false,
                  );
                });
              }

              return const LoadingScreen();
            }
          }),
    );
  }
}
