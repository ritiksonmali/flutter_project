import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../../screens/Navbar.dart';
import '../../utils/helper.dart';
import '../Home/home_screen.dart';

class OrderfailScreen extends StatefulWidget {
  const OrderfailScreen({Key? key}) : super(key: key);

  @override
  State<OrderfailScreen> createState() => _OrderfailScreenState();
}

class _OrderfailScreenState extends State<OrderfailScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey,
        body: Container(
          color: grey,
          height: 800,
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
              // Image.asset(
              //     "assets/fail.webp",
              // ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order Fails!",
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                    "Your order is failed . please try again or try to contact us.  the status of your order is fail"),
              ),
              SizedBox(
                height: 60,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 20,
              //   ),
              //   child: SizedBox(
              //     height: 50,
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //      primary: Colors.black,
              //      ),
              //       onPressed: () {
              //         Get.to(() => OrderPage());
              //       },
              //       child: Text("Track My Order",
              //       ),
              //     ),
              //   ),
              // ),
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
  }
}
