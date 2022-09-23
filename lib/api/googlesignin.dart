import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi extends ChangeNotifier {
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

  Future signinwithfacebook() async {
    print("FaceBook login called");
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
        print(result.status);
        Get.to(() => HomeScreen());
      }
    } catch (error) {
      print(error);
    }
  }

  Future logout() async {
    await googleSignIn.disconnect();
    await FacebookAuth.i.logOut();
    FirebaseAuth.instance.signOut();
  }
}
