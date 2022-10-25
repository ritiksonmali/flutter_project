import 'dart:convert';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/Controller/CategoryController.dart';
import 'package:flutter_login_app/Pages/Category/CategoryProductList.dart';
import 'package:flutter_login_app/Pages/Offer/OfferList.dart';
import 'package:flutter_login_app/Pages/Order/ItemData.dart';
import 'package:flutter_login_app/model/Category.dart';
import 'package:flutter_login_app/model/CategoryProduct.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:flutter_login_app/screens/Navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantUtil/ProductData.dart';
import '../../ConstantUtil/colors.dart';
import '../Product/ProductList.dart';
import '../cart/cart_screen.dart';
import 'HomeItem.dart';
import 'ImageAd.dart';
import 'ProductDetailPage.dart';
import 'Search.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  bool flag = true;

  final CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCategoryApi();
    apiCall();
  }

  apiCall() async {
    // var categoryFromApi = await getCategoryApi();
    var allproductsfromapi = await getAllProductApi();
    var popularproductFromApi = await getPopularProductApi(this.flag);
    var offersfromapi = await getAllOffersApi();
    setState(() {
      // category = categoryFromApi;
      allproducts = allproductsfromapi;
      popularproducts = popularproductFromApi;
      offers = offersfromapi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Navbar(),
        appBar: AppBar(
          title: Text(
            'Shopping cart',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
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
            Center(
              child: Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                child: IconButton(
                  icon: Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    Get.to(() => CartScreen());
                  },
                ),
                badgeContent: Text(
                  "6",
                  style: TextStyle(color: Colors.white),
                ),
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
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                              var categories =
                                  categoryController.category[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => CategoryProductList(),
                                          arguments: {
                                            "categoryId": categories.id
                                          });
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shadowColor: Colors.black,
                                      child: Container(
                                        //  child Icon
                                        child: Center(
                                            child: Text(
                                          // _choices[index].name
                                          categories.title,
                                          style: TextStyle(color: Colors.black),
                                        )),
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
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: offers.length,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var offer = offers[index];
                          return Container(
                            width: 400,
                            child: Card(
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => OfferList());
                                  },
                                  child: Image.network(
                                    'http://10.0.2.2:8082/api/auth/serveproducts/${offer['imageUrl'].toString()}',
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
                            child: Text("Popular Product",
                                style: Theme.of(context).textTheme.subtitle1
                                //  .copyWith(fontWeight: FontWeight.bold),
                                )),
                        Text("Show more")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: popularproducts.length,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var popular = popularproducts[index];
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        color:
                                            Color.fromARGB(255, 192, 193, 195),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'http://10.0.2.2:8082/api/auth/serveproducts/${popular['imageUrl'].toString()}'),
                                          // AssetImage(
                                          //     "assets/shoe_1.webp")
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  popular['name'],
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 30, right: 30, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "All Products",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Sort by",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Icon(Icons.keyboard_arrow_down),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                      children: List.generate(allproducts.length, (index) {
                    var allproduct = allproducts[index];
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => ProductDetailPage(
                            //             // id: products[index]['id'].toString(),
                            //             // name: products[index]['name'],
                            //             // img: products[index]['img'],
                            //             // price: products[index]['price'],
                            //             // mulImg: products[index]['mul_img'],
                            //             // sizes: products[index]['sizes'],
                            //             )));
                          },
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
                                        width: 280,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  'http://10.0.2.2:8082/api/auth/serveproducts/${allproduct['imageUrl'].toString()}',
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
                                      allproduct['name'],
                                      // products[index]['name'],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "\$ " + allproduct['price'].toString(),
                                      // "\$ " + products[index]['price'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 40,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black,
                                        ),
                                        child: Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            itemData[index].ShouldVisible
                                                ? Center(
                                                    child: Container(
                                                    height: 30,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        border: Border.all(
                                                            color: Colors
                                                                .white70)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if (itemData[
                                                                            index]
                                                                        .Counter <
                                                                    2) {
                                                                  itemData[
                                                                          index]
                                                                      .ShouldVisible = !itemData[
                                                                          index]
                                                                      .ShouldVisible;
                                                                } else {
                                                                  itemData[
                                                                          index]
                                                                      .Counter--;
                                                                }
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.green,
                                                              size: 18,
                                                            )),
                                                        Text(
                                                          '${itemData[index].Counter}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70),
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                itemData[index]
                                                                    .Counter++;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.green,
                                                              size: 18,
                                                            )),
                                                      ],
                                                    ),
                                                  ))
                                                : Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      height: 30,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white70)),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                itemData[index]
                                                                        .ShouldVisible =
                                                                    !itemData[
                                                                            index]
                                                                        .ShouldVisible;
                                                              });
                                                            },
                                                            child: Text(
                                                              'ADD',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white70),
                                                            ),
                                                          ),
                                                          // InkWell(
                                                          //     onTap: () {
                                                          //       setState(() {
                                                          //         itemData[
                                                          //                 index]
                                                          //             .ShouldVisible = !itemData[
                                                          //                 index]
                                                          //             .ShouldVisible;
                                                          //       });
                                                          //     },
                                                          //     child: Center(
                                                          //         child: Icon(
                                                          //       Icons.add,
                                                          //       color: Colors
                                                          //           .green,
                                                          //       size: 18,
                                                          //     )))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            // Padding(
                                            //   padding: EdgeInsets.zero,
                                            //   child: IconButton(
                                            //     icon: Icon(Icons.remove,
                                            //         color: Colors.white),
                                            //     onPressed: () {

                                            //       Get.to(() => SearchPage());
                                            //     },
                                            //   ),
                                            // ),
                                            //  Obx(()=>Text("${myProductController.},
                                            // Text(
                                            //   "1",
                                            //   style: TextStyle(
                                            //       color: Colors.white),
                                            // ),
                                            // Padding(
                                            //   padding: EdgeInsets.zero,
                                            //   child: IconButton(
                                            //     icon: Icon(Icons.add,
                                            //         color: Colors.white),
                                            //     onPressed: () {
                                            //       Get.to(() => SearchPage());
                                            //     },
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 10,
                                  child: IconButton(
                                      icon: SvgPicture.asset(
                                          "assets/images/heart_icon.svg"),
                                      onPressed: null)),
                            ],
                          )),
                        ),
                      ),
                    );
                  }))
                ]),
              ),
            ],
          ),
        ));
  }

  // String? Category;
  List<HomeItem> _choices = [
    HomeItem("Men", Icon(Icons.person)),
    HomeItem("Women", Icon(Icons.emoji_people_sharp)),
    HomeItem("Fashion", Icon(Icons.shopping_bag)),
    HomeItem("Baby", Icon(Icons.child_care)),
    HomeItem("Kids", Icon(Icons.face_sharp))
  ];

  List category = [
    // {
    //   "createdDate": "2022-10-14",
    //   "lastModifiedDate": "2022-10-14",
    //   "id": 1,
    //   "title": "Men",
    //   "metatitle": "mens products",
    //   "content": "All mens related products is here"
    // },
    // {
    //   "createdDate": "2022-10-14",
    //   "lastModifiedDate": "2022-10-14",
    //   "id": 2,
    //   "title": "Women",
    //   "metatitle": "women products",
    //   "content": "All women related products is here"
    // }
  ];

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
    String url = 'http://10.0.2.2:8082/api/auth/products';
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
