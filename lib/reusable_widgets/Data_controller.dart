// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_login_app/reusable_widgets/auth_controller.dart';
// import 'package:get/get.dart';

// class DataController extends GetxController {
//   final firebaseInstance = FirebaseFirestore.instance;
//   Map userProfileData = {'userName': '', 'email': ''};

//   AuthController authController = AuthController();

//   void onReady() {
//     super.onReady();

//     getUserProfileData();
//   }

//   Future<void> getUserProfileData() async {
//     // print("user id ${authController.userId}");
//     try {
//       var response = await firebaseInstance
//           .collection('userslist')
//           .where('user_Id', isEqualTo: authController.userId)
//           .get();
//       // response.docs.forEach((result) {
//       //   print(result.data());
//       // });
//       if (response.docs.length > 0) {
//         userProfileData['userName'] = response.docs[0]['user_name'];
//         userProfileData['email'] = response.docs[0]['email'];
//       }
//       print(userProfileData);
//     } on FirebaseException catch (e) {
//       print(e);
//     } catch (error) {
//       print(error);
//     }
//   }
// }
