import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../../utils/helper.dart';
import '../Home/home_screen.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
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
                height: 30,
              ),
              Image.asset(
                "assets/vector4.webp",
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Thank You!",
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "for your order",
                style: Helper.getTheme(context)
                    .headline4
                    ?.copyWith(color: AppColor.primary),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                    "Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"),
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
                      Get.to(() => const OrderScreen());
                    },
                    child: const Text(
                      "Track My Order",
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
