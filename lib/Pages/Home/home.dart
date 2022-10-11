import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'HomeItem.dart';
import 'ImageAd.dart';
import 'Search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         
        appBar: AppBar(
         title: Text('Shoping cart' , style: TextStyle(color: Colors.black),),
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
                            Badge(
                                position: BadgePosition.topEnd(top: 0, end: 3),
                                child: IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                   onPressed: () {
                                    Get.to(() => SearchPage());
                                   },
                                ),
                              badgeContent: Text("6"),
                             ), 
                            IconButton(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                               icon: const Icon(Icons.menu),
                               onPressed: () {},//=> _key.currentState!.openDrawer(),
                               
                          ),
                         
                          ],
         backgroundColor: Colors.white,
        ),
      endDrawer: NavBar(),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
               width: double.infinity,
              height: 100,
              child: ListView.builder(
                  itemCount: _choices.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Card(
                          color: Colors.white,
                          shadowColor:Colors.black,
                          child: Container(
                            child: Center(
                                child: Text(
                                  _choices[index].name,
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          shape: CircleBorder(),
                        ),
                      ),
                    );
                  }),
            ),
             SizedBox(
              height: 10,
            ),

            SizedBox(
              width: double.infinity,
              height: 150,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _choices.length,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {

                    return Container(
                      width: 400,
                      child: Card(
                        child: Container( 
                          child: InkWell( 
                              onTap: () {Get.off(() => ImageAdPage());},
                            child: Image.asset('assets/sale.webp',
                                fit: BoxFit.cover)),),
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
                      child: Text(
                        "Popular Product",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
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
                  itemCount: 10,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          null,
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
                                      image: AssetImage("assets/shoe_1.webp"))),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Nike")
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        "New Product",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                           //  .copyWith(fontWeight: FontWeight.bold),
                      )),
                  Text("Show more")
                ],
              ),
            ),


       ] ),
      )
    );
  }


  List<HomeItem> _choices = [
    HomeItem("All", Icon(Icons.clear_all_rounded)),
    HomeItem("Men", Icon(Icons.person)),
    HomeItem("Women", Icon(Icons.emoji_people_sharp)),
    HomeItem("Fashion", Icon(Icons.shopping_bag)),
    HomeItem("Baby", Icon(Icons.child_care)),
    HomeItem("Kids", Icon(Icons.face_sharp))
  ];

}
  