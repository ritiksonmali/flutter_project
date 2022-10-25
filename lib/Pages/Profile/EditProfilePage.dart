import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../home_screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? PickedImage;

  String? imageUrl;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    String? data = store.getString('userData');
    var userdata = jsonDecode(data!);
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    var firstnamedata = store.getString('firstname');
    var firstname = jsonDecode(firstnamedata!);
    var lastnamedata = store.getString('lastname');
    var lastname = jsonDecode(lastnamedata!);
    var emaildata = store.getString('email');
    var email = jsonDecode(emaildata!);

    setState(() {
      this.user = userdata;
      this.id = id;
      this.firstname = firstname;
      this.lastname = lastname;
      this.email = email;
      getprofileApi(id);
    });
  }

  Map<String, dynamic>? user;

  int? id;
  var firstname;
  var lastname;
  var email;

  @override
  void initState() {
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.to(() => HomeScreen());
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: PickedImage != null
                            ? Image.file(
                                PickedImage!,
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imageUrl != null
                                    ? 'http://10.0.2.2:8082/api/auth/serveprofilepicture/${imageUrl}'
                                    : 'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.black,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print("image Selected");
                              imagePickerOption();
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField(
                  "Firstname", this.firstname, false, firstnamecontrol),
              buildTextField("Lastname", this.lastname, false, lastnamecontrol),
              buildTextField("E-mail", this.email, false, emailcontrol),
              // buildTextField("Password", "Piyush@1", true),
              // buildTextField("Location", "saitara, Nashik", false),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      firstnamecontrol.clear();
                      lastnamecontrol.clear();
                      emailcontrol.clear();
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (firstnamecontrol.text.isNotEmpty ||
                          lastnamecontrol.text.isNotEmpty ||
                          emailcontrol.text.isNotEmpty) {
                        updateUserApi(
                            this.id!,
                            firstnamecontrol.text.isEmpty
                                ? this.firstname
                                : firstnamecontrol.text.toString(),
                            lastnamecontrol.text.isEmpty
                                ? this.lastname
                                : lastnamecontrol.text.toString(),
                            emailcontrol.text.isEmpty
                                ? this.email
                                : emailcontrol.text.toString());
                        firstnamecontrol.clear();
                        lastnamecontrol.clear();
                        emailcontrol.clear();
                      } else {}
                      setState(() {
                        test();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      primary: Colors.black,
                      //color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String? image;

  Future getprofileApi(int id) async {
    try {
      String url = 'http://10.0.2.2:8082/api/auth/getprofilepicture/${id}';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);

      // Uri uris = Uri.dataFromString(body['image']);
      String image = body['image'];
      setState(() {
        imageUrl = image;
      });

      // File.fromUri(Uri.dataFromString(body['image'], base64: true));
      return imageUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserApi(int id, String firstname, lastname, email) async {
    try {
      print(" " + firstname + " " + lastname + " " + email);

      String url = 'http://10.0.2.2:8082/api/auth/updateuser/${id}';
      http.Response response = await http.put(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "email": email,
            'firstName': firstname,
            'lastName': lastname,
          }));

      var store = await SharedPreferences.getInstance();
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("user updated successfully");
        print("response body is :" + response.body);
        store.setString('id', jsonEncode(body['id']));
        store.setString('firstname', jsonEncode(body['firstName']));
        store.setString('lastname', jsonEncode(body['lastName']));
        store.setString('email', jsonEncode(body['email']));
        // Get.off(() => SignInScreen());
        Navigator.of(context).pop();
      } else if (response.statusCode == 400) {
        CommanDialog.showErrorDialog(description: "something went wrong");
        print("something went wrong");
      } else if (response.statusCode == 500) {
        print("something went wrong!");
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        PickedImage = tempImage;
        upload(this.id!, PickedImage!);
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  TextEditingController firstnamecontrol = new TextEditingController();
  TextEditingController lastnamecontrol = new TextEditingController();
  TextEditingController emailcontrol = new TextEditingController();

  Widget buildTextField(String labelText, var placeholder,
      bool isPasswordTextField, TextEditingController controllers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controllers,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.black87,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: labelText,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
          LengthLimitingTextInputFormatter(50)
        ],
        obscureText: isPasswordTextField,
      ),
    );
  }

  Future upload(int id, File imageFile) async {
    String url = 'http://10.0.2.2:8082/api/auth/addprofile/${id}';
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(http.MultipartFile(
        'image',
        File(imageFile.path).readAsBytes().asStream(),
        File(imageFile.path).lengthSync(),
        filename: imageFile.path.split("/").last));
    var res = await request.send();

    if (res.statusCode == 200) {
      print(res);
      print("image uploaded");
    } else {
      print("uploaded faild");
    }
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pick Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
