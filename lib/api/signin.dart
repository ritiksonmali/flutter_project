import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/model/User.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInApi extends ChangeNotifier {
//  default password and sso flag for google and facebook login
  final String Defaultpassword = 'Flutter@123';
  final bool sos = true;

  Users user = Users();

  static final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

 // GoogleSignInAccount get user => _user!;

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

      dynamic str = userCredential.user?.displayName;

      String a = str.toString();

      var splituser = a.split(' ');

      if (userCredential.user != null) {
        CommanDialog.showLoading();
        RestApiTest(splituser[0], splituser[1], userCredential.user?.email,
            this.Defaultpassword, this.sos);
        // Get.to(() => HomeScreen());
      } else {
        print('not verified');
      }
    } on Exception catch (e) {
      print(e);
    }

    // notifyListeners();
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
      CommanDialog.showLoading();
      final userData = await FacebookAuth.i.getUserData();
      // print(userData);
      String str = userData['name'];

      //split string
      var arr = str.split(' ');

      RestApiTest(
          arr[0], arr[1], userData['email'], this.Defaultpassword, this.sos);

      
    }
  }


  Future RestApiTest(
      String firstname, lastname, email, password, bool sos) async {
    try {
      print(firstname + " " + lastname + " " + email + " " + password);
      print(sos);

      String url = 'http://10.0.2.2:8082/api/auth/signinwithsso';
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'firstName': firstname,
            'lastName': lastname,
            'email': email,
            'password': this.Defaultpassword,
            'sos': sos,
          }));

      Map userDetails = jsonDecode(response.body);
      Map user = userDetails['result'];

      var store = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        print("Succesfully Logged in......!");
        store.setString('userData', json.encode(user));
        print(store);
       

        CommanDialog.hideLoading();
        Get.snackbar('Hi', 'Login SuccessFully !',
            backgroundColor: Colors.green, colorText: Colors.black);
        Get.off(() => HomeScreen());
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', 'Email Already use for anothe account',
            backgroundColor: Colors.redAccent, colorText: Colors.black);
        print("Please Enter Valid Email and Password");
      } else if (response.statusCode == 400) {
        print("Bad Request");
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}