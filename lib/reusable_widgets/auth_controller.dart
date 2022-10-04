import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var userId;
  Future<void> signUp(email, password, username) async {
    try {
      CommanDialog.showLoading();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password);

      print(userCredential);
      CommanDialog.hideLoading();
      Get.back();
    } on FirebaseAuthException catch (e) {
      CommanDialog.hideLoading();
      if (e.code == 'weak-password') {
        CommanDialog.showErrorDialog(
            description: 'The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CommanDialog.showErrorDialog(
            description: 'The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      CommanDialog.hideLoading();
      CommanDialog.showErrorDialog(description: 'Something Went Wrong');
      print(e);
    }
  }

  Future<void> logiN(email, password) async {
    print('$email, $password');
    try {
      CommanDialog.showLoading();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      print(userCredential.user!.uid);

      userId = userCredential.user!.uid;

      CommanDialog.hideLoading();
      Get.off(() => HomeScreen());
    } on FirebaseAuthException catch (e) {
      CommanDialog.hideLoading();
      if (e.code == 'user-not-found') {
        CommanDialog.showErrorDialog(
            description: 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CommanDialog.showErrorDialog(
            description: 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> ForgetPassword(email) async {
    print('$email');

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      CommanDialog.hideLoading();
      if (e.code == 'user-not-found') {
        CommanDialog.showErrorDialog(
            description: 'No user found for that email.');
        print('No user found for that email.');
      }
    }
  }
}
