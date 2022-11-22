import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/CategoryController.dart';
import 'package:flutter_login_app/Controller/OfferController.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Category/CategoryProductList.dart';
import 'package:flutter_login_app/Pages/Offer/OfferList.dart';
import 'package:flutter_login_app/Pages/Product/PopularProductList.dart';
import 'package:flutter_login_app/screens/Navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantUtil/colors.dart';
import '../Filter/Filter.dart';
import '../cart/cart_screen.dart';
import '../Search/Search.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  int? id;
  String add = "add";
  String remove = "remove";
  int counter = 1;

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      this.id = id;
      apiCall();
    });
  }

  bool flag = true;

  final CategoryController categoryController = Get.put(CategoryController());

  final ProductController productController = Get.put(ProductController());
  final OfferController offerController = Get.put(OfferController());
  final PopularProductController popularproductController =
      Get.put(PopularProductController());

  @override
  void initState() {
    super.initState();
    test();
    productController.getAllProducts();
    productController.getCount();
  }

  apiCall() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Navbar(),
      appBar: AppBar(
        title: Image.asset(
          'assets/homelogo.png',
          height: 70,
          width: 120,
        ),
        iconTheme: IconThemeData(color: black),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Get.to(() => SearchPage());
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.shopping_bag_outlined),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => CartScreen()),
          //     );
          //   },
          // ),
          Center(
            child: Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              child: IconButton(
                icon: Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Get.to(() => CartScreen());
                },
              ),
              badgeContent:
                  GetBuilder<ProductController>(builder: (controller) {
                return Text(
                  productController.count.toString(),
                  style: TextStyle(color: white),
                );
              }),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu),
            onPressed: () {
              Get.to(() => Navbar());
            }, //=> _key.currentState!.openDrawer(),
          ),
        ],
        backgroundColor: white,
      ),
      // body:  RefreshIndicator(
      //         onRefresh:productController.getAllProducts,
      body: SingleChildScrollView(
        child: Column(children: [
          SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: GetBuilder<CategoryController>(
                  builder: (controller) {
                    return ListView.builder(
                        // itemCount: _choices.length,
                        itemCount: categoryController.category.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var categories = categoryController.category[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              width: 80,
                              height: 80,
                              child: GestureDetector(
                                onTap: () async {
                                  productController.getFilterProducts(
                                      '',
                                      '',
                                      10000,
                                      0,
                                      '',
                                      categories.id.toString(),
                                      '',
                                      '');
                                  await Future.delayed(Duration(seconds: 2));

                                  Get.to(() => PopularProductList(),
                                      arguments: {"categoryId": categories.id});
                                },
                                child: Card(
                                  color: white,
                                  shadowColor: black,
                                  child: Container(
                                    //  child Icon
                                    child: Center(
                                        child: Text(
                                            // _choices[index].name
                                            categories.title,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium)),
                                  ),
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
          SizedBox(
            width: double.infinity,
            height: 150,
            child: GetBuilder<OfferController>(builder: (controller) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: offerController.offer.length,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    var offer = offerController.offer[index];
                    return Container(
                      width: 400,
                      child: Card(
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              productController.getFilterProducts('', '', 10000,
                                  0, '', '', offer.id.toString(), '');
                              await Future.delayed(Duration(seconds: 2));
                              Get.to(() => PopularProductList(),
                                  arguments: {"offerId": offer.id});
                            },
                            child: Image.network(
                              'http://10.0.2.2:8082/api/auth/serveproducts/${offer.imageUrl.toString()}',
                              fit: BoxFit.cover,
                            ),
                            // Image.asset('assets/sale.webp',
                            //     fit: BoxFit.cover)
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        clipBehavior: Clip.antiAlias,
                      ),
                    );
                  });
            }),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Popular Product",
                        style: Theme.of(context).textTheme.titleLarge
                        //  .copyWith(fontWeight: FontWeight.bold),
                        ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: TextButton(
                    // <-- OutlinedButton
                    onPressed: () async {
                      productController.getFilterProducts(
                          '', '', 10000, 0, '', '', '', '');
                      await Future.delayed(Duration(seconds: 2));
                      Get.to(() => PopularProductList());
                    },
                    child: Text('see more',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: GetBuilder<PopularProductController>(builder: (controller) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: popularproductController.popular.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    var popular = popularproductController.popular[index];
                    return GestureDetector(
                      onTap: () => null,
                      child: Column(
                        children: [
                          Hero(
                            tag: "anim$index",
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 8, left: 8, top: 0, bottom: 0),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Color.fromARGB(255, 192, 193, 195),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'http://10.0.2.2:8082/api/auth/serveproducts/${popular.imageUrl.toString()}'),
                                    // AssetImage(
                                    //     "assets/shoe_1.webp")
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            popular.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    );
                  });
            }),
          ),
          SizedBox(
            height: 2,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("All Products",
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(
                  width: 150,
                ),
                TextButton.icon(
                  // <-- OutlinedButton
                  onPressed: () {
                    Get.to(() => FilterPage());
                  },
                  label: Text('Filter',
                      style: Theme.of(context).textTheme.titleMedium),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.0,
                    color: black,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GetBuilder<ProductController>(builder: (controller) {
                return ListView.builder(
                    itemCount: productController.productResponseList.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            color: black.withOpacity(0.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 30),
                                          width: 280,
                                          height: 180,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    'http://10.0.2.2:8082/api/auth/serveproducts/${productController.productResponseList[index]['imageUrl'].toString()}',
                                                  ),
                                                  //  AssetImage(
                                                  //     "assets/images/" +
                                                  //         products[index]['img']),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        productController
                                            .productResponseList[index]['name']
                                            .toString(),
                                        // products[index]['name'],
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(20),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "Price : \₹ " +
                                                        productController
                                                            .productResponseList[
                                                                index]['price']
                                                            .toString(),

                                                    // "\$ " + products[index]['price'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                                //  productController.productResponseList[index]
                                                //['added'] !=false &&
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: black,
                                                  ),
                                                  child: productController
                                                                      .productResponseList[
                                                                  index][
                                                              'cartQauntity'] !=
                                                          0
                                                      ? Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.remove),
                                                              onPressed: () {
                                                                setState(() {
                                                                  productController.increasequantity(
                                                                      this.id!,
                                                                      productController
                                                                              .productResponseList[index]
                                                                          [
                                                                          'id'],
                                                                      this.remove);
                                                                  if (productController
                                                                              .productResponseList[index]
                                                                          [
                                                                          'cartQauntity'] >
                                                                      1) {
                                                                    productController
                                                                            .productResponseList[index]
                                                                        [
                                                                        'cartQauntity'] = productController.productResponseList[index]
                                                                            [
                                                                            'cartQauntity'] -
                                                                        1;
                                                                  } else {
                                                                    productController
                                                                        .onReady();
                                                                    productController
                                                                            .productResponseList[index]
                                                                        [
                                                                        'cartQauntity'] = 0;
                                                                    productController
                                                                            .productResponseList[index]
                                                                        [
                                                                        'added'] = false;
                                                                  }
                                                                });
                                                              },
                                                              color: white,
                                                            ),
                                                            Text(
                                                              productController
                                                                  .productResponseList[
                                                                      index][
                                                                      'cartQauntity']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.add),
                                                              color: white,
                                                              onPressed: () {
                                                                if (productController.productResponseList[index]
                                                                            [
                                                                            'cartQauntity'] <
                                                                        5 &&
                                                                    productController.productResponseList[index]['inventory']
                                                                            [
                                                                            'quantity'] >
                                                                        productController.productResponseList[index]
                                                                            [
                                                                            'cartQauntity']) {
                                                                  productController.increasequantity(
                                                                      this.id!,
                                                                      productController
                                                                              .productResponseList[index]
                                                                          [
                                                                          'id'],
                                                                      this.add);
                                                                  setState(() {
                                                                    productController
                                                                            .productResponseList[index]
                                                                        [
                                                                        'cartQauntity'] = productController.productResponseList[index]
                                                                            [
                                                                            'cartQauntity'] +
                                                                        1;
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            productController
                                                                .increasequantity(
                                                                    this.id!,
                                                                    productController
                                                                            .productResponseList[
                                                                        index]['id'],
                                                                    this.add);
                                                            setState(() {
                                                              productController
                                                                  .onReady();
                                                              productController
                                                                          .productResponseList[
                                                                      index][
                                                                  'cartQauntity'] = 1;
                                                              productController
                                                                          .productResponseList[
                                                                      index][
                                                                  'added'] = true;
                                                            });
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                black,
                                                          ),
                                                          child: Text(
                                                              "Add to Cart"),
                                                        ),
                                                ),
                                              ])),
                                    ],
                                  ),
                                ),
                                // Positioned(
                                //     right: 10,
                                //     child: IconButton(
                                //         icon: SvgPicture.asset(
                                //             "assets/images/heart_icon.svg"),
                                //         onPressed: null)),
                              ],
                            )),
                          ),
                        ),
                      );
                    });
              })
            ],
          )
        ]),
      ),
      //  ),
    );
  }

  // String? Category;

  Future getCategoryApi() async {
    try {
      String url = 'http://10.0.2.2:8082/api/auth/category';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      var body = jsonDecode(response.body);
      return body;
    } catch (e) {
      print(e.toString());
    }
  }

  List popularproducts = [];

  Future getPopularProductApi(bool flag) async {
    String url = 'http://10.0.2.2:8082/api/auth/popularproducts/${flag}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);

    // if (response.statusCode == 200) {
    //   return AllProducts.fromJson(body);
    // } else {
    //   return AllProducts.fromJson(body);
    // }
    return body;
  }

  List allproducts = [];

  Future getAllProductApi() async {
    String url = 'http://10.0.2.2:8082/api/auth/products/1';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    var body = jsonDecode(response.body);

    // if (response.statusCode == 200) {
    //   return AllProducts.fromJson(body);
    // } else {
    //   return AllProducts.fromJson(body);
    // }
    return body;
  }

  List offers = [];
  Future getAllOffersApi() async {
    String url = 'http://10.0.2.2:8082/api/auth/offers';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    return body;
  }
}
