import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Pages/Home/Search.dart';
import 'package:flutter_login_app/Pages/Order/ItemData.dart';
import 'package:get/get.dart';

class PopularProductList extends StatefulWidget {
  const PopularProductList({Key? key}) : super(key: key);

  @override
  State<PopularProductList> createState() => _PopularProductListState();
}

class _PopularProductListState extends State<PopularProductList> {
  final PopularProductController popularproductController =
      Get.put(PopularProductController());

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
                itemCount: popularproductController.popular.length,
                itemBuilder: (context, index) {
                  var popular = popularproductController.popular[index];
                  // itemCount:
                  // productImage.length;
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
                                image: NetworkImage(
                                    'http://10.0.2.2:8082/api/auth/serveproducts/${popular.imageUrl.toString()}')
                                // image: AssetImage("assets/shoe_1.webp"),
                                ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    popular.name.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    popular.price.toString(),
                                    // "49999rs",
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    popular.price.toString() +
                                        "\n" +
                                        "rs 36% off",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    popular.desc.toString(),
                                    // "Discription",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "only stock" +
                                        popular.inventory.quantity.toString(),
                                    // "only stock 5",
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
                                        // print(index);
                                        // print(index);
                                        // print(productName[index].toString());
                                        // print( productPrice[index].toString());
                                        // print( productPrice[index]);
                                        // print('1');
                                        // print(productUnit[index].toString());
                                        // print(productImage[index].toString());

                                        // dbHelper!.insert(
                                        //   Cart(
                                        //       id: index,
                                        //       productId: index.toString(),
                                        //       productName: productName[index].toString(),
                                        //       initialPrice: productPrice[index],
                                        //       productPrice: productPrice[index],
                                        //       quantity: 1,
                                        //       unitTag: productUnit[index].toString(),
                                        //       image: productImage[index].toString())
                                        // ).then((value){

                                        //   cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                        //   cart.addCounter();

                                        //   final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        // }).onError((error, stackTrace){
                                        //   print("error"+error.toString());
                                        //   final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        // });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                          child: Text(
                                            'Add to cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
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
