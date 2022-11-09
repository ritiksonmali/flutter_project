import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reusable_widgets/reusable_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        child: Column(
              children: <Widget>[
                logoWidget('assets/logo.jpg'),
                SizedBox(
                  height: 150,
                ),
        ]),
      )
     );
  }

}