import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Notification/LocalNotificationService.dart';
import 'package:flutter_login_app/Pages/Home/home.dart';
import 'package:flutter_login_app/api/SignInAuto.dart';
import 'package:flutter_login_app/screens/main_app.dart';
import 'package:flutter_login_app/screens/SignIn.dart';
import 'package:flutter_login_app/screens/welcome.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInApi(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Mainapp(),
        // home: const SignInScreen(),
      ),
    );
  }
}
