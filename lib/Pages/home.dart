import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Pages/cards.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:raised_buttons/raised_buttons.dart';
import 'package:path/path.dart' as Path;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // radio button configuration
  var _value = 0;
  // database reference
  late DatabaseReference databaseref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // databaseref = FirebaseDatabase.instance.ref().child('users');
  }

  final numberController = TextEditingController();
  final snameController = TextEditingController();
  final gnameController = TextEditingController();
  final natureController = TextEditingController();
  final engineController = TextEditingController();
  final rupeesController = TextEditingController();
  final partController = TextEditingController();
  final costController = TextEditingController();

  Future setData() async {
    try {
      CommanDialog.showLoading();
      var response =
          await FirebaseFirestore.instance.collection('Details').add({
        'vehicle number': numberController.text,
        'supervisor name': snameController.text,
        'garage name': gnameController.text,
        'nature of the brake': natureController.text,
        'engine': engineController.text,
        '₹ 5000': rupeesController.text,
        'part list': partController.text,
        'cost': costController.text,
        'dateAndTime': datetime,
        'image': url,
      });
      print("Firebase response ${response.id}");
      CommanDialog.hideLoading();
    } catch (exception) {
      CommanDialog.hideLoading();
      print("Error Saving Data at firestore $exception");
    }
  }

  DateTime? date;
  DateTime? datetime;
  TimeOfDay? time;

  String getText() {
    if (date == null) {
      return 'Select Date and Time';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  String getTime() {
    if (time == null) {
      return 'Select Date and Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

  String getDateAndTime() {
    String str;

    if (time == null) {
      return 'Select Date and Time';
    } else {
      return '${datetime!.day}/${datetime!.month}/${datetime!.year} ${datetime!.hour}:${datetime!.minute}';
    }
  }

  Future pickDateAndTime(BuildContext context) async {
    DateTime? date = await pickDate(context);

    if (date == null) return;

    TimeOfDay? time = await pickTime(context);

    if (time == null) return;

    final datetime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      this.datetime = datetime;
    });
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime(DateTime.now().year + 100));

    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
    return newDate;
  }

  Future pickTime(BuildContext context) async {
    final initialtime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialtime);
    if (newTime == null) return;
    setState(() {
      time = newTime;
    });
    return newTime;
  }

  PickedFile? pickedfile;
  PickedFile? pickedfile1;
  PickedFile? pickedfile2;
  PickedFile? pickedfile3;

  UploadTask? uploadTask;
  UploadTask? uploadTask1;
  UploadTask? uploadTask2;
  UploadTask? uploadTask3;

  String? url;
  String? url1;
  String? url2;
  String? url3;

  String getImageText() {
    if (pickedfile == null) {
      return 'image.png';
    } else {
      return 'image selected';
    }
  }

  String getImageText1() {
    if (pickedfile1 == null) {
      return 'image1.png';
    } else {
      return 'image selected';
    }
  }

  String getImageText2() {
    if (pickedfile2 == null) {
      return 'upload new image';
    } else {
      return 'new image uploaded';
    }
  }

  String getImageText3() {
    if (pickedfile3 == null) {
      return 'upload old image';
    } else {
      return 'old image uploaded';
    }
  }

  Future getimages() async {
    try {
      if (pickedfile != null) {
        final path = 'images/${Path.basename(pickedfile!.path)}';
        final file = File(pickedfile!.path);
        final ref = FirebaseStorage.instance.ref().child(path);

        uploadTask = ref.putFile(file);

        final snapshot = await uploadTask!.whenComplete(() => () {});

        final urlDownload = await snapshot.ref.getDownloadURL();

        print('print url: $urlDownload');

        url = urlDownload.toString();

        print(url);

        return url;
      } else {
        return Get.snackbar(
          "Alert",
          "Images Required..!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Theme.of(context).errorColor,
          colorText: Colors.white,
        );
      }
    } on Exception catch (e) {
      StackTrace.current;
      // TODO
    }
  }

  Future getimages1() async {
    try {
      if (pickedfile1 != null) {
        final path = 'images/${Path.basename(pickedfile1!.path)}';
        final file = File(pickedfile1!.path);
        final ref = FirebaseStorage.instance.ref().child(path);

        uploadTask1 = ref.putFile(file);

        final snapshot = await uploadTask1!.whenComplete(() => () {});

        final urlDownload1 = await snapshot.ref.getDownloadURL();
        print('print url 1: $urlDownload1');

        return url1 = urlDownload1.toString();
      } else {
        return Get.snackbar(
          "Alert",
          "Images Required..!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Theme.of(context).errorColor,
          colorText: Colors.white,
        );
      }
    } on Exception catch (e) {
      StackTrace.current;
      // TODO
    }
  }

  Future getimages2() async {
    try {
      if (pickedfile != null) {
        final path = 'images/${Path.basename(pickedfile2!.path)}';
        final file = File(pickedfile2!.path);
        final ref = FirebaseStorage.instance.ref().child(path);

        uploadTask2 = ref.putFile(file);

        final snapshot = await uploadTask2!.whenComplete(() => () {});

        final urlDownload2 = await snapshot.ref.getDownloadURL();
        print('print url 2: $urlDownload2');

        return url2 = urlDownload2.toString();
      } else {
        return Get.snackbar(
          "Alert",
          "Images Required..!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Theme.of(context).errorColor,
          colorText: Colors.white,
        );
      }
    } on Exception catch (e) {
      StackTrace.current;
      // TODO
    }
  }

  Future getimages3() async {
    try {
      if (pickedfile != null) {
        final path = 'images/${Path.basename(pickedfile3!.path)}';
        final file = File(pickedfile3!.path);
        final ref = FirebaseStorage.instance.ref().child(path);

        uploadTask3 = ref.putFile(file);

        final snapshot = await uploadTask3!.whenComplete(() => () {});

        final urlDownload3 = await snapshot.ref.getDownloadURL();
        print('print url 3: $urlDownload3');
        return url3 = urlDownload3.toString();
      } else {
        return Get.snackbar(
          "Alert",
          "Images Required..!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Theme.of(context).errorColor,
          colorText: Colors.white,
        );
      }
    } on Exception catch (e) {
      StackTrace.current;
      // TODO
    }
  }

  getAllImages() {
    if (pickedfile != null &&
        pickedfile1 != null &&
        pickedfile2 != null &&
        pickedfile3 != null) {
      getimages();
      getimages1();
      getimages2();
      getimages3();
    } else {
      Get.snackbar(
        "Alert",
        "Images Required..!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).errorColor,
        colorText: Colors.white,
      );
    }
  }

  Future imagePicker() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedfile = image;
    });
  }

  Future imagePicker1() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedfile1 = image;
    });
  }

  Future imagePicker2() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedfile2 = image;
    });
  }

  Future imagePicker3() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedfile3 = image;
    });
  }

  // form key
  final _formKey = GlobalKey<FormState>();

  // radio button base value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Parts List',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 15),
                child: Center(
                  child: ListView(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                minimumSize: Size(1, 1)),
                            icon: Icon(Icons.calendar_month_outlined,
                                color: Colors.black54),
                            label: Text(
                              getDateAndTime(),
                              style: TextStyle(color: Colors.black38),
                            ),
                            onPressed: (() {
                              pickDateAndTime(context);
                            }),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: numberController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Vehicle Number',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        // validation of input fields
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid number';
                          }
                          return null;
                        },

                        cursorColor: Colors.black54,
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(13),
                        ],
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: snameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Supervisor Name',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        // validation of input fields
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Supervisor name';
                          }
                          return null;
                        },
                        cursorColor: Colors.black54,
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(15),
                        ],
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: gnameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Garage Name',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        // validation of input fields
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Garage name';
                          }
                          return null;
                        },
                        cursorColor: Colors.black54,
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: natureController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Nature of Break Down',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        // validation of input fields
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required';
                          }
                          return null;
                        },
                        cursorColor: Colors.black54,
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(20),
                        ],
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Part Details',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: engineController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Engine',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        // validation of input fields
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter engine details';
                          }
                          return null;
                        },
                        cursorColor: Colors.black54,
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(20),
                        ],
                        textInputAction: TextInputAction.done,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(1),
                              minimumSize: Size(1, 1)),
                          icon: Icon(Icons.upload_file, color: Colors.black54),
                          label: Text(
                            getImageText(),
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: (() {
                            imagePicker();
                          }),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(1),
                              minimumSize: Size(1, 1)),
                          icon: Icon(Icons.upload_file, color: Colors.black54),
                          label: Text(
                            getImageText1(),
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: (() {
                            imagePicker1();
                          }),
                        ),
                      ),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: rupeesController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  style: TextStyle(),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      labelText: '₹ 5000',
                                      labelStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter amount';
                                    }
                                    return null;
                                  },
                                  cursorColor: Colors.black54,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              Row(
                                children: [
                                  Radio(
                                      activeColor:
                                          Color.fromARGB(255, 181, 57, 57),
                                      value: 1,
                                      groupValue: _value,
                                      onChanged: (value) {}),
                                  SizedBox(
                                    width: 1.0,
                                  ),
                                  Text(
                                    'Estimated',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ]),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.only(
                                    top: 0, bottom: 0, left: 0, right: 0),
                                backgroundColor: Colors.transparent),
                            child: buildtext('+ Add new part details'),
                            onPressed: () => print('short pressed'),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: partController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Part Name',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter part name';
                          }
                          return null;
                        },
                        cursorColor: Colors.black54,
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(30),
                        ],
                        textInputAction: TextInputAction.done,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                minimumSize: Size(1, 1)),
                            icon:
                                Icon(Icons.upload_file, color: Colors.black54),
                            label: Text(
                              getImageText2(),
                              style: TextStyle(color: Colors.black38),
                            ),
                            onPressed: (() {
                              imagePicker2();
                            }),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.all(1),
                                minimumSize: Size(1, 1)),
                            icon:
                                Icon(Icons.upload_file, color: Colors.black54),
                            label: Text(
                              getImageText3(),
                              style: TextStyle(color: Colors.black38),
                            ),
                            onPressed: (() {
                              imagePicker3();
                            }),
                          ),
                        ],
                      ),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: costController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  style: TextStyle(),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      labelText: 'Cost',
                                      labelStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w500),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter cost';
                                    }
                                    return null;
                                  },
                                  cursorColor: Colors.black54,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(20),
                                  ],
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              Row(
                                children: [
                                  Radio(
                                      activeColor:
                                          Color.fromARGB(255, 181, 57, 57),
                                      value: 1,
                                      groupValue: _value,
                                      onChanged: (value) {}),
                                  SizedBox(
                                    width: 1.0,
                                  ),
                                  Text(
                                    'Estimated',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.only(
                                        top: 0, bottom: 0, left: 0, right: 0),
                                    backgroundColor: Colors.transparent),
                                child: buildtext1('+ Add new part details'),
                                onPressed: () => print('short pressed'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: Size(70, 25),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    side: BorderSide(color: Colors.green),
                                    padding: EdgeInsets.only(
                                        top: 2, bottom: 2, left: 12, right: 12),
                                    backgroundColor: Colors.white),
                                child: Text(
                                  'Send to admin',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    getAllImages();
                                    setData();
                                  } else {
                                    CommanDialog.showErrorDialog(
                                        title: 'Warning',
                                        description: 'Please Fill The Form..!');
                                    print("not validated");
                                  }
                                },
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
                color: Color(identityHashCode('#fed1da')),
                width: 600,
                height: 650,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildtext(String text) => Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      );

  Widget buildtext1(String text) => Text(
        text,
        style: TextStyle(color: Colors.black87, fontSize: 12),
      );
}

// Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: <Widget>[
//     Container(
//       height: 30,
//       margin: EdgeInsets.only(right: 130),
//       child: TextField(
//         style: TextStyle(),
//         decoration: InputDecoration(
//             labelText: '₹ 5000',
//             labelStyle: TextStyle(
//                 fontSize: 12,
//                 color: Colors.black,
//                 fontWeight: FontWeight.w700),
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8)),
//             enabledBorder: OutlineInputBorder(
//                 borderSide:
//                     BorderSide(color: Colors.black)),
//             focusedBorder: OutlineInputBorder(
//                 borderSide:
//                     BorderSide(color: Colors.black))),
//         cursorColor: Colors.black54,
//         keyboardType: TextInputType.emailAddress,
//         textInputAction: TextInputAction.done,
//       ),
//     ),
//     Row(
//       children: [
//         Radio(
//             activeColor:
//                 Color.fromARGB(255, 181, 57, 57),
//             value: 1,
//             groupValue: _value,
//             onChanged: (value) {}),
//         SizedBox(
//           width: 1.0,
//         ),
//         Text(
//           'Estimated',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ],
//     )
//   ],
// ),
