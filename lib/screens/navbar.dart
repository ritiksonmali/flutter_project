import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Pages/Address/AddressDetails.dart';
import 'package:flutter_login_app/Pages/Feedback.dart';
import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreen.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreenDeliveryManager.dart';
import 'package:flutter_login_app/Pages/Setting/Setting.dart';
import 'package:flutter_login_app/Pages/Subscribe/SubscriptionOrders.dart';
import 'package:flutter_login_app/Pages/Wallet/WalletScreen.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/LoginController.dart';
import 'package:flutter_login_app/Pages/Profile/EditProfilePage.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantUtil/colors.dart';
import '../Controller/ProductController.dart';
import '../Pages/Home/home.dart';
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
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(
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
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
                leading: Icon(Icons.home),
                title:
                    Text('Home', style: Theme.of(context).textTheme.headline6),
                onTap: () {
                  Timer(Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()), // this mymainpage is your page to refresh
                      (Route<dynamic> route) => false,
                    );
                  });
                }),
            SizedBox(
              height:10,
            ),
            ListTile(
              leading: Icon(Icons.face),
              title:
                  Text('Profile', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => EditProfilePage());
              },
            ),
            SizedBox(
              height: 10,
            ),
            role == "DELIVERY_MANAGER"
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: ListTile(
                      leading: Icon(Icons.delivery_dining_sharp),
                      title: Text('Delivery',
                          style: Theme.of(context).textTheme.headline6),
                      onTap: () {
                        Get.to(() => OrderScreenDeliveryManager());
                      },
                    ),
                  )
                : SizedBox(),
            // SizedBox(
            //   height: 35,
            // ),
            ListTile(
              leading: Icon(Icons.history_edu),
              title:
                  Text('Orders', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => OrderScreen());
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.locationDot),
              title:
                  Text('Address', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => AddressDetails());
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title:
                  Text('Setting', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => SettingsPage());
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.wallet),
              title:
                  Text('Wallet', style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => WalletScreen());
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.subscriptions),
              title: Text('Subscription',
                  style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => SubscriptionOrderDetails());
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback',
                  style: Theme.of(context).textTheme.headline6),
              onTap: () {
                Get.to(() => FeedbackScreen());
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out',
                  style: Theme.of(context).textTheme.headline6),
              onTap: () async {
                CommanDialog.showLoading();
                pushNotificationController.setNotifiedUserStatus();
                await Future.delayed(Duration(seconds: 4));
                LoginController.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Welcome()),
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
