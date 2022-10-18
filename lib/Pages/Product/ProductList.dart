import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Pages/Product/MyProductController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../screens/navbar.dart';
import '../Home/Search.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({Key? key}) : super(key: key);
  final myProductController = Get.put(MyProductController());

  @override
  State<ProductListPage> createState() => _ProductListState();
}

class _ProductListState extends State<ProductListPage> {
  int index = 8;
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
    'Mixed Fruit Basket'
  ];
  List<String> productUnit = [
    '25%',
    '36%',
    '6%',
    'Dozen',
    'KG',
    'KG',
    'KG',
    'KG'
  ];
  List<int> productPrice = [
    10000,
    20000,
    20500,
    25000,
    30000,
    35000,
    35000,
    36999
  ];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Product List', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              child: IconButton(
                icon: Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Get.to(() => SearchPage());
                },
              ),
              badgeContent: Text(
                "6",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  itemCount:
                  productImage.length;
                  return Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                              height: 100,
                              width: 100,
                              // image:NetworkImage(productImage[index].toString())
                              image: AssetImage("assets/shoe_1.webp"),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "49999rs",
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    productPrice[index].toString() +
                                        "rs 36% off",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Discription",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "only stock 5",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  // CounterButton(
                                  //           loading: false,
                                  //            onChange: (int val) {
                                  //                  setState(() {
                                  //                    = val;
                                  //               });
                                  //             },
                                  //           count: _counterValue,
                                  //              countColor: Colors.purple,
                                  //              buttonColor: Colors.purpleAccent,
                                  //              progressColor: Colors.purpleAccent,
                                  //    ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                        onTap: () {
                                          print(index);
                                          print(productName[index].toString());
                                          print(productPrice[index].toString());
                                          print(productPrice[index]);
                                          print('1');
                                          print(productUnit[index].toString());
                                          print(productImage[index].toString());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: Colors.black,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.zero,
                                                child: IconButton(
                                                  icon: Icon(Icons.remove,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Get.to(() => SearchPage());
                                                  },
                                                ),
                                              ),
                                              //  Obx(()=>Text("${myProductController.},
                                              Text(
                                                "1",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.zero,
                                                child: IconButton(
                                                  icon: Icon(Icons.add,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Get.to(() => SearchPage());
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }))
      ]),
    );
  }
}
