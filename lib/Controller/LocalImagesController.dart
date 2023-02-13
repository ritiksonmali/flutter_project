import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalImagesController extends GetxController {
  DateTime currentTime = DateTime.now();
  var LastUpdatedDate = '';
  Future getLastUpdatedDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('date') != null) {
      LastUpdatedDate = prefs.getString('date').toString();
      LastUpdatedDate = '';
      print(LastUpdatedDate);
    }
    return LastUpdatedDate;
  }

  Future<bool> getAllProductCompressedImages() async {
    try {
      String date = await getLastUpdatedDate();
      String url =
          serverUrl + 'api/auth/getAllProductCompressedImages?date=${date}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body.isNotEmpty) {
        body.forEach(
          (key, value) async {
            Uint8List byteImage = convertBase64Image(value);
            final directory = await getApplicationDocumentsDirectory();
            if (await File('${directory.path}/${key}').exists()) {
              // File('${directory.path}/${key}').delete();
              print("File Already Exist");
            } else {
              final pathOfImage =
                  await File('${directory.path}/${key}').create();
              File file = await pathOfImage.writeAsBytes(byteImage);
              print(file);
              fileList.add(file);
            }
          },
        );
        if (date.isEmpty) {
          LastUpdatedDate = DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(currentTime.toUtc().toLocal());
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("date", LastUpdatedDate);
          print("Date updated successfully");
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> getAllProductImages() async {
    try {
      String date = await getLastUpdatedDate();
      String url = serverUrl + 'api/auth/getAllProductImages?date=${date}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      Map<String, dynamic> body = jsonDecode(response.body);
      // print(body);
      if (body.isNotEmpty) {
        body.forEach(
          (key, value) async {
            bool isadded = false;
            Uint8List byteImage = convertBase64Image(value);
            final directory = await getApplicationDocumentsDirectory();
            if (await File('${directory.path}/${key}').exists()) {
              print("File Already Exist");
              // File('${directory.path}/${key}').delete();
              isadded = true;
            } else {
              final pathOfImage =
                  await File('${directory.path}/${key}').create();
              File file = await pathOfImage.writeAsBytes(byteImage);
              print(file);
              isadded = true;
              fileList.add(file);
            }
          },
        );
        if (date.isEmpty) {
          LastUpdatedDate = DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(currentTime.toUtc().toLocal());
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("date", LastUpdatedDate);
          print("Date updated successfully");
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Uint8List convertBase64Image(String base64String) {
    return Base64Decoder().convert(base64String.split(',').last);
  }

  // Future getallImages() async {
  //   await getAllProductCompressedImages();
  // }
}
