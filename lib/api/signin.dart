import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/api/signincontroller.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignInApi extends ChangeNotifier {
  LoginStatus? result;
  SigninController controller = Get.put(SigninController());
//  default password and sso flag for google and facebook login
  String Defaultpassword = 'Flutter@123';
  bool sos = true;

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future SignInwithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _user = googleUser;
      }

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredential.user?.displayName);
      print(userCredential.user?.email);

      if (userCredential.user != null) {
        Get.to(() => HomeScreen());
      } else {
        print('not verified');
      }
    } on Exception catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future signinwithfacebook() async {
    print("FaceBook login called");

    final result =
        await FacebookAuth.i.login(permissions: ['public_profile', 'email']);

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    final Loginresult =
        FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      print(userData);
      String str = userData['name'];

      //split string
      var arr = str.split(' ');

      print(controller.signUp(
          arr[0], arr[1], userData['email'], Defaultpassword, sos));

      // print(arr[0]);
      // print(arr[1]);
      // print(Defaultpassword);

      // this.result = result.status;
      // print(result.status);
      // Get.to(() => HomeScreen());
    }
  }

  Future logout(String url) async {
    try {
      await FirebaseAuth.instance.signOut();
      await FacebookAuth.i.logOut();

      await googleSignIn.signOut();

      // await googleSignIn.disconnect();
      await url;
      print('logout success');

      // await FacebookLogin().logOut();

    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  // Future RestApiTest(
  //     String firstname, lastname, email, password, bool sos) async {
  //   try {
  //     print(firstname + " " + lastname + " " + email + " " + password);
  //     print(sos);

  //     String url = 'http://10.0.2.2:8082/api/auth/signinwithsso';
  //     http.Response response = await http.post(Uri.parse(url),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode({
  //           'firstName': firstname,
  //           'lastName': lastname,
  //           'email': email,
  //           'password': password,
  //           'sos': sos,
  //         }));

  //     if (response.statusCode == 200) {
  //       print("Success");

  //       Get.off(() => HomeScreen());
  //     } else if (response.statusCode == 401) {

  //       print("Please Enter Valid Email and Password");
  //     } else if (response.statusCode == 400) {
  //       print("Bad Request");
  //     } else {
  //       print("failed");
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
