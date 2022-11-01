// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ItemData {
//   final String itemName;
//   final String itemPrice;
//   final String image;
//   int counter = 0;
//   bool isAdded = false;
//   ItemData({this.itemName, this.itemPrice, this.image});
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Future<List<ItemData>> _future;

//   Future<List<ItemData>> _getProducts() async {
//     var data = await http
//         .get("https://orangecitycafe.in/app_configs/products_display.php");

//     var jsonData = json.decode(data.body);
//     List<ItemData> details = [];
//     for (var p in jsonData) {
//       ItemData detail = ItemData(
//           itemName: p["product_name"],
//           itemPrice: p["product_price"],
//           image: p["product_image"]);
//       details.add(detail);
//     }
//     return details;
//   }

//   @override
//   void initState() {
//     _future = _getProducts();
//     super.initState();
//   }

//   Widget _myCart() {
//     return FutureBuilder(
//       future: _future,
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             itemCount: snapshot.data.length,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                 title: Text(snapshot.data[index].itemName),
//                 leading: Image.network("https://www.orangecitycafe.in/" +
//                     snapshot.data[index].image),
//                 trailing: snapshot.data[index].isAdded
//                     ? Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           IconButton(
//                             icon: Icon(Icons.remove),
//                             onPressed: () {
//                               setState(() {
//                                 if (snapshot.data[index].counter > 0) {
//                                   snapshot.data[index].counter--;
//                                 }
//                               });
//                             },
//                             color: Colors.green,
//                           ),
//                           Text(snapshot.data[index].counter.toString()),
//                           IconButton(
//                             icon: Icon(Icons.add),
//                             color: Colors.green,
//                             onPressed: () {
//                               setState(() {
//                                 snapshot.data[index].counter++;
//                               });
//                             },
//                           ),
//                         ],
//                       )
//                     : RaisedButton(
//                         onPressed: () {
//                           setState(() {
//                             snapshot.data[index].isAdded = true;
//                           });
//                         },
//                         child: Text("Add"),
//                       ),
//               );
//             },
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: _myCart());
//   }
// }