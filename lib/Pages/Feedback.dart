import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();
  double halfRating = 0;
  int? id;
  final _formKey5 = GlobalKey<FormState>();

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      this.id = id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 48,
          child: MaterialButton(
            onPressed: () {
              checkValidations();
            },
            child: Text(
              "Send Feedback",
              style: TextStyle(
                color: white,
              ),
            ),
            color: buttonColour,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Send Your Feedback',
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w400,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Tell us What You love about the App or what we could be doing better',
                  style: TextStyle(
                    color: Colors.grey[600],
                    overflow: TextOverflow.fade,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: TextFormField(
                  controller: titleController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.black87,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    filled: true,
                    // hintText: 'Enter message title',
                    label: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Enter message title',
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: black,
                              ),
                              children: [
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ],
                    ),
                    // labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter message title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: bodyController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,

                    label: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Enter your feedback here',
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: black,
                              ),
                              children: [
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ],
                    ),
                    // hintText: 'Enter your feedback here',
                    filled: true,
                  ),
                  maxLines: 5,
                  maxLength: 500,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Feedback here';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              Center(
                child: const Text(
                  'Rate Your Experience',
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w400,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  allowHalfRating: true,
                  unratedColor: Color.fromARGB(255, 188, 186, 186),
                  itemCount: 5,
                  itemSize: 50.0,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  updateOnDrag: true,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: buttonColour,
                  ),
                  onRatingUpdate: (ratingvalue) {
                    setState(() {
                      halfRating = ratingvalue;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Rating : $halfRating',
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkValidations() {
    if (_formKey5.currentState!.validate()) {
      print("Form is valid ");
      _formKey5.currentState!.save();
      if (halfRating != 0) {
        sendYourFeedbackApi(titleController.text.toString(),
            bodyController.text.toString(), id!, halfRating);
      } else {
        Fluttertoast.showToast(
            msg: 'please give us Rating',
            gravity: ToastGravity.BOTTOM_RIGHT,
            fontSize: 18,
            backgroundColor: Colors.red,
            textColor: white);
      }
    } else {
      print('Form is Not Valid');
    }
  }

  Future sendYourFeedbackApi(
      String title, String body, int userId, double rating) async {
    String url = serverUrl + 'api/auth/addYourFeedback';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "body": body,
          "rating": rating,
          "title": title,
          "userId": userId
        }));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        titleController.clear();
        bodyController.clear();
      });
      Fluttertoast.showToast(
          msg: 'Your Feedback Sent Successfully !',
          gravity: ToastGravity.BOTTOM_RIGHT,
          fontSize: 18,
          backgroundColor: Colors.green,
          textColor: white);
    }
  }
}
