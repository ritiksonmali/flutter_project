import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Pages/Address/AddressDetails.dart';
import 'package:flutter_login_app/Pages/Admin/AdminDashboard.dart';
import 'package:flutter_login_app/Pages/Feedback.dart';
import 'package:flutter_login_app/Pages/Order/DeliveredOrders.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreenDeliveryManager.dart';
import 'package:flutter_login_app/Pages/Order/UpcomingOrders.dart';
import 'package:flutter_login_app/Pages/Setting/Setting.dart';
import 'package:flutter_login_app/Pages/Subscribe/SubscriptionOrders.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/Profile/EditProfilePage.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../ConstantUtil/colors.dart';
import '../Controller/ProductController.dart';
import '../Pages/Home/home_screen.dart';
import '../Pages/Order/OrderScreen.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final ProductController productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: grey,
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
                leading: const Icon(Icons.home),
                title:
                    Text('Home', style: Theme.of(context).textTheme.headline6),
                onTap: () {
                  Timer(const Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                    );
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title:
                  Text('Profile', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => EditProfilePage());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            role == "DELIVERY_MANAGER"
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.delivery_dining_sharp),
                      title: Text('Delivery',
                          style: Theme.of(context).textTheme.headline6),
                      onTap: () {
                        Get.to(() => const OrderScreenDeliveryManager());
                      },
                    ),
                  )
                : const SizedBox(),
            role == "ROLE_ADMIN"
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: Text('Admin Dashboard',
                          style: Theme.of(context).textTheme.headline6),
                      onTap: () {
                        Get.to(() => const AdminDashboard());
                      },
                    ),
                  )
                : const SizedBox(),
            role == "ROLE_ADMIN"
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.delivery_dining_sharp),
                      title: Text('Delivery Details',
                          style: Theme.of(context).textTheme.headline6),
                      onTap: () {
                        Get.to(() => const DeliveredOrders());
                      },
                    ),
                  )
                : const SizedBox(),
            ListTile(
              leading: const Icon(Icons.history_edu),
              title:
                  Text('Orders', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => const OrderScreen());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.locationDot),
              title:
                  Text('Address', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => const AddressDetails());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title:
                  Text('Setting', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => SettingsPage());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.wallet),
              title:
                  Text('Wallet', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => const WalletScreen());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.subscriptions),
              title: Text('Subscription',
                  style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => const SubscriptionOrderDetails());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: Text('Feedback',
                  style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => const FeedbackScreen());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('Sign Out',
                  style: Theme.of(context).textTheme.headline6),
              onTap: () async {
                CommanDialog.showLoading();
                pushNotificationController.setNotifiedUserStatus();
                await Future.delayed(const Duration(seconds: 4));
                LoginController.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Welcome()),
                    (Route<dynamic> route) => false);
                CommanDialog.hideLoading();
                // Get.off(() => Welcome());
              },
            ),
          ]),
        )
      ],
    );
  }
}
