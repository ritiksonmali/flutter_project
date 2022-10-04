import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/reusable_widgets/Data_controller.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text(
          'Profile',
          style: TextStyle(color: Colors.grey, fontSize: 30),
        ),
      ),
    );
  }
}
