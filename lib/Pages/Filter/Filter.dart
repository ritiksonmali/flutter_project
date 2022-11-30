import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/Product/PopularProductList.dart';
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
    'Men',
    'Women',
    'Fashion',
    'kid',
    'Baby',
    'Fruit',
  ];
  int startValue = 0;
  int endValue = 1500;
  RangeValues _currentRangeValues = const RangeValues(0, 1500);
  String? valueChoose;
  List listItemSorting = [
    'Low to High Price',
    'High to Low Price',
  ];
  bool? check1 = false;
  bool highToLow = false;
  String sortColumn = "";
  String catagoryId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        automaticallyImplyLeading: true,
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Filter",
          style: TextStyle(
            color: black,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    Text('1500', style: Theme.of(context).textTheme.bodyMedium),
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
                  child: DropdownButton(
                    hint: Text("Select",
                        style: Theme.of(context).textTheme.bodyMedium),
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    isExpanded: true,
                    value: valueChoose,
                    onChanged: (newValue) {
                      setState(() {
                        valueChoose = newValue as String;
                        //catagoryId=valueChoose;
                      });
                    },
                    items: listItem.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
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
                backgroundColor: black,
                onPressed: () {
                  print(check1.toString());
                  if (valueChooseSort.toString() == 'High to Low Price') {
                    if (check1.toString() == 'true') {
                      print('loop1');
                      productController.getFilterProducts('true', 'true',
                          endValue, startValue, sortColumn, catagoryId, '', '');
                    } else {
                      print('loop2');
                      productController.getFilterProducts('', 'true', endValue,
                          startValue, sortColumn, catagoryId, '', '');
                    }
                  } else {
                    print('loop3');
                    if (check1.toString() == 'true') {
                      print(check1.toString());
                      productController.getFilterProducts(
                          check1.toString(),
                          'false',
                          endValue,
                          startValue,
                          sortColumn,
                          catagoryId,
                          '',
                          '');
                    } else {
                      print('loop4');
                      productController.getFilterProducts('', 'false', endValue,
                          startValue, sortColumn, catagoryId, '', '');
                    }
                  }
                  Timer(Duration(seconds: 5), () {
                    Get.to(() => PopularProductList());
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
