import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Product/PopularProductList.dart';
import 'package:flutter_login_app/reusable_widgets/comman_dailog.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../../Controller/CategoryController.dart';
import '../../Controller/ProductController.dart';
import '../Home/home.dart';
import '../Search/SearchProductList.dart';
import 'FilterProductList.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? valueChooseSort;
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());
  late int lenghtCatagory = categoryController.category.length;
  late var categories = categoryController.category[lenghtCatagory];
//  Map<String, int> listItem = {'Men': 1, 'Women': 2, 'Fashion': 3,'kid': 4, 'Baby': 5, 'Fruit': 6};
  List listItem = [
    'Fruit and Vegetables',
    'Dairy',
    'Chocolate and snacks',
    'Home Essencials',
    'Personal Care',
    'Cleaning Essencials',
  ];
  int startValue = 0;
  int endValue = 1500;
  RangeValues _currentRangeValues = const RangeValues(0, 1500);
  String? valueChoose;
  String categoryId = '';
  List listItemSorting = [
    'Low to High Price',
    'High to Low Price',
  ];
  bool? check1 = false;
  bool highToLow = false;
  String sortColumn = "";
  // String catagoryId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryGreen,
        centerTitle: true,
        title: Text(
          "Filter",
          style: Theme.of(context).textTheme.headline5!.apply(color: white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: grey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Price",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3, right: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Text('0', style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(
                        width: 270,
                      ),
                      Text('1500',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3, right: 10),
                  child: RangeSlider(
                    values: _currentRangeValues,
                    max: 1500,
                    divisions: 1500,
                    activeColor: black,
                    inactiveColor: Colors.black38,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                        startValue = _currentRangeValues.start.round();
                        endValue = _currentRangeValues.end.round();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Catagory",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton<String>(
                      hint: Text("Select",
                          style: Theme.of(context).textTheme.bodyMedium),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 20,
                      isExpanded: true,
                      value: valueChoose,
                      onChanged: (String? newValue) {
                        setState(() {
                          valueChoose = newValue as String;
                          categoryId = newValue as String;
                          print(valueChoose);
                        });
                      },
                      items: categoryController.category.map((valueItem) {
                        return DropdownMenuItem<String>(
                            value: valueItem.id.toString(),
                            child: Text(valueItem.title.toString()));
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Popular Product",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Popular Product",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Checkbox(
                          //only check box
                          value: check1, //unchecked
                          onChanged: (bool? value) {
                            setState(() {
                              check1 = value;
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Sort",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton(
                      hint: Text(
                        "Select",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      isExpanded: true,
                      value: valueChooseSort,
                      onChanged: (newValueSort) {
                        setState(() {
                          sortColumn = "price";
                          valueChooseSort = newValueSort as String;
                        });
                      },
                      items: listItemSorting.map((valueItemSorting) {
                        return DropdownMenuItem(
                            value: valueItemSorting,
                            child: Text(valueItemSorting));
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FloatingActionButton.extended(
                  label: Text('Search'), // <-- Text
                  backgroundColor: buttonColour,
                  onPressed: () {
                    CommanDialog.showLoading();
                    print(check1.toString());
                    if (valueChooseSort.toString() == 'High to Low Price') {
                      if (check1.toString() == 'true') {
                        print('loop1');
                        // productController.getFilterProducts(
                        //     'true',
                        //     'true',
                        //     endValue,
                        //     startValue,
                        //     sortColumn,
                        //     categoryId,
                        //     '',
                        //     '',
                        //     '');
                        Timer(Duration(seconds: 1), () {
                          Get.to(() => PopularProductList(), arguments: {
                            "offerId": '',
                            "categoryId": categoryId,
                            "productId": '',
                            'isPopular': 'true',
                            'highToLow': 'true',
                            'maxPrice': endValue,
                            'minPrice': startValue,
                            'sortColumn': sortColumn,
                            'productName': '',
                          });
                        });
                      } else {
                        print('loop2');
                        // productController.getFilterProducts('', 'true', endValue,
                        //     startValue, sortColumn, categoryId, '', '', '');
                        Timer(Duration(seconds: 1), () {
                          Get.to(() => PopularProductList(), arguments: {
                            "offerId": '',
                            "categoryId": categoryId,
                            "productId": '',
                            'isPopular': '',
                            'highToLow': 'true',
                            'maxPrice': endValue,
                            'minPrice': startValue,
                            'sortColumn': sortColumn,
                            'productName': '',
                          });
                        });
                      }
                    } else {
                      print('loop3');
                      if (check1.toString() == 'true') {
                        print(check1.toString());
                        // productController.getFilterProducts(
                        //     check1.toString(),
                        //     'false',
                        //     endValue,
                        //     startValue,
                        //     sortColumn,
                        //     categoryId,
                        //     '',
                        //     '',
                        //     '');
                        Timer(Duration(seconds: 1), () {
                          Get.to(() => PopularProductList(), arguments: {
                            "offerId": '',
                            "categoryId": categoryId,
                            "productId": '',
                            'isPopular': check1.toString(),
                            'highToLow': 'false',
                            'maxPrice': endValue,
                            'minPrice': startValue,
                            'sortColumn': sortColumn,
                            'productName': '',
                          });
                        });
                      } else {
                        print('loop4');
                        // productController.getFilterProducts('', 'false', endValue,
                        //     startValue, sortColumn, categoryId, '', '', '');
                        Timer(Duration(seconds: 1), () {
                          Get.to(() => PopularProductList(), arguments: {
                            "offerId": '',
                            "categoryId": categoryId,
                            "productId": '',
                            'isPopular': '',
                            'highToLow': 'false',
                            'maxPrice': endValue,
                            'minPrice': startValue,
                            'sortColumn': sortColumn,
                            'productName': '',
                          });
                        });
                      }
                    }
                    // Timer(Duration(seconds: 1), () {
                    //   Get.to(() => PopularProductList(), arguments: {
                    //     "offerId": '',
                    //     "categoryId": '',
                    //     "productId": ''
                    //   });
                    // });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
