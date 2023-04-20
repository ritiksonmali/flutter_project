import 'package:flutter/material.dart';
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
      endDrawer: const Navbar(),
      appBar: AppBar(
        title: const Text('Image ads'),
      ),
      body: const Center(
        child: Text(
          'Image advertisement Page',
          style: TextStyle(color: Colors.grey, fontSize: 30),
        ),
      ),
    );
  }
}
