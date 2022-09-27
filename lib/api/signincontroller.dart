import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/home_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SigninController extends GetxController {
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  bool? sos;

  Future<void> signUp(
      String firstname, lastname, email, password, bool sos) async {
    this.firstname = firstname;
    this.lastname = lastname;
    this.email = email;
    this.password = password;
    this.sos = sos;
    print(this.email);
    print(this.firstname);
    print(this.lastname);
  }
}
