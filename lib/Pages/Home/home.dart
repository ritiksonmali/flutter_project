// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_login_app/Controller/CategoryController.dart';
import 'package:flutter_login_app/Controller/AddImages.dart';
import 'package:flutter_login_app/Controller/OfferController.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Category/CategoryProductList.dart';
import 'package:flutter_login_app/Pages/Offer/OfferList.dart';
import 'package:flutter_login_app/Pages/Product/PopularProductList.dart';
import 'package:flutter_login_app/Pages/Product/ProductDetails.dart';
import 'package:flutter_login_app/Pages/Subscribe/SubscribeProductDetails.dart';
import 'package:flutter_login_app/screens/Navbar.dart';
import 'package:flutter_login_app/screens/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantUtil/colors.dart';
import '../../ConstantUtil/globals.dart';
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

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  DateTime backbuttonpressedTime = DateTime.now();
  int? id;
  String add = "add";
  String remove = "remove";
  int counter = 1;
  int _page = 0;

  final int _limit = 5;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  late ScrollController _controller = new ScrollController();

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      print('loading called');
      _page += 1;
      try {
        var store = await SharedPreferences.getInstance();
        var iddata = store.getString('id');
        int userId = jsonDecode(iddata!);
        String url =
            '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=${_page}&pagesize=${_limit}&status=active&userId=${userId}';
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );
        var body = jsonDecode(response.body);
        List records = body['records'];
        if (records.isNotEmpty) {
          setState(() {
            productController.productResponseList.addAll(body['records']);
          });
        } else {
          setState(() {
            _hasNextPage = false;
            Fluttertoast.showToast(
                msg: "You have Fetched all The records",
                backgroundColor: Colors.black87);
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    productController.getAllProducts();

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

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
    getConnectivity();
    test();
    _firstLoad();
    _controller.addListener(_loadMore);
    productController.getCount();
  }

  apiCall() async {
    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(backbuttonpressedTime);
        final isExitWarning = difference >= const Duration(seconds: 1);
        backbuttonpressedTime = DateTime.now();
        if (isExitWarning) {
          const message = "Double Tap to exit app";
          Fluttertoast.showToast(
              msg: message,
              fontSize: 18,
              backgroundColor: Colors.black,
              textColor: white);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: grey,
        endDrawer: const Navbar(),
        appBar: AppBar(
          title: Image.asset(
            'assets/homelogo.png',
            height: 70,
            width: 120,
          ),
          iconTheme: const IconThemeData(color: white),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                Get.to(() => const SearchPage());
              },
            ),
            Center(
              child: Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                badgeContent:
                    GetBuilder<ProductController>(builder: (controller) {
                  return Text(
                    productController.count.toString(),
                    style: const TextStyle(color: white),
                  );
                }),
                child: IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    Get.to(() => const CartScreen());
                  },
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Get.to(() => const Navbar());
              },
            ),
          ],
          backgroundColor: kPrimaryGreen,
        ),
        body: SingleChildScrollView(
          controller: _controller,
          child: Column(children: [
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  height: height * 0.15,
                  child: GetBuilder<CategoryController>(
                    builder: (controller) {
                      return ListView.builder(
                          // itemCount: _choices.length,
                          itemCount: categoryController.category.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
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
                                    Get.to(() => const PopularProductList(),
                                        arguments: {
                                          "categoryId":
                                              categories.id.toString(),
                                          "offerId": '',
                                          "productId": '',
                                          'isPopular': '',
                                          'highToLow': '',
                                          'maxPrice': 10000,
                                          'minPrice': 0,
                                          'sortColumn': '',
                                          'productName': '',
                                        });
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
                                    shape: const CircleBorder(),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ),
            SizedBox(
              width: double.infinity,
              height: height * 0.15,
              child: GetBuilder<OfferController>(builder: (controller) {
                return offerController.offer.isEmpty
                    ? const SizedBox()
                    : CarouselSlider.builder(
                        options: CarouselOptions(
                          height: size.height * 0.2,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          // aspectRatio: 20 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          // enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 400),
                          viewportFraction: 0.8,
                          disableCenter: true,
                        ),
                        itemCount: offerController.offer.length,
                        itemBuilder: (context, index, realIndex) {
                          var offer = offerController.offer[index];
                          return Card(
                            child: Container(
                              child: InkWell(
                                onTap: () async {
                                  Get.to(() => const PopularProductList(),
                                      arguments: {
                                        "offerId": offer.id.toString(),
                                        "categoryId": '',
                                        "productId": '',
                                        'isPopular': '',
                                        'highToLow': '',
                                        'maxPrice': 10000,
                                        'minPrice': 0,
                                        'sortColumn': '',
                                        'productName': '',
                                      });
                                },
                                child: ImageFade(
                                    image: NetworkImage(serverUrl +
                                        'api/auth/serveproducts/${offer.imageUrl.toString()}'),
                                    fit: BoxFit.cover,
                                    // scale: 2,
                                    placeholder: Image.file(
                                      fit: BoxFit.cover,
                                      File(
                                          '${directory.path}/compress${offer.imageUrl.toString()}'),
                                      gaplessPlayback: true,
                                    )),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.antiAlias,
                          );
                        },
                      );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                        Get.to(() => const PopularProductList(), arguments: {
                          "offerId": '',
                          "categoryId": '',
                          "productId": '',
                          'isPopular': '',
                          'highToLow': '',
                          'maxPrice': 10000,
                          'minPrice': 0,
                          'sortColumn': '',
                          'productName': '',
                        });
                      },
                      child: Text('see more',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.20,
              child:
                  GetBuilder<PopularProductController>(builder: (controller) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: popularproductController.popular.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      var popular = popularproductController.popular[index];
                      return GestureDetector(
                        onTap: () => null,
                        child: Column(
                          children: [
                            Hero(
                              tag: "anim$index",
                              child: GestureDetector(
                                onTap: () async {
                                  Get.to(() => const PopularProductList(),
                                      arguments: {
                                        "offerId": '',
                                        "categoryId": '',
                                        "productId": popular.id.toString(),
                                        'isPopular': '',
                                        'highToLow': '',
                                        'maxPrice': 10000,
                                        'minPrice': 0,
                                        'sortColumn': '',
                                        'productName': '',
                                      });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 8, left: 8, top: 0, bottom: 0),
                                  width: width * 0.25,
                                  height: height * 0.13,
                                  child: ImageFade(
                                      image: NetworkImage(serverUrl +
                                          'api/auth/serveproducts/${popular.imageUrl.toString()}'),
                                      fit: BoxFit.cover,
                                      placeholder: Image.file(
                                        fit: BoxFit.cover,
                                        File(
                                            '${directory.path}/compress${popular.imageUrl.toString()}'),
                                        gaplessPlayback: true,
                                      )),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14)),
                                    color: white,
                                    // image: DecorationImage(
                                    //   fit: BoxFit.cover,
                                    //   image: NetworkImage(serverUrl +
                                    //       'api/auth/serveproducts/${popular.imageUrl.toString()}'),
                                    //   // AssetImage(
                                    //   //     "assets/shoe_1.webp")
                                    // )
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 2, left: 10, right: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("All Products",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    width: 150,
                  ),
                  TextButton.icon(
                    // <-- OutlinedButton
                    onPressed: () {
                      Get.to(() => const FilterPage());
                    },
                    label: Text('Filter',
                        style: Theme.of(context).textTheme.titleMedium),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20.0,
                      color: black,
                    ),
                  ),
                ],
              ),
            ),
            _isFirstLoadRunning
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      children: [
                        GetBuilder<ProductController>(builder: (controller) {
                          return ListView.builder(
                              // controller: _controller,
                              itemCount:
                                  productController.productResponseList.length,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 12, right: 6, left: 6, top: 6),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => const ProductDetails(),
                                          arguments: {
                                            'productId': productController
                                                .productResponseList[index]
                                                    ['id']
                                                .toString()
                                          });
                                    },
                                    child: Container(
                                        width: width,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 1,
                                                        color: black
                                                            .withOpacity(0.1),
                                                        blurRadius: 2)
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Center(
                                                      child: Container(
                                                        width: width * 0.3,
                                                        height: height * 0.12,
                                                        child: ImageFade(
                                                            image: NetworkImage(
                                                                serverUrl +
                                                                    'api/auth/serveproducts/${productController.productResponseList[index]['imageUrl'].toString()}'),
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                Image.file(
                                                              fit: BoxFit.cover,
                                                              File(
                                                                  '${directory.path}/compress${productController.productResponseList[index]['imageUrl'].toString()}'),
                                                              gaplessPlayback:
                                                                  true,
                                                            )),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                productController
                                                                    .productResponseList[
                                                                        index]
                                                                        ['name']
                                                                    .toString(),
                                                                // products[index]['name'],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ),
                                                            ),
                                                            Text(
                                                                "\₹ " +
                                                                    productController
                                                                        .productResponseList[
                                                                            index]
                                                                            [
                                                                            'price']
                                                                        .toString(),

                                                                // "\$ " + products[index]['price'],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .crop_square_sharp,
                                                                  color: productController.productResponseList[index]
                                                                              [
                                                                              'isVegan'] ==
                                                                          true
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                                  size: 20,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: productController.productResponseList[index]['isVegan'] ==
                                                                            true
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red,
                                                                    size: 6),
                                                              ],
                                                            ),
                                                            Text(
                                                                '${productController.productResponseList[index]['weight'].toString()}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium)
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        //  productController.productResponseList[index]
                                                        //['added'] !=false &&
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            productController.productResponseList[
                                                                            index]
                                                                        [
                                                                        'isSubscribe'] ==
                                                                    true
                                                                ? Container(
                                                                    height:
                                                                        height *
                                                                            0.05,
                                                                    width:
                                                                        width *
                                                                            0.2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color:
                                                                          black,
                                                                    ),
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.to(
                                                                            () =>
                                                                                const SubscribeProductDetails(),
                                                                            arguments: {
                                                                              "proId": productController.productResponseList[index]['id'].toString(),
                                                                            });
                                                                      },
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                5,
                                                                            vertical:
                                                                                3),
                                                                        backgroundColor:
                                                                            buttonColour,
                                                                      ),
                                                                      child: Text(
                                                                          "Subscribe",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .caption!
                                                                              .apply(color: white)),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            productController.productResponseList[index]
                                                                            [
                                                                            'inventory']
                                                                        [
                                                                        'quantity'] >
                                                                    0
                                                                ? Container(
                                                                    height:
                                                                        height *
                                                                            0.05,
                                                                    width:
                                                                        width *
                                                                            0.2,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color:
                                                                          buttonColour,
                                                                    ),
                                                                    child: productController.productResponseList[index]['cartQauntity'] !=
                                                                            0
                                                                        ? Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            // mainAxisAlignment:
                                                                            //     MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.zero,
                                                                                  child: IconButton(
                                                                                    iconSize: height * 0.02,
                                                                                    icon: const Icon(Icons.remove),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        productController.increasequantity(this.id!, productController.productResponseList[index]['id'], this.remove);
                                                                                        if (productController.productResponseList[index]['cartQauntity'] > 1) {
                                                                                          productController.productResponseList[index]['cartQauntity'] = productController.productResponseList[index]['cartQauntity'] - 1;
                                                                                        } else {
                                                                                          productController.onReady();
                                                                                          productController.productResponseList[index]['cartQauntity'] = 0;
                                                                                          productController.productResponseList[index]['added'] = false;
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    color: white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                productController.productResponseList[index]['cartQauntity'].toString(),
                                                                                style: Theme.of(context).textTheme.caption!.apply(color: white),
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(right: 8.0),
                                                                                  child: IconButton(
                                                                                    iconSize: height * 0.02,
                                                                                    icon: const Icon(Icons.add),
                                                                                    color: white,
                                                                                    onPressed: () {
                                                                                      if (productController.productResponseList[index]['cartQauntity'] < 5 && productController.productResponseList[index]['inventory']['quantity'] > productController.productResponseList[index]['cartQauntity']) {
                                                                                        productController.increasequantity(this.id!, productController.productResponseList[index]['id'], this.add);
                                                                                        setState(() {
                                                                                          productController.productResponseList[index]['cartQauntity'] = productController.productResponseList[index]['cartQauntity'] + 1;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              productController.increasequantity(this.id!, productController.productResponseList[index]['id'], this.add);
                                                                              setState(() {
                                                                                productController.onReady();
                                                                                productController.productResponseList[index]['cartQauntity'] = 1;
                                                                                productController.productResponseList[index]['added'] = true;
                                                                              });
                                                                            },
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                              backgroundColor: buttonColour,
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "Add to Cart",
                                                                              style: Theme.of(context).textTheme.caption!.apply(color: white),
                                                                            ),
                                                                          ),
                                                                  )
                                                                : Text(
                                                                    'Out Of Stock',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .apply(
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                              });
                        }),
                        if (_isLoadMoreRunning == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 40),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
          ]),
        ),
        //  ),
      ),
    );
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
