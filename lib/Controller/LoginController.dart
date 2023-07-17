import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:flutter_login_app/Controller/PushNotificationController.dart';
import 'package:flutter_login_app/api/SignInAuto.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

PushNotificationController pushNotificationController = Get.find();
final LocalAuthentication _localAuthentication = LocalAuthentication();

class LoginController extends GetxController {
  bool isAuthenticated = false;
  Future<bool> tryAutoLogin() async {
    var store = await SharedPreferences.getInstance();
    String? roleFrompreference = store.getString('role');
    role = jsonDecode(roleFrompreference!);
    if (!store.containsKey("userData")) {
      await LogsController.printLog(
          LoginController, "ERROR", "Auto Login Failed");
      return false;
    } else {
      await LogsController.printLog(
          LoginController, "INFO", "Auto Login Successful");
      return true;
    }
  }

  static logOut() async {
    final store = await SharedPreferences.getInstance();
    store.clear();
    if (FirebaseAuth.instance != null) {
      await FirebaseAuth.instance.signOut();
      await FacebookAuth.i.logOut();
      await SignInApi.googleSignIn.signOut();
    } else {}
    await LogsController.printLog(
        LoginController, "INFO", "Log Out Successful");
  }

  // Future<void> authenticateFingerprint() async {
  //   try {
  //     if (await _localAuthentication.canCheckBiometrics) {
  //       isAuthenticated = await _localAuthentication.authenticate(
  //           localizedReason: 'Scan your fingerprint to authenticate',
  //           options: const AuthenticationOptions(
  //             stickyAuth: true,
  //             // biometricOnly: true,
  //           ));
  //     } else {
  //       print('Fingerprint authentication not available');
  //     }
  //   } catch (e) {
  //     print('Fingerprint authentication failed: $e');
  //   }

  //   if (isAuthenticated) {
  //     print('Fingerprint authentication successful');
  //   } else {
  //     print('Fingerprint authentication failed');
  //   }
  // }

  Future<bool> authenticateFingerprintAndFaceDetection(
      BuildContext context) async {
    try {
      bool isBiometricAvailable = await _localAuthentication.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();
      bool isFingerprintAvailable =
          availableBiometrics.contains(BiometricType.fingerprint);
      bool isFaceRecognitionAvailable =
          availableBiometrics.contains(BiometricType.face);
      // if (isBiometricAvailable && availableBiometrics.isNotEmpty) {
      if ((isFingerprintAvailable || isFaceRecognitionAvailable) &&
          availableBiometrics.isNotEmpty) {
        isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        );

        if (!isAuthenticated) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: const Center(child: Text('Warning')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Center(
                        child: Text(
                            'Authentication is required to access the app.'),
                      ),
                    ],
                  ),
                  actions: [
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          try {
                            isAuthenticated =
                                await _localAuthentication.authenticate(
                              localizedReason:
                                  'Scan your fingerprint to authenticate',
                              useErrorDialogs: true,
                              stickyAuth: true,
                              biometricOnly: true,
                            );
                            if (isAuthenticated) {
                              Navigator.pop(context);
                            }
                          } catch (e) {}
                        },
                        child: Text('Unlock Now'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
      return isAuthenticated;
    } catch (e) {
      print('Fingerprint authentication failed: $e');
      return isAuthenticated;
    }
  }

  onBackButton(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Warning'),
            content: Text('Authentication is required to access the app.'),
            actions: [
              TextButton(
                onPressed: () async {
                  bool isValid =
                      await authenticateFingerprintAndFaceDetection(context);
                  if (isValid) {
                    Navigator.pop(context);
                  }
                },
                child: Text('Unlock Again'),
              ),
            ],
          ),
        );
      },
    );
  }
}
