import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/ApplicationParameterController.dart';
import 'package:flutter_login_app/Controller/PopularproductController.dart';
import 'package:flutter_login_app/Controller/ProductController.dart';
import 'package:flutter_login_app/Pages/Home/home_screen.dart';
import 'package:flutter_login_app/Pages/Search/Search.dart';
import 'package:flutter_login_app/Pages/Subscribe/SubscribeProductDetails.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../ConstantUtil/globals.dart';
import '../../screens/Navbar.dart';
import '../Filter/Filter.dart';
import '../cart/cart_screen.dart';
import 'package:http/http.dart' as http;

class PopularProductList extends StatefulWidget {
  const PopularProductList({Key? key}) : super(key: key);

  @override
  State<PopularProductList> createState() => _PopularProductListState();
}

class _PopularProductListState extends State<PopularProductList> {
  final ProductController productController = Get.put(ProductController());
  final PopularProductController popularproductController = Get.find();

  final ScrollController _scrollController = ScrollController();

  int? id;
  String add = "add";
  String remove = "remove";
  var argument = Get.arguments;

  int _page = 0;

  final int _limit = 5;

  bool _isFirstLoadRunning = true;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  void test() async {
    var store = await SharedPreferences.getInstance(); //add when requried
    var iddata = store.getString('id');
    int id = jsonDecode(iddata!);
    setState(() {
      this.id = id;
    });
  }

  void _firstLoad() async {
    // setState(() {
    //   _isFirstLoadRunning = true;
    // });
    productController
        .getFilterProducts(
            argument['isPopular'],
            argument['highToLow'],
            argument['maxPrice'],
            argument['minPrice'],
            argument['sortColumn'],
            argument['categoryId'],
            argument['offerId'],
            argument['productName'],
            argument['productId'])
        .then((value) {
      setState(() {
        _isFirstLoadRunning = false;
      });
    });
    // setState(() {
    //   _isFirstLoadRunning = false;
    // });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      print('loading called');
      _page += 1;
      try {
        var store = await SharedPreferences.getInstance();
        var iddata = store.getString('id');
        int user_id = jsonDecode(iddata!);
        String url =
            '${serverUrl}api/auth/fetchlistofproductbyfilter?pagenum=$_page&pagesize=$_limit&status=active&maxprice=${argument['maxPrice']}&minprice=${argument['minPrice']}&ispopular=${argument['isPopular']}&sorting=${argument['sortColumn']}&Asc=${argument['highToLow']}&userId=$user_id&categoryId=${argument['categoryId']}&offerId=${argument['offerId']}&productname=${argument['productName']}&productId=${argument['productId']}';
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );
        var body = jsonDecode(response.body);
        List records = body['records'];
        if (records.isNotEmpty) {
          setState(() {
            productController.productFilterResponseList.addAll(body['records']);
          });
        } else {
          setState(() {
            _hasNextPage = false;
            Fluttertoast.showToast(msg: "You have Fetched all The records");
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

  @override
  void initState() {
    super.initState();
    productController.productFilterResponseList.clear();
    test();
    _firstLoad();
    _scrollController.addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return WillPopScope(
      onWillPop: () async {
        // CommanDialog.showLoading();
        // productController.getAllProducts();
        // Timer(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen()), // this mymainpage is your page to refresh
          (Route<dynamic> route) => false,
        );
        //   CommanDialog.hideLoading();
        // });
        return false;
      },
      child: Scaffold(
        backgroundColor: grey,
        appBar: AppBar(
          backgroundColor: kPrimaryGreen,
          title: Text('Product List',
              style:
                  Theme.of(context).textTheme.headline5!.apply(color: white)),
          iconTheme: const IconThemeData(color: white),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // CommanDialog.showLoading();
              // productController.getAllProducts();
              // Timer(const Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen()), // this mymainpage is your page to refresh
                (Route<dynamic> route) => false,
              );
              //   CommanDialog.hideLoading();
              // });
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                Get.to(() => const SearchPage());
              },
            ),
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Get.to(() => const Navbar());
              }, //=> _key.currentState!.openDrawer(),
            ),
          ],
        ),
        body: _isFirstLoadRunning
            ? Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        5, // number of shimmer placeholders you want to show
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 16.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  width: double.infinity,
                                  height: 16.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  width: 100.0,
                                  height: 16.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
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
                  const SizedBox(
                    height: 5,
                  ),
                  GetBuilder<ProductController>(builder: (controller) {
                    return ListView.builder(
                        // controller: _scrollController,
                        itemCount:
                            productController.productFilterResponseList.length,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var popular = productController
                              .productFilterResponseList[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12, right: 6, left: 6, top: 6),
                            child: InkWell(
                              onTap: () {
                                // Get.to(() => const ProductDetails(),
                                //     arguments: {
                                //       'productId': productController
                                //           .productResponseList[index]
                                //               ['id']
                                //           .toString()
                                //     });
                              },
                              child: SizedBox(
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
                                                  color: black.withOpacity(0.1),
                                                  blurRadius: 2)
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  width: width * 0.3,
                                                  height: height * 0.12,
                                                  child: ImageFade(
                                                      image: NetworkImage(
                                                          '${serverUrl}api/auth/serveproducts/${productController.productFilterResponseList[index]['imageUrl'].toString()}'),
                                                      fit: BoxFit.cover,
                                                      placeholder: Image.file(
                                                        fit: BoxFit.cover,
                                                        File(
                                                            '${directory.path}/compress${productController.productFilterResponseList[index]['imageUrl'].toString()}'),
                                                        gaplessPlayback: true,
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
                                                              .productFilterResponseList[
                                                                  index]['name']
                                                              .toString(),
                                                          // products[index]['name'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        ),
                                                      ),
                                                      Text(
                                                          "\₹ ${productController.productFilterResponseList[index]['price']}",

                                                          // "\$ " + products[index]['price'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .crop_square_sharp,
                                                            color: productController
                                                                            .productFilterResponseList[index]
                                                                        [
                                                                        'isVegan'] ==
                                                                    true
                                                                ? Colors.green
                                                                : Colors.red,
                                                            size: 20,
                                                          ),
                                                          Icon(Icons.circle,
                                                              color: productController
                                                                              .productFilterResponseList[index]
                                                                          [
                                                                          'isVegan'] ==
                                                                      true
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              size: 6),
                                                        ],
                                                      ),
                                                      Text(
                                                          productController
                                                              .productFilterResponseList[
                                                                  index]
                                                                  ['weight']
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      productController.productFilterResponseList[
                                                                      index][
                                                                  'isSubscribe'] ==
                                                              true
                                                          ? Container(
                                                              height:
                                                                  height * 0.05,
                                                              width:
                                                                  width * 0.2,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: black,
                                                              ),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  Get.to(
                                                                      () =>
                                                                          const SubscribeProductDetails(),
                                                                      arguments: {
                                                                        "proId": productController
                                                                            .productFilterResponseList[index]['id']
                                                                            .toString(),
                                                                      });
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          3),
                                                                  backgroundColor:
                                                                      buttonColour,
                                                                ),
                                                                child: Text(
                                                                    "Subscribe",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .caption!
                                                                        .apply(
                                                                            color:
                                                                                white)),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      productController.productFilterResponseList[
                                                                              index]
                                                                          [
                                                                          'inventory']
                                                                      [
                                                                      'quantity'] >
                                                                  0 &&
                                                              ApplicationParameterController
                                                                  .isOrdersEnable
                                                                  .value
                                                          ? Container(
                                                              height:
                                                                  height * 0.05,
                                                              width:
                                                                  width * 0.2,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    buttonColour,
                                                              ),
                                                              child: productController
                                                                              .productFilterResponseList[index]
                                                                          [
                                                                          'cartQauntity'] !=
                                                                      0
                                                                  ? Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      // mainAxisAlignment:
                                                                      //     MainAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            child:
                                                                                IconButton(
                                                                              iconSize: height * 0.02,
                                                                              icon: const Icon(Icons.remove),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  productController.increasequantity(id!, productController.productFilterResponseList[index]['id'], remove);
                                                                                  if (productController.productFilterResponseList[index]['cartQauntity'] > 1) {
                                                                                    productController.productFilterResponseList[index]['cartQauntity'] = productController.productFilterResponseList[index]['cartQauntity'] - 1;
                                                                                  } else {
                                                                                    productController.onReady();
                                                                                    productController.productFilterResponseList[index]['cartQauntity'] = 0;
                                                                                    productController.productFilterResponseList[index]['added'] = false;
                                                                                  }
                                                                                });
                                                                              },
                                                                              color: white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          productController
                                                                              .productFilterResponseList[index]['cartQauntity']
                                                                              .toString(),
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .caption!
                                                                              .apply(color: white),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 8.0),
                                                                            child:
                                                                                IconButton(
                                                                              iconSize: height * 0.02,
                                                                              icon: const Icon(Icons.add),
                                                                              color: white,
                                                                              onPressed: () {
                                                                                if (productController.productFilterResponseList[index]['cartQauntity'] < 5 && productController.productFilterResponseList[index]['inventory']['quantity'] > productController.productFilterResponseList[index]['cartQauntity']) {
                                                                                  productController.increasequantity(id!, productController.productFilterResponseList[index]['id'], add);
                                                                                  setState(() {
                                                                                    productController.productFilterResponseList[index]['cartQauntity'] = productController.productFilterResponseList[index]['cartQauntity'] + 1;
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
                                                                        productController.increasequantity(
                                                                            id!,
                                                                            productController.productFilterResponseList[index]['id'],
                                                                            add);
                                                                        setState(
                                                                            () {
                                                                          productController
                                                                              .onReady();
                                                                          productController.productFilterResponseList[index]['cartQauntity'] =
                                                                              1;
                                                                          productController.productFilterResponseList[index]['added'] =
                                                                              true;
                                                                        });
                                                                      },
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                5,
                                                                            vertical:
                                                                                5),
                                                                        backgroundColor:
                                                                            buttonColour,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        "Add to Cart",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .caption!
                                                                            .apply(color: white),
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
                                                                    color: Colors
                                                                        .red,
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
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            5, // number of shimmer placeholders you want to show
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 16.0,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Container(
                                      width: double.infinity,
                                      height: 16.0,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Container(
                                      width: 100.0,
                                      height: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ]),
              ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          opacity: 1.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            // child: Icon(Icons.shopping_bag_outlined),
            backgroundColor: white,
            child: Center(
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
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: black,
                  ),
                  onPressed: () {
                    Get.to(() => const CartScreen());
                  },
                ),
              ),
            ),
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
