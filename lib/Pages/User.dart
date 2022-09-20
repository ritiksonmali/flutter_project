import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/reusable_widgets/Data_controller.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('User'),
      ),
      body: Center(
        child: Text(
          'Home Page',
          style: TextStyle(color: Colors.grey, fontSize: 30),
        ),
      ),
    );
  }
}













































 // 
      // body: SingleChildScrollView(
      //   child: Center(
      //     child: Container(

      //       margin: EdgeInsets.all(40),
      //       child: Scaffold(
      //         backgroundColor: Colors.transparent,
      //         body: Center(
      //           child: ListView(
      //             padding:
      //                 EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   TextButton.icon(
      //                     style: TextButton.styleFrom(
      //                         padding: EdgeInsets.all(0),
      //                         minimumSize: Size(1, 1)),
      //                     icon: Icon(Icons.calendar_month_outlined,
      //                         color: Colors.black54),
      //                     label: Text(
      //                       'dd/mm/yyyy hh:mm:ss',
      //                       style: TextStyle(color: Colors.black38),
      //                     ),
      //                     onPressed: (() {}),
      //                   ),
      //                 ],
      //               ),
      //               Container(
      //                 height: 30,
      //                 child: TextField(
      //                   style: TextStyle(),
      //                   decoration: InputDecoration(
      //                       labelText: 'Vehicle Number',
      //                       labelStyle: TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.black45,
      //                           fontWeight: FontWeight.w500),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(8)),
      //                       enabledBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black)),
      //                       focusedBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black))),
      //                   cursorColor: Colors.black54,
      //                   keyboardType: TextInputType.emailAddress,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Container(
      //                 height: 30,
      //                 child: TextField(
      //                   style: TextStyle(),
      //                   decoration: InputDecoration(
      //                       labelText: 'Supervisor Name',
      //                       labelStyle: TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.black45,
      //                           fontWeight: FontWeight.w500),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(8)),
      //                       enabledBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black)),
      //                       focusedBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black))),
      //                   cursorColor: Colors.black54,
      //                   keyboardType: TextInputType.emailAddress,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Container(
      //                 height: 30,
      //                 child: TextField(
      //                   style: TextStyle(),
      //                   decoration: InputDecoration(
      //                       labelText: 'Garage Name',
      //                       labelStyle: TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.black45,
      //                           fontWeight: FontWeight.w500),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(8)),
      //                       enabledBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black)),
      //                       focusedBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black))),
      //                   cursorColor: Colors.black54,
      //                   keyboardType: TextInputType.emailAddress,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Container(
      //                 height: 30,
      //                 child: TextField(
      //                   style: TextStyle(),
      //                   decoration: InputDecoration(
      //                       labelText: 'Nature of break Down',
      //                       labelStyle: TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.black45,
      //                           fontWeight: FontWeight.w500),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(8)),
      //                       enabledBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black)),
      //                       focusedBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black))),
      //                   cursorColor: Colors.black54,
      //                   keyboardType: TextInputType.emailAddress,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 15,
      //               ),
      //               Text(
      //                 'Part Details',
      //                 textAlign: TextAlign.left,
      //                 style: TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 12,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //               SizedBox(
      //                 height: 15,
      //               ),
      //               Container(
      //                 height: 30,
      //                 child: TextField(
      //                   style: TextStyle(),
      //                   decoration: InputDecoration(
      //                       labelText: 'Engine',
      //                       labelStyle: TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.black,
      //                           fontWeight: FontWeight.w700),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(8)),
      //                       enabledBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black)),
      //                       focusedBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black))),
      //                   cursorColor: Colors.black54,
      //                   keyboardType: TextInputType.emailAddress,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               ),
      //               Container(
      //                 alignment: Alignment.topLeft,
      //                 child: TextButton.icon(
      //                   style: TextButton.styleFrom(
      //                       padding: EdgeInsets.all(1),
      //                       minimumSize: Size(1, 1)),
      //                   icon: Icon(Icons.upload_file, color: Colors.black54),
      //                   label: Text(
      //                     'image.png',
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                   onPressed: (() {}),
      //                 ),
      //               ),
      //               Container(
      //                 alignment: Alignment.topLeft,
      //                 child: TextButton.icon(
      //                   style: TextButton.styleFrom(
      //                       padding: EdgeInsets.all(1),
      //                       minimumSize: Size(1, 1)),
      //                   icon: Icon(Icons.upload_file, color: Colors.black54),
      //                   label: Text(
      //                     'image1.png',
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                   onPressed: (() {}),
      //                 ),
      //               ),
      //               Container(
      //                 child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: <Widget>[
      //                       Flexible(
      //                         child: Container(
      //                           height: 30,
      //                           margin: EdgeInsets.only(right: 20),
      //                           child: TextField(
      //                             style: TextStyle(),
      //                             decoration: InputDecoration(
      //                                 labelText: '₹ 5000',
      //                                 labelStyle: TextStyle(
      //                                     fontSize: 12,
      //                                     color: Colors.black,
      //                                     fontWeight: FontWeight.w700),
      //                                 border: OutlineInputBorder(
      //                                     borderRadius:
      //                                         BorderRadius.circular(8)),
      //                                 enabledBorder: OutlineInputBorder(
      //                                     borderSide:
      //                                         BorderSide(color: Colors.black)),
      //                                 focusedBorder: OutlineInputBorder(
      //                                     borderSide:
      //                                         BorderSide(color: Colors.black))),
      //                             cursorColor: Colors.black54,
      //                             keyboardType: TextInputType.emailAddress,
      //                             textInputAction: TextInputAction.done,
      //                           ),
      //                         ),
      //                       ),
      //                       Row(
      //                         children: [
      //                           Radio(
      //                               activeColor:
      //                                   Color.fromARGB(255, 181, 57, 57),
      //                               value: 1,
      //                               groupValue: 1,
      //                               onChanged: (value) {}),
      //                           SizedBox(
      //                             width: 1.0,
      //                           ),
      //                           Text(
      //                             'Estimated',
      //                             style: TextStyle(fontWeight: FontWeight.bold),
      //                           ),
      //                         ],
      //                       )
      //                     ]),
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   TextButton(
      //                     style: TextButton.styleFrom(
      //                         padding: EdgeInsets.only(
      //                             top: 0, bottom: 12, left: 0, right: 0),
      //                         backgroundColor: Colors.transparent),
      //                     child: Text('+ Add new part details'),
      //                     onPressed: () => print('short pressed'),
      //                   ),
      //                 ],
      //               ),
      //               Container(
      //                 height: 30,
      //                 child: TextField(
      //                   style: TextStyle(),
      //                   decoration: InputDecoration(
      //                       labelText: 'Part Name',
      //                       labelStyle: TextStyle(
      //                           fontSize: 12,
      //                           color: Colors.black45,
      //                           fontWeight: FontWeight.w500),
      //                       border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(8)),
      //                       enabledBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black)),
      //                       focusedBorder: OutlineInputBorder(
      //                           borderSide: BorderSide(color: Colors.black))),
      //                   cursorColor: Colors.black54,
      //                   keyboardType: TextInputType.emailAddress,
      //                   textInputAction: TextInputAction.done,
      //                 ),
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   TextButton.icon(
      //                     style: TextButton.styleFrom(
      //                         padding: EdgeInsets.all(0),
      //                         minimumSize: Size(1, 1)),
      //                     icon: Icon(Icons.upload_file, color: Colors.black54),
      //                     label: Text(
      //                       'Upload new photo',
      //                       style: TextStyle(color: Colors.black38),
      //                     ),
      //                     onPressed: (() {}),
      //                   ),
      //                   TextButton.icon(
      //                     style: TextButton.styleFrom(
      //                         padding: EdgeInsets.all(1),
      //                         minimumSize: Size(1, 1)),
      //                     icon: Icon(Icons.upload_file, color: Colors.black54),
      //                     label: Text(
      //                       'Upload old photo',
      //                       style: TextStyle(color: Colors.black38),
      //                     ),
      //                     onPressed: (() {}),
      //                   ),
      //                 ],
      //               ),
      //               Container(
      //                 child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: <Widget>[
      //                       Flexible(
      //                         child: Container(
      //                           height: 30,
      //                           margin: EdgeInsets.only(right: 20),
      //                           child: TextField(
      //                             style: TextStyle(),
      //                             decoration: InputDecoration(
      //                                 labelText: 'Cost',
      //                                 labelStyle: TextStyle(
      //                                     fontSize: 12,
      //                                     color: Colors.black45,
      //                                     fontWeight: FontWeight.w500),
      //                                 border: OutlineInputBorder(
      //                                     borderRadius:
      //                                         BorderRadius.circular(8)),
      //                                 enabledBorder: OutlineInputBorder(
      //                                     borderSide:
      //                                         BorderSide(color: Colors.black)),
      //                                 focusedBorder: OutlineInputBorder(
      //                                     borderSide:
      //                                         BorderSide(color: Colors.black))),
      //                             cursorColor: Colors.black54,
      //                             keyboardType: TextInputType.emailAddress,
      //                             textInputAction: TextInputAction.done,
      //                           ),
      //                         ),
      //                       ),
      //                       Row(
      //                         children: [
      //                           Radio(
      //                               activeColor:
      //                                   Color.fromARGB(255, 181, 57, 57),
      //                               value: 1,
      //                               groupValue: 1,
      //                               onChanged: (value) {}),
      //                           SizedBox(
      //                             width: 1.0,
      //                           ),
      //                           Text(
      //                             'Estimated',
      //                             style: TextStyle(
      //                                 color: Colors.grey,
      //                                 fontWeight: FontWeight.bold),
      //                           ),
      //                         ],
      //                       )
      //                     ]),
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   TextButton(
      //                     style: TextButton.styleFrom(
      //                         padding: EdgeInsets.only(
      //                             top: 0, bottom: 12, left: 0, right: 0),
      //                         backgroundColor: Colors.transparent),
      //                     child: Text('+ Add new part details'),
      //                     onPressed: () => print('short pressed'),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       color: Color(identityHashCode('#fed1da')),
      //       width: 250,
      //       height: 250,
      //     ),
      //   ),
      // ),