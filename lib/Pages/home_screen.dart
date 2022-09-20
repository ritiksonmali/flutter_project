import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/User.dart';
import 'package:flutter_login_app/Pages/history.dart';
import 'package:flutter_login_app/Pages/home.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:flutter_login_app/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final screen = [HomePage(), HistoryPage(), UserPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
              backgroundColor: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     child: Text("Logout"),
      //     onPressed: () {
      //       FirebaseAuth.instance.signOut().then((value) {
      //         print("Signed Out");
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => SignInScreen()));
      //       });
      //     },
      //   ),
      // ),
    );
  }
}
