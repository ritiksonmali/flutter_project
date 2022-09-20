import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final firebaseInstance = FirebaseFirestore.instance;
}
