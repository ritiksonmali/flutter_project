import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Profile/EditProfilePage.dart';
import 'package:flutter_login_app/Pages/history.dart';
import 'package:flutter_login_app/Pages/Home/home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final screen = [HomePage(), HistoryPage(), EditProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
    );
  }
}
