import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/Pages/Order/OrdersForWallet.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../../screens/Navbar.dart';
import '../../utils/helper.dart';
import '../Home/home_screen.dart';
import '../Order/OrderDetails.dart';

class PaymentSuessfulScreen extends StatefulWidget {
  const PaymentSuessfulScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuessfulScreen> createState() => _PaymentSuessfulScreenState();
}

class _PaymentSuessfulScreenState extends State<PaymentSuessfulScreen> {
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
                children: [],
              ),
              SizedBox(
                height: 100,
              ),
              Image.asset(
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                "assets/images/success.gif",
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Thank You !",
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Amount added successfully in your wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Now you can use your wallet amount for shopping"),
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
                      primary: buttonColour,
                    ),
                    onPressed: () {
                      Get.to(() => OrdersForWallet());
                    },
                    child: Text(
                      "Wallet Transaction History",
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
  }
}
