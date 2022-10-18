import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ConstantUtil/colors.dart';
import '../Home/Search.dart';
import '../Payment/RazorPayPayment.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

//   DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
//     final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
       appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
           automaticallyImplyLeading: true,
                         actions: [
                            IconButton(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                               icon: const Icon(Icons.menu),
                               onPressed: () {},//=> _key.currentState!.openDrawer(),
                               
                          ),
                         
                          ],
         backgroundColor: Colors.white,
        ),
      body: getBody(),

     );
   }
}

 Widget getBody(){
    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 30,left: 25,right: 25,bottom: 25),
        child:  Text("My Bag",style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600
              ),),),
        Column(
          children: List.generate(3, (index){
          return Padding(
          padding: const EdgeInsets.only(left: 30,right: 30,bottom: 30),
          child: Row(
              children: <Widget>[
                Container(      
                  decoration: BoxDecoration(
                    color: grey,
                     boxShadow: [BoxShadow(
                        spreadRadius: 0.5,
                        color: black.withOpacity(0.1),
                        blurRadius: 1
                      )],
                    borderRadius: BorderRadius.circular(20)
                  ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10,left: 25,right: 25,bottom: 25),
                                child: Column(

                                  children: <Widget>[
                                   
                                    Center(
                                  child: Container(
                    width: 120,
                    height: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/shoe_1.webp"),fit: BoxFit.cover)
                    ),
                  ),
                                ),
                             
                                  ],
                                ),
                              ),
                ),
                SizedBox(width: 20,),
                Expanded(child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text("Jorden",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),),
                         SizedBox(width: 40,),
                     
                           Container(
                             child: IconButton(
                                              icon : Icon(Icons.delete,color:Colors.black),
                                               onPressed: ()  {
                                              //  Get.to(() => SearchPage());//deletefunction
                                               },
                                              ),
                          ),
                        
                      ],
                    ),
                    SizedBox(height: 15,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                      Text("\$ 200",style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),),
                    Container(
                      width: 80,
                      height: 40,
                                decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.black,   ),  
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children:  [
                                          Padding(
                                         padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          height: 50,
                                          width: 35,
                                          child: IconButton(
                                            icon : Icon(Icons.remove,color:Colors.white),
                                             onPressed: ()  {
                                              Get.to(() => SearchPage());
                                             },
                                            ),
                                        ),
                                        ),
                                      //  Obx(()=>Text("${myProductController.},
                                        Text("1",style: TextStyle(color: Colors.white),),
                                        Padding(
                                        padding: EdgeInsets.zero,
                                         child: SizedBox(
                                          height: 50,
                                          width: 30,
                                           child: IconButton(
                                            icon : Icon(Icons.add,color:Colors.white),
                                             onPressed: ()  {
                                              Get.to(() => SearchPage());
                                             },
                                            ),
                                         ),
                                      ),
                                    ],   ), 
                            ),
                   ],)
                  ],
                ))
              ],
          ),
        
            );
          }),
        ),
        SizedBox(height: 50,),
        Padding(padding: EdgeInsets.only(left: 30,right: 30),child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Total",style: TextStyle(
                fontSize: 22,
                color: black.withOpacity(0.5),
                fontWeight: FontWeight.w600
              ),),
             Text("\$ 508.00",style: TextStyle(
                fontSize: 22,
                
                fontWeight: FontWeight.w600
              ),),
          ],
        ),),
        SizedBox(height: 30,),
        Padding(
          
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Container(
            color: Colors.black,
            child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Get.to(RazorPayPaymentPage());
                    },
                    child: const Text('CHECKOUT'),
                  ),
          ),
          ),
        
      ],
    );
  }

