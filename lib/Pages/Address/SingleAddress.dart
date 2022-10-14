// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class SingleDeliveryItem extends StatelessWidget {
//   final String? title;
//   final String? address;
//   final String? number;
//   final String? addressType;
//   SingleDeliveryItem({this.title, this.addressType, this.address, this.number});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Card(
//           color: Colors.red,
//         ),
//         ListTile(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Text(title),
//               Text("Rutik Sonmali"),
//               // Container(
//               //   width: 60,
//               //   padding: EdgeInsets.all(1),
//               //   height: 20,
//               //   decoration: BoxDecoration(
//               //       color: Colors.black,
//               //       borderRadius: BorderRadius.circular(10)),
//               //   child: Center(
//               //     child: Text(
//               //       // addressType,
//               //       "Home",
//               //       style: TextStyle(
//               //         fontSize: 13,
//               //         color: Colors.white,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//           leading: CircleAvatar(
//             radius: 8,
//             // backgroundColor:primaryColor,
//             backgroundColor: Colors.black,
//           ),
//           subtitle: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Text(address),
//               Text("kalpataru Colony Karve nagar pune 411052"),
//               SizedBox(
//                 height: 5,
//               ),
//               // Text(number),
//               Text("mobile number - 8530838580"),
//             ],
//           ),
//         ),
//         Divider(
//           height: 35,
//         ),
//       ],
//     );
//   }
// }
