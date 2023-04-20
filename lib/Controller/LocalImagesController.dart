import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LogsController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalImagesController extends GetxController {
  DateTime currentTime = DateTime.now();
  // ignore: non_constant_identifier_names
  var LastUpdatedDate = '';
  bool loading = false; // Add a loading flag
  bool imagesExist =
      false; // Add a flag to check if images exist in local storage or not

  Future getLastUpdatedDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('date') != null) {
      LastUpdatedDate = prefs.getString('date').toString();
    }
    return LastUpdatedDate;
  }

  Future<void> init() async {
    // Initialize the controller here
    await getLastUpdatedDate();
  }

  Future<bool> getAllProductCompressedImages() async {
    try {
      String date = await getLastUpdatedDate();
      String url =
          '${serverUrl}api/auth/getAllProductCompressedImages?date=$date';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body.isNotEmpty) {
          loading = true; // Set loading to true before fetching images
          update(); // Update the UI
          await Future.forEach(body.entries,
              (MapEntry<String, dynamic> entry) async {
            Uint8List byteImage = convertBase64Image(entry.value);
            final directory = await getApplicationDocumentsDirectory();
            if (await File('${directory.path}/${entry.key}').exists()) {
              imagesExist = true; // Set the flag to true if any image exists
              // File('${directory.path}/${entry.key}').delete();
            } else {
              final pathOfImage =
                  await File('${directory.path}/${entry.key}').create();
              File file = await pathOfImage.writeAsBytes(byteImage);
              fileList.add(file);
              // LogsController.printLog(LocalImagesController, "INFO",
              //     "local images fetched successfully");
            }
          });
          if (!imagesExist) {
            // If no images exist in local storage
            LastUpdatedDate = '';
          } else if (date.isEmpty) {
            // If images exist in local storage and no date was provided in the API call
            LastUpdatedDate = DateFormat('dd-MM-yyyy HH:mm:ss')
                .format(currentTime.toUtc().toLocal());
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString("date", LastUpdatedDate);
          }
          loading = false; // Set loading to false after fetching images
          update(); // Update the UI
          return true;
        }
      }
      return false;
    } catch (e) {
      e.printError();
      LogsController.printLog(LocalImagesController, "ERROR", e);
      return false;
    }
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }
}


// class LocalImagesController extends GetxController {
//   DateTime currentTime = DateTime.now();
//   // ignore: non_constant_identifier_names
//   var LastUpdatedDate = '';
//   bool loading = false; // Add a loading flag

//   Future getLastUpdatedDate() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('date') != null) {
//       LastUpdatedDate = prefs.getString('date').toString();
//     }
//     return LastUpdatedDate;
//   }

//   Future<bool> getAllProductCompressedImages() async {
//     try {
//       String date = await getLastUpdatedDate();
//       String url =
//           '${serverUrl}api/auth/getAllProductCompressedImages?date=$date';
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );
//       Map<String, dynamic> body = jsonDecode(response.body);
//       if (body.isNotEmpty) {
//         loading = true; // Set loading to true before fetching images
//         update(); // Update the UI
//         body.forEach(
//           (key, value) async {
//             Uint8List byteImage = convertBase64Image(value);
//             final directory = await getApplicationDocumentsDirectory();
//             if (await File('${directory.path}/$key').exists()) {
//               // File('${directory.path}/${key}').delete();
//             } else {
//               final pathOfImage = await File('${directory.path}/$key').create();
//               File file = await pathOfImage.writeAsBytes(byteImage);
//               fileList.add(file);
//               // LogsController.printLog(LocalImagesController, "INFO",
//               //     "local images fetched successfully");
//             }
//           },
//         );
//         if (date.isEmpty) {
//           LastUpdatedDate = DateFormat('dd-MM-yyyy HH:mm:ss')
//               .format(currentTime.toUtc().toLocal());
//           final SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString("date", LastUpdatedDate);
//         }
//         loading = false; // Set loading to false after fetching images
//         update(); // Update the UI
//         return true;
//       }
//       return false;
//     } catch (e) {
//       e.printError();
//       LogsController.printLog(LocalImagesController, "ERROR", e);
//       return false;
//     }
//   }

//   Uint8List convertBase64Image(String base64String) {
//     return const Base64Decoder().convert(base64String.split(',').last);
//   }
// }

// class LocalImagesController extends GetxController {
//   DateTime currentTime = DateTime.now();
//   // ignore: non_constant_identifier_names
//   var LastUpdatedDate = '';
//   Future getLastUpdatedDate() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('date') != null) {
//       LastUpdatedDate = prefs.getString('date').toString();
//     }
//     return LastUpdatedDate;
//   }

//   Future<bool> getAllProductCompressedImages() async {
//     try {
//       String date = await getLastUpdatedDate();
//       String url =
//           '${serverUrl}api/auth/getAllProductCompressedImages?date=$date';
//       http.Response response = await http.get(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );
//       Map<String, dynamic> body = jsonDecode(response.body);
//       if (body.isNotEmpty) {
//         body.forEach(
//           (key, value) async {
//             Uint8List byteImage = convertBase64Image(value);
//             final directory = await getApplicationDocumentsDirectory();
//             if (await File('${directory.path}/$key').exists()) {
//               LogsController.printLog(LocalImagesController, "INFO",
//                   "Local Images already Available");
//               // File('${directory.path}/${key}').delete();
//             } else {
//               final pathOfImage = await File('${directory.path}/$key').create();
//               File file = await pathOfImage.writeAsBytes(byteImage);
//               fileList.add(file);
//               LogsController.printLog(LocalImagesController, "INFO",
//                   "local images fetched successfully");
//             }
//           },
//         );
//         if (date.isEmpty) {
//           LastUpdatedDate = DateFormat('dd-MM-yyyy HH:mm:ss')
//               .format(currentTime.toUtc().toLocal());
//           final SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString("date", LastUpdatedDate);
//         }
//         return true;
//       }
//       return false;
//     } catch (e) {
//       e.printError();
//       LogsController.printLog(LocalImagesController, "ERROR", e);
//       return false;
//     }
//   }

  // Future<bool> getAllProductImages() async {
  //   try {
  //     String date = await getLastUpdatedDate();
  //     String url = serverUrl + 'api/auth/getAllProductImages?date=${date}';
  //     http.Response response = await http.get(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     Map<String, dynamic> body = jsonDecode(response.body);
  //     // print(body);
  //     if (body.isNotEmpty) {
  //       body.forEach(
  //         (key, value) async {
  //           bool isadded = false;
  //           Uint8List byteImage = convertBase64Image(value);
  //           final directory = await getApplicationDocumentsDirectory();
  //           if (await File('${directory.path}/${key}').exists()) {
  //             print("File Already Exist");
  //             // File('${directory.path}/${key}').delete();
  //             isadded = true;
  //           } else {
  //             final pathOfImage =
  //                 await File('${directory.path}/${key}').create();
  //             File file = await pathOfImage.writeAsBytes(byteImage);
  //             print(file);
  //             isadded = true;
  //             fileList.add(file);
  //           }
  //         },
  //       );
  //       if (date.isEmpty) {
  //         LastUpdatedDate = DateFormat('dd-MM-yyyy HH:mm:ss')
  //             .format(currentTime.toUtc().toLocal());
  //         final SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setString("date", LastUpdatedDate);
  //         print("Date updated successfully");
  //       }
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

//   Uint8List convertBase64Image(String base64String) {
//     return const Base64Decoder().convert(base64String.split(',').last);
//   }
// }
