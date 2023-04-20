import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: grey,
      body: Center(
        child: Container(
          child: Center(
            child: Image.asset(
              'assets/logo111.png',
              fit: BoxFit.fitWidth,
              width: width * 0.3,
              height: height * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
