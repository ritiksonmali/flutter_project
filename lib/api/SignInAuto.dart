import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/Controller/PushNotificationController.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/mobileNumber.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/globals.dart';

class SignInApi extends ChangeNotifier {
  final PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());
//  default password and sso flag for google and facebook login
  final String Defaultpassword = 'Flutter@123';
  final bool sos = true;

  String deviceType = 'Android';

  static final googleSignIn = GoogleSignIn();

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

      dynamic str = userCredential.user?.displayName;

      String a = str.toString();

      var splituser = a.split(' ');
      if (userCredential.user != null) {
        CommanDialog.showLoading();
        await Future.delayed(const Duration(seconds: 8));
        // print(splituser[0] + splituser[1]);
        RestApiTest(splituser[0], splituser[1], googleUser!.email,
            Defaultpassword, sos);
        // Get.to(() => HomeScreen());
      } else {
        print('not verified');
      }
    } on Exception catch (e) {
      e.printError();
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
      String str = userData['name'];

      //split string
      var arr = str.split(' ');

      RestApiTest(arr[0], arr[1], userData['email'], Defaultpassword, sos);
    }
  }

  Future RestApiTest(
      String firstname, lastname, email, password, bool sos) async {
    try {
      if (email != null) {
        String url = '${serverUrl}api/auth/signinwithsso';
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'firstName': firstname,
              'lastName': lastname,
              'email': email,
              'password': Defaultpassword,
              'sos': sos,
            }));

        var userDetails = jsonDecode(response.body);
        print(response.body);

        var store = await SharedPreferences.getInstance();
        if (response.statusCode == 200) {
          print("Succesfully Logged in......!");
          store.setString('userData', json.encode(userDetails['result']));
          store.setString('id', json.encode(userDetails['result']['id']));
          store.setString(
              'firstname', json.encode(userDetails['result']['firstName']));
          store.setString(
              'lastname', json.encode(userDetails['result']['lastName']));
          store.setString('email', json.encode(userDetails['result']['email']));
          store.setString('role', json.encode(userDetails['result']['role']));
          String? roleFrompreference = store.getString('role');
          role = jsonDecode(roleFrompreference!);
          pushNotificationController.sendNotificationData(
              deviceToken, deviceType);
          CommanDialog.hideLoading();
          if (userDetails['result']['new'] == true) {
            Get.to(() => const MobileNumberScreen(),
                arguments: {'uId': userDetails['result']['id']});
          } else {
            Get.off(() => const HomeScreen());
          }

          // CommanDialog.hideLoading();
          // Get.off(() => HomeScreen());
        } else if (response.statusCode == 401) {
          Get.snackbar('Error', 'Email Already use for another account',
              backgroundColor: Colors.redAccent, colorText: Colors.black);
          print("Please Enter Valid Email and Password");
        } else if (response.statusCode == 400) {
          print("Bad Request");
        } else {
          // print("failed");
        }
      } else {
        CommanDialog.hideLoading();
        print("failed");
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.redAccent,
          messageText: Text(
              'Sorry Your  Email is Not Connected with Your Account Kindly Conncet It'),
        ));
      }
    } catch (e) {
      e.printError();
    }
  }
}
