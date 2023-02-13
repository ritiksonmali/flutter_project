import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/CategoryController.dart';
import 'package:flutter_login_app/Controller/LocalImagesController.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Controller/OfferController.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/PushNotificationController.dart';
import 'package:flutter_login_app/Notification/LocalNotificationService.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../Controller/ProductController.dart';
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
  final PopularProductController popularproductController =
      Get.put(PopularProductController());
  final OfferController offerController = Get.put(OfferController());
  final CategoryController categoryController = Get.put(CategoryController());
  final ProductController productController = Get.put(ProductController());
  final PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());
  final logincontroller = LoginController();

  @override
  void initState() {
    super.initState();
    // localImagesController.getAllProductImages();

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
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data ${message.data['_id']}");
        }
      },
    );
  }

  // Future<void> getDeviceTokenToSendNotification() async {
  //   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  //   final token = await _fcm.getToken();
  //   deviceTokenToSendPushNotification = token.toString();
  //   print("Token Value $deviceTokenToSendPushNotification");
  //   setState(() {
  //     DeviceToken = deviceTokenToSendPushNotification;
  //   });
  //   // await Future.delayed(Duration(seconds: 3));
  //   // pushNotificationController.sendNotificationData(
  //   //     deviceTokenToSendPushNotification, deviceType);
  // }

  @override
  Widget build(BuildContext context) {
    // getDeviceTokenToSendNotification();
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
                print('called');
                pushNotificationController.sendNotificationData(
                    deviceTokenToSendPushNotification, deviceType);
                // localImagesController.getAllProductCompressedImages();
                // localImagesController.getAllProductImages();
                productController.getAllProducts();
                List<FileSystemEntity> dirContents = directory.listSync();

                if (dirContents.length == 0
                    // &&iscompressedImagesAdded == true &&
                    //     isImagesAdded == true
                    ) {
                  print('Directory is empty');
                  Timer(Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  print('Directory is not empty');
                  Timer(Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                    );
                  });
                }
              } else {
                // localImagesController.getAllProductCompressedImages();
                // localImagesController.getAllProductImages();
                Timer(Duration(seconds: 1), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Welcome()), // this mymainpage is your page to refresh
                    (Route<dynamic> route) => false,
                  );
                });
              }

              return LoadingScreen();
            }
          }),
    );
  }
}
