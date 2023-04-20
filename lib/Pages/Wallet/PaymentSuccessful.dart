import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/OrdersForWallet.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../Home/home_screen.dart';

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
                children: const [],
              ),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                "assets/images/success.gif",
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Thank You !",
                  style: TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Amount added successfully in your wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Now you can use your wallet amount for shopping"),
              ),
              const SizedBox(
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
                      Get.to(() => const OrdersForWallet());
                    },
                    child: const Text(
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
                    Get.to(() => const HomeScreen());
                  },
                  child: const Text(
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
