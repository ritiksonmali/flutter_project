import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Product/PopularProductList.dart';
import 'package:get/get.dart';
import '../../ConstantUtil/colors.dart';
import '../../Controller/ProductController.dart';
import 'SearchProductList.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _nameTextController = TextEditingController();
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0.0,
          iconTheme: IconThemeData(color: black),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Search product",
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameTextController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 241, 239, 239),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none)),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: FloatingActionButton.extended(
                    label: Text('Search'), // <-- Text
                    backgroundColor: black,
                    onPressed: () {
                      productController.productFilterResponseList.clear();
                      productController.getFilterProducts(
                          '',
                          '',
                          10000,
                          0,
                          '',
                          '',
                          '',
                          _nameTextController.text.toLowerCase().toString());
                      Timer(Duration(seconds: 3), () {
                        Get.to(() => PopularProductList());
                      });
                      // productController.getSearchProducts(
                      //     _nameTextController.text.toLowerCase().toString());
                      // Timer(Duration(seconds: 3), () {
                      //   Get.to(() => SearchProductList());
                      // });
                    },
                  ),
                ),
              ]),
        ));
  }
}
