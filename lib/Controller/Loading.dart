// import 'package:flutter/material.dart';
// import 'package:flutter_login_app/Controller/LocalImagesController.dart';
// import 'package:get/get.dart';

// class LoadingWidget extends StatelessWidget {
//   final LocalImagesController controller = Get.put(LocalImagesController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Obx(() {
//           return controller.loading // Check the loading flag
//               ? const CircularProgressIndicator()
//               : const Text('Images loaded!');
//         }),
//       ),
//     );
//   }
// }
