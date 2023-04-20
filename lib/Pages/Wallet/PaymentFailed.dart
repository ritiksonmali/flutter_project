import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../../utils/helper.dart';
import '../Home/home_screen.dart';

class PaymentFailedScreen extends StatefulWidget {
  const PaymentFailedScreen({Key? key}) : super(key: key);

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen> {
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Order Fails!",
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
                    "Your order is failed . please try again or try to contact us. the status of your order is fail"),
              ),
              const SizedBox(
                height: 60,
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
