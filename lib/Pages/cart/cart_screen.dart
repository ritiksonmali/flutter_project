import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../Payment/RazorPayPayment.dart';
import 'Checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
//   DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
//     final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
           centerTitle: true,
        title: Text(
              "My Bag",
              style: 
                  TextStyle(
                  color: Colors.black,
                    fontSize: 25,
                  fontWeight: FontWeight.normal,),   
                  ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu),
            onPressed: () {}, //=> _key.currentState!.openDrawer(),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: getBody(),
    );
  }
}

Widget getBody() {
  return ListView(
  
    children: <Widget>[
      Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: grey,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.5,
                            color: black.withOpacity(0.1),
                            blurRadius: 1)
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 25, right: 25, bottom: 25),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 120,
                            height: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/shoe_1.webp"),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Jorden",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "\$ 200",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "x1",
                          style: TextStyle(
                              fontSize: 14,
                              color: black.withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ))
              ],
            ),
          );
        }),
      ),
      SizedBox(
        height: 50,
      ),
      Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Total",
              style: TextStyle(
                  fontSize: 22,
                  color: black.withOpacity(0.5),
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "\$ 508.00",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          color: Colors.black,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
               Get.to(() => CheckoutScreen());
              },
            child: const Text('CHECKOUT'),
          ),
        ),
        // child: Container(
        //   height: 50,
        //  child: Center(
        //    child: Text("CHECKOUT",style: TextStyle(
        //      color: white,
        //      fontSize: 15,
        //      fontWeight: FontWeight.w600
        //    ),),
        //  ),
        // )
      ),
    ],
  );
}
