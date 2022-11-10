import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../../screens/Navbar.dart';
import '../../utils/helper.dart';
import '../Home/home_screen.dart';
import '../Order/OrderDetails.dart';
import '../Order/Orders.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  Widget build(BuildContext context) {
    return Scaffold(

      body:    Container(
                                height:800,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // IconButton(
                                        //   onPressed: () {
                                        //     Navigator.of(context).pop();
                                        //   },
                                        //   icon: Icon(Icons.clear),
                                        // ),
                                      ],
                                    ),
                                     SizedBox(
                                      height: 30,
                                    ),
                                    Image.asset(                                    
                                        "assets/vector4.webp",
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Thank You!",
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "for your order",
                                      style: Helper.getTheme(context)
                                          .headline4
                                          ?.copyWith(color: AppColor.primary),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                          "Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                         primary: Colors.black, 
                                         ),
                                          onPressed: () {
                                            Get.to(() => OrderDetailsScreen());
                                          },
                                          child: Text("Track My Order",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                           Get.to(() => HomeScreen());
                                        },
                                        child: Text(
                                          "Back To Home",
                                          style: TextStyle(
                                            color: AppColor.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                            
}}
  






