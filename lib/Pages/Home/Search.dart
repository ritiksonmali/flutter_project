import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../ConstantUtil/colors.dart';
import '../Order/OrderScreen.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

 List<String> foodList = [
   ' Men',
   ' Women',
   ' Fashion',
   ' Kids',
   ' Baby',
   ' Fruit',
   ' Popular Product'
  ];
  List<String>? foodListSearch;
  final FocusNode _textFocusNode = FocusNode();
  TextEditingController? _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController!.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  TextField(
                    controller: _textEditingController,
                    focusNode: _textFocusNode,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'Search here',
                        contentPadding: EdgeInsets.symmetric(  horizontal: 20,)),
                    onChanged: (value) {
                      setState(() {
                        foodListSearch = foodList
                            .where(
                                (element) => element.contains(value.toLowerCase()))
                            .toList();
                        if (_textEditingController!.text.isNotEmpty &&
                            foodListSearch!.length == 0) {
                          print('foodListSearch length ${foodListSearch!.length}');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
              actions: [ IconButton(
                    onPressed:  () {
                           Get.to(() => OrderScreen());
                       },
                    icon:  Icon(
                         Icons.search,
                          color: black,
                    ),
                   ),
        ] ),
        body: _textEditingController!.text.isNotEmpty &&
                foodListSearch!.length == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search_off,
                          size: 160,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No results found,\nPlease try different keyword',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 8,
                  crossAxisSpacing: 20,
                ),
                itemCount: _textEditingController!.text.isNotEmpty
                    ? foodListSearch!.length
                    : foodList.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                         CircleAvatar(
                          child: Icon(Icons.history
                          ),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        
                        Text(_textEditingController!.text.isNotEmpty
                            ? foodListSearch![index]
                            : foodList[index],
                            ),
                      ],
                    ),
                  );
                }));
  }
}
