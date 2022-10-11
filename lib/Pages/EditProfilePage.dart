import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';
 
class EditProfilePage extends StatefulWidget {

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
           onPressed: () { Get.to(() => HomeScreen());},
       ),

      ),
      body: Container(
        padding: EdgeInsets.only(left: 16,top: 25,right: 16),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
        child: ListView(
          children: [
            Text(
              "Edit Profile", 
              style: TextStyle(fontSize: 25 , fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child:Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width : 4,
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
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",)
                    )
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
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  
              ],
            ),),

             SizedBox(
                height: 35,
              ),
              buildTextField("Full Name", "Piyush Pagar", false),
              buildTextField("E-mail", "Piyush@gmail.com", false),
              buildTextField("Password", "Piyush@1", true),
              buildTextField("Location", "saitara, Nashik", false),
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
                    
                    onPressed: () {},
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
}

 Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ,
        decoration: InputDecoration(
      
            // suffixIcon: IconButton(
            //         onPressed: () {
            //           setState(() {
            //             showPassword = !showPassword;
            //           });
            //         },
            //         icon: Icon(
            //           Icons.remove_red_eye,
            //           color: Colors.grey,
            //         ),
            //         onPressed: () {
                      
            //         },
            //       ),
            
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
}

