import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/screens/Navbar.dart';

import '../../screens/Navbar.dart';

class ImageAdPage extends StatefulWidget {
  const ImageAdPage({Key? key}) : super(key: key);

  @override
  State<ImageAdPage> createState() => _ImageAdPageState();
}

class _ImageAdPageState extends State<ImageAdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Navbar(),
      appBar: AppBar(
        title: Text('Image ads'),
      ),
      body: Center(
        child: Text(
          'Image advertisement Page',
          style: TextStyle(color: Colors.grey, fontSize: 30),
        ),
      ),
    );
  }
}
