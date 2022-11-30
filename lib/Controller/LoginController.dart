import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/PushNotificationController.dart';
import 'package:flutter_login_app/api/SignInAuto.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

PushNotificationController pushNotificationController = Get.find();

class LoginController {
  Future<bool> tryAutoLogin() async {
    var store = await SharedPreferences.getInstance();
    String? roleFrompreference = store.getString('role');
    role = jsonDecode(roleFrompreference!);
    print("Role is " + role);
    if (!store.containsKey("userData")) {
      return false;
    } else {
      return true;
    }
  }

  static logOut() async {
    final store = await SharedPreferences.getInstance();
    // pushNotificationController.setNotifiedUserStatus();
    print(store);
    store.clear();
    if (FirebaseAuth.instance != null) {
      await FirebaseAuth.instance.signOut();
      await FacebookAuth.i.logOut();
      await SignInApi.googleSignIn.signOut();
    } else {
      print('firebase login failed');
    }
    // Get.off(() => Welcome());
  }
}
