import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
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

  ScrollController _scrollController = new ScrollController();

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
        String url = serverUrl +
            'api/auth/fetchlistofproductbyfilter?pagenum=${_page}&pagesize=${_limit}&status=active&maxprice=${argument['maxPrice']}&minprice=${argument['minPrice']}&ispopular=${argument['isPopular']}&sorting=${argument['sortColumn']}&Asc=${argument['highToLow']}&userId=${user_id}&categoryId=${argument['categoryId']}&offerId=${argument['offerId']}&productname=${argument['productName']}&productId=${argument['productId']}';
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
    // TODO: implement initState
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
        CommanDialog.showLoading();
        productController.getAllProducts();
        Timer(Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen()), // this mymainpage is your page to refresh
            (Route<dynamic> route) => false,
          );
          CommanDialog.hideLoading();
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: Text('Product List', style: TextStyle(color: black)),
          iconTheme: IconThemeData(color: black),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              CommanDialog.showLoading();
              productController.getAllProducts();
              Timer(Duration(seconds: 1), () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // this mymainpage is your page to refresh
                  (Route<dynamic> route) => false,
                );
                CommanDialog.hideLoading();
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                Get.to(() => SearchPage());
              },
            ),
            IconButton(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Get.to(() => Navbar());
              }, //=> _key.currentState!.openDrawer(),
            ),
          ],
        ),
        body: _isFirstLoadRunning == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
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
                SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: GetBuilder<ProductController>(builder: (controller) {
                  return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          productController.productFilterResponseList.length,
                      itemBuilder: (context, index) {
                        var popular =
                            productController.productFilterResponseList[index];
                        // itemCount:
                        // productImage.length;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: grey,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0.5,
                                              color: black.withOpacity(0.1),
                                              blurRadius: 1)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          left: 10,
                                          right: 10,
                                          bottom: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              width: width * 0.3,
                                              height: height * 0.1,
                                              child: ImageFade(
                                                  image: NetworkImage(serverUrl +
                                                      'api/auth/serveproducts/${productController.productFilterResponseList[index]['imageUrl'].toString()}'),
                                                  fit: BoxFit.cover,
                                                  // scale: 2,
                                                  placeholder: Image.file(
                                                    fit: BoxFit.cover,
                                                    File(
                                                        '${directory.path}/compress${productController.productFilterResponseList[index]['imageUrl'].toString()}'),
                                                    gaplessPlayback: true,
                                                  )),
                                              // decoration: BoxDecoration(
                                              //     image: DecorationImage(
                                              //         image: NetworkImage(
                                              //             serverUrl +
                                              //                 'api/auth/serveproducts/${productController.productFilterResponseList[index]['imageUrl'].toString()}'),
                                              //         // image: AssetImage("assets/shoe_1.webp"),
                                              //         fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                productController
                                                    .productFilterResponseList[
                                                        index]['name']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              "₹" +
                                                  productController
                                                      .productFilterResponseList[
                                                          index]['price']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(
                                                  Icons.crop_square_sharp,
                                                  color: productController
                                                                  .productFilterResponseList[
                                                              index]['isVegan'] ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 25,
                                                ),
                                                Icon(Icons.circle,
                                                    color: productController
                                                                    .productFilterResponseList[
                                                                index]['isVegan'] ==
                                                            true
                                                        ? Colors.green
                                                        : Colors.red,
                                                    size: 8),
                                              ],
                                            ),
                                            Text(
                                                '${productController.productFilterResponseList[index]['weight'].toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium)
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            productController
                                                            .productFilterResponseList[
                                                        index]['isSubscribe'] ==
                                                    true
                                                ? Container(
                                                    // height: 40,
                                                    height: height * 0.06,
                                                    width: width * 0.2,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: buttonColour,
                                                    ),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.to(
                                                            () =>
                                                                SubscribeProductDetails(),
                                                            arguments: {
                                                              "proId": productController
                                                                  .productFilterResponseList[
                                                                      index]
                                                                      ['id']
                                                                  .toString(),
                                                            });
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 3),
                                                        backgroundColor: buttonColour,
                                                      ),
                                                      child: Text("Subscribe",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .apply(
                                                                  color:
                                                                      white)),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            productController.productFilterResponseList[
                                                            index]['inventory']
                                                        ['quantity'] >
                                                    0
                                                ? Container(
                                                    // height: 40,
                                                    height: height * 0.06,
                                                    width: width * 0.2,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: buttonColour,
                                                    ),
                                                    child: productController
                                                                        .productFilterResponseList[
                                                                    index][
                                                                'cartQauntity'] !=
                                                            0
                                                        ? Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  child:
                                                                      IconButton(
                                                                    iconSize:
                                                                        height *
                                                                            0.02,
                                                                    icon: Icon(Icons
                                                                        .remove),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        productController.increasequantity(
                                                                            this.id!,
                                                                            productController.productFilterResponseList[index]['id'],
                                                                            this.remove);
                                                                        if (productController.productFilterResponseList[index]['cartQauntity'] >
                                                                            1) {
                                                                          productController.productFilterResponseList[index]
                                                                              [
                                                                              'cartQauntity'] = productController.productFilterResponseList[index]
                                                                                  ['cartQauntity'] -
                                                                              1;
                                                                        } else {
                                                                          productController
                                                                              .onReady();
                                                                          productController.productFilterResponseList[index]['cartQauntity'] =
                                                                              0;
                                                                          productController.productFilterResponseList[index]['added'] =
                                                                              false;
                                                                        }
                                                                      });
                                                                    },
                                                                    color:
                                                                        white,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                productController
                                                                    .productFilterResponseList[
                                                                        index][
                                                                        'cartQauntity']
                                                                    .toString(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption!
                                                                    .apply(
                                                                        color:
                                                                            white),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child:
                                                                      IconButton(
                                                                    iconSize:
                                                                        height *
                                                                            0.02,
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                    color:
                                                                        white,
                                                                    onPressed:
                                                                        () {
                                                                      if (productController.productFilterResponseList[index]['cartQauntity'] <
                                                                              5 &&
                                                                          productController.productFilterResponseList[index]['inventory']['quantity'] >
                                                                              productController.productFilterResponseList[index]['cartQauntity']) {
                                                                        productController.increasequantity(
                                                                            this.id!,
                                                                            productController.productFilterResponseList[index]['id'],
                                                                            this.add);
                                                                        setState(
                                                                            () {
                                                                          productController.productFilterResponseList[index]
                                                                              [
                                                                              'cartQauntity'] = productController.productFilterResponseList[index]
                                                                                  ['cartQauntity'] +
                                                                              1;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : ElevatedButton(
                                                            onPressed: () {
                                                              productController
                                                                  .increasequantity(
                                                                      this.id!,
                                                                      productController
                                                                              .productFilterResponseList[index]
                                                                          [
                                                                          'id'],
                                                                      this.add);
                                                              setState(() {
                                                                productController
                                                                    .onReady();
                                                                productController
                                                                            .productFilterResponseList[
                                                                        index][
                                                                    'cartQauntity'] = 1;
                                                                productController
                                                                            .productFilterResponseList[
                                                                        index][
                                                                    'added'] = true;
                                                              });
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          5),
                                                              backgroundColor:
                                                                  buttonColour,
                                                            ),
                                                            child: Text(
                                                              "Add to Cart",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .caption!
                                                                  .apply(
                                                                      color:
                                                                          white),
                                                            ),
                                                          ),
                                                  )
                                                : Text(
                                                    'Out Of Stock',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .apply(
                                                          color: Colors.red,
                                                        ),
                                                  ),
                                          ],
                                        ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: <Widget>[
                                        //     Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.start,
                                        //       children: [
                                        //         Stack(
                                        //           alignment: Alignment.center,
                                        //           children: [
                                        //             Icon(
                                        //               Icons.crop_square_sharp,
                                        //               color: productController
                                        //                               .productFilterResponseList[
                                        //                           index]['isVegan'] ==
                                        //                       true
                                        //                   ? Colors.green
                                        //                   : Colors.red,
                                        //               size: 25,
                                        //             ),
                                        //             Icon(Icons.circle,
                                        //                 color: productController
                                        //                                     .productFilterResponseList[
                                        //                                 index]
                                        //                             ['isVegan'] ==
                                        //                         true
                                        //                     ? Colors.green
                                        //                     : Colors.red,
                                        //                 size: 8),
                                        //           ],
                                        //         ),
                                        //         Text(
                                        //             '${productController.productFilterResponseList[index]['weight'].toString()}',
                                        //             style: Theme.of(context)
                                        //                 .textTheme
                                        //                 .bodyMedium)
                                        //       ],
                                        //     ),
                                        //     Padding(
                                        //       padding: const EdgeInsets.only(
                                        //           right: 10),
                                        //       child: productController
                                        //                           .productFilterResponseList[
                                        //                       index]['inventory']
                                        //                   ['quantity'] >
                                        //               0
                                        //           ? Container(
                                        //               width: 80,
                                        //               height: 40,
                                        //               decoration: BoxDecoration(
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(
                                        //                         5),
                                        //                 color: black,
                                        //               ),
                                        //               child: productController
                                        //                                   .productFilterResponseList[
                                        //                               index][
                                        //                           'cartQauntity'] !=
                                        //                       0
                                        //                   ? Row(
                                        //                       mainAxisSize:
                                        //                           MainAxisSize
                                        //                               .min,
                                        //                       children: <Widget>[
                                        //                         Expanded(
                                        //                           child: Padding(
                                        //                             padding:
                                        //                                 EdgeInsets
                                        //                                     .zero,
                                        //                             child:
                                        //                                 SizedBox(
                                        //                               height: 50,
                                        //                               width: 35,
                                        //                               child:
                                        //                                   IconButton(
                                        //                                 icon: Icon(
                                        //                                     Icons
                                        //                                         .remove),
                                        //                                 onPressed:
                                        //                                     () {
                                        //                                   setState(
                                        //                                       () {
                                        //                                     productController.increasequantity(
                                        //                                         this.id!,
                                        //                                         productController.productFilterResponseList[index]['id'],
                                        //                                         this.remove);
                                        //                                     if (productController.productFilterResponseList[index]['cartQauntity'] >
                                        //                                         1) {
                                        //                                       productController.productFilterResponseList[index]['cartQauntity'] =
                                        //                                           productController.productFilterResponseList[index]['cartQauntity'] - 1;
                                        //                                     } else {
                                        //                                       productController.productFilterResponseList[index]['cartQauntity'] =
                                        //                                           0;
                                        //                                       productController.productFilterResponseList[index]['added'] =
                                        //                                           false;
                                        //                                     }
                                        //                                   });
                                        //                                 },
                                        //                                 color:
                                        //                                     white,
                                        //                               ),
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                         Text(
                                        //                           productController
                                        //                               .productFilterResponseList[
                                        //                                   index][
                                        //                                   'cartQauntity']
                                        //                               .toString(),
                                        //                           style: TextStyle(
                                        //                               color:
                                        //                                   white),
                                        //                         ),
                                        //                         Padding(
                                        //                           padding: EdgeInsets
                                        //                               .only(
                                        //                                   right:
                                        //                                       8),
                                        //                           child: SizedBox(
                                        //                             height: 50,
                                        //                             width: 30,
                                        //                             child:
                                        //                                 IconButton(
                                        //                               icon: Icon(
                                        //                                   Icons
                                        //                                       .add),
                                        //                               color:
                                        //                                   white,
                                        //                               onPressed:
                                        //                                   () {
                                        //                                 if (productController.productFilterResponseList[index]['cartQauntity'] <
                                        //                                         5 &&
                                        //                                     productController.productFilterResponseList[index]['inventory']['quantity'] >
                                        //                                         productController.productFilterResponseList[index]['cartQauntity']) {
                                        //                                   productController.increasequantity(
                                        //                                       this.id!,
                                        //                                       productController.productFilterResponseList[index]['id'],
                                        //                                       this.add);
                                        //                                   setState(
                                        //                                       () {
                                        //                                     productController.productFilterResponseList[index]
                                        //                                         [
                                        //                                         'cartQauntity'] = productController.productFilterResponseList[index]
                                        //                                             ['cartQauntity'] +
                                        //                                         1;
                                        //                                   });
                                        //                                 }
                                        //                               },
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                       ],
                                        //                     )
                                        //                   : ElevatedButton(
                                        //                       onPressed: () {
                                        //                         productController
                                        //                             .increasequantity(
                                        //                                 this.id!,
                                        //                                 productController
                                        //                                         .productFilterResponseList[index]
                                        //                                     [
                                        //                                     'id'],
                                        //                                 this.add);
                                        //                         setState(() {
                                        //                           productController
                                        //                                       .productFilterResponseList[
                                        //                                   index][
                                        //                               'cartQauntity'] = 1;
                                        //                           productController
                                        //                                       .productFilterResponseList[
                                        //                                   index][
                                        //                               'added'] = true;
                                        //                         });
                                        //                       },
                                        //                       style: TextButton
                                        //                           .styleFrom(
                                        //                         backgroundColor:
                                        //                             black,
                                        //                       ),
                                        //                       child: Text("Add",
                                        //                           style:
                                        //                               TextStyle(
                                        //                             color: white,
                                        //                             fontSize: 16,
                                        //                           )),
                                        //                     ),
                                        //             )
                                        //           : Text(
                                        //               'Out Of Stock',
                                        //               style: TextStyle(
                                        //                   color: Colors.redAccent,
                                        //                   fontSize: 15,
                                        //                   fontWeight:
                                        //                       FontWeight.w500),
                                        //             ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                  
                            ],
                          ),
                        );
                      });
                })),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ]),
              
              
        floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 1000),
          opacity: 1.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => CartScreen());
            },
            child: Center(
              child: Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: black,
                  ),
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
            // child: Icon(Icons.shopping_bag_outlined),
            backgroundColor: white,
          ),
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
