import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/LocalImagesController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddImages extends StatefulWidget {
  const AddImages({Key? key}) : super(key: key);

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  // LocalImagesController localImagesController =
  //     Get.put(LocalImagesController());
  List images = [];
  List<File> photos = [];
  List<Uint8List> bytelist = [];
  List<Uint8List> LocalImageList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getApi();
    // localImagesController.getAllProductCompressedImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: fileList.length,
        // itemExtent: images.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Image.file(
                fileList[index],
                fit: BoxFit.cover,
                height: 100,
                width: 200,
              ),
            ],
          );
        },
      ),
    );
  }

  Int8List? _bytes;

  getApi() async {
    try {
      String url = serverUrl + 'api/auth/getAllImages';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      Map<String, dynamic> body = jsonDecode(response.body);
      // var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      // print(jsonResponse);
      // body.forEach(
      //   (key, value) async {
      //     Uint8List byteImage = convertBase64Image(value);
      //     final directory = await getApplicationDocumentsDirectory();
      //     final pathOfImage = await File('${directory.path}/${key}').create();
      //     File file = await pathOfImage.writeAsBytes(byteImage);
      //     print(file.path);
      //     setState(() {
      //       fileList.add(file);
      //     });
      //     final SharedPreferences prefs = await SharedPreferences.getInstance();
      //     prefs.setString(key, value);
      //     Uint8List localImage =
      //         convertBase64Image(prefs.getString(key).toString());
      //     setState(() {
      //       LocalImageList.add(localImage);
      //     });
      //     //   setState(() {
      //     //   bytelist.add(byteImage);
      //     // });
      //   },
      // );
      // for (var image in body.values) {
      //   Uint8List byteImage = convertBase64Image(image);
      //   setState(() {
      //     bytelist.add(byteImage);
      //   });
      //   // Image img = Image.memory(byteImage);
      //   // File file = await File('orange.png').writeAsBytes(byteImage);
      //   // print(file);
      //   // fileList.add(file as File);
      //   // print(demo);
      //   final SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("image", image);
      //   Uint8List localImage =
      //       convertBase64Image(prefs.getString("image").toString());
      //   setState(() {
      //     LocalImageList.add(localImage);
      //   });
      //   // print(localImage);
      //   // Image files = Image.memory(demo);
      //   // Directory documentDirectory = await getApplicationDocumentsDirectory();
      //   // File file = new File(join(documentDirectory.path, 'imagetest.png'));
      //   // file.writeAsBytesSync(response.bodyBytes);
      //   // final result = await ImageGallerySaver.saveImage(
      //   //     Uint8List.fromList(demo),
      //   //     quality: 60,
      //   //     name: "hello");
      //   // print(result);
      // }
      return photos;
    } catch (e) {
      print(e.toString());
    }
  }

  Uint8List convertBase64Image(String base64String) {
    return Base64Decoder().convert(base64String.split(',').last);
  }
}
