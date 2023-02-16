import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/globals.dart';
import 'package:flutter_login_app/Controller/AllOrdersForDeliveryManager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_login_app/Pages/Order/OrderScreenDeliveryManager.dart';
import 'package:image_picker/image_picker.dart';
import '../../ConstantUtil/colors.dart';
import 'package:http/http.dart' as http;

class OrderDetailsDeliveryManager extends StatefulWidget {
  const OrderDetailsDeliveryManager({Key? key}) : super(key: key);
  // static const routeName = '/checkout';

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsDeliveryManagerState createState() =>
      _OrderDetailsDeliveryManagerState();
}

class _OrderDetailsDeliveryManagerState
    extends State<OrderDetailsDeliveryManager> {
    TextEditingController reasonController = TextEditingController();
    final _formKey5 = GlobalKey<FormState>();
  AllOrdersForDeliveryManager allOrdersForDeliveryManager = Get.find();
  // ignore: prefer_typing_uninitialized_variables
  var total;
  double gst = 0;
  double finalPrice = 0;
  // ignore: non_constant_identifier_names
  File? PickedImage;
  var orderId = Get.arguments;

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        allOrdersForDeliveryManager.allOrders.clear();
        await Future.delayed(Duration(seconds: 1));
        allOrdersForDeliveryManager.getAllOrders();
        await Future.delayed(Duration(seconds: 2));
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          automaticallyImplyLeading: true,
          backgroundColor: kPrimaryGreen,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              allOrdersForDeliveryManager.allOrders.clear();
              await Future.delayed(const Duration(seconds: 1));
              allOrdersForDeliveryManager.getAllOrders();
              await Future.delayed(const Duration(seconds: 2));
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
          title: Text("Delivery Details",
              style:
                  Theme.of(context).textTheme.headline5!.apply(color: white)),
        ),
        bottomNavigationBar: orderId['orderStatus'] == "DELIVERED" ||
                orderId['orderStatus'] == "CANCELLED"
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            backgroundColor: buttonCancelColour),
                        onPressed: () {
                          cancelOrderOption();
                        },
                        icon: const Icon(
                          Icons.cancel,
                          size: 24.0,
                        ),
                        label: const Text('Cancel Order'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            backgroundColor: buttonColour),
                        onPressed: () async {
                          if (allOrdersForDeliveryManager.uploaded == true) {
                            allOrdersForDeliveryManager
                                .setOrderDelivered(orderId['orderId']);
                            await Future.delayed(const Duration(seconds: 2));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Order Delivered Successfully'),
                              backgroundColor: Colors.green,
                            ));

                            allOrdersForDeliveryManager.uploaded = false;
                          } else {
                            // ignore: prefer_const_constructors
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Please Upload Image !'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        icon: const Icon(
                          Icons.local_shipping,
                          size: 24.0,
                        ),
                        label: Text('Delivered'),
                      ),
                    ),
                  ),
                ],
              ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Address",
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 00),
                          child: SizedBox(
                            width: 230,
                            child: Text(orderId['address'],
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 15,
                    width: double.infinity,
                    color: grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order Summary",
                            style: Theme.of(context).textTheme.titleLarge),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextButton(
                              onPressed: () {
                                // Get.to(() => OrderPage());
                              },
                              child: Row(
                                children: [],
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text(
                              "Product Name",
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              "Quantity",
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              "Price",
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                      children: List.generate(selectedOrder.length, (index) {
                    var productdata = selectedOrder[index];
                    total = selectedOrder.length > 0
                        ? selectedOrder
                            .map<int>(
                                (m) => m['product']['price'] * m['quantity'])
                            .reduce((value, element) => value + element)
                        : 0;
                    int? totalPrice = int.tryParse(total.toString());
                    gst = ((totalPrice! * 0.18));
                    finalPrice = gst + totalPrice + 10;
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
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 10,
                                            child: Text(
                                              productdata['product']['name']
                                                  .toString(),
                                              // "\$ " + products[index]['price'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Text(
                                              productdata['quantity']
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Text(
                                              productdata['product']['price']
                                                  .toString()
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    );
                  })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 15,
                    width: double.infinity,
                    color: grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total",
                              style: Theme.of(context).textTheme.titleMedium),
                          Text("\₹${total}",
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery Cost",
                              style: Theme.of(context).textTheme.titleMedium),
                          Text("\₹10",
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gst(18%)",
                              style: Theme.of(context).textTheme.titleMedium),
                          Text("\₹${gst.toStringAsFixed(2)}",
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 10,
                        color: Color.fromARGB(255, 137, 136, 136),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("\₹${finalPrice}",
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                  ),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: grey,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  apiCall() async {
    var SelectedOrderFromAPi = await getOrderDetails(orderId['orderId']);
    setState(() {
      selectedOrder = SelectedOrderFromAPi;
    });
  }

  List selectedOrder = [];

  Future getOrderDetails(orderId) async {
    String url = serverUrl + 'getOrderDetailsbyid/${orderId}';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    var body = jsonDecode(response.body);
    return body['orderItem'];
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        PickedImage = tempImage;
        allOrdersForDeliveryManager.uploadImage(
            orderId['orderId'], PickedImage!);
        Future.delayed(Duration(seconds: 2));
        if (allOrdersForDeliveryManager.uploaded == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Image Uploaded !'),
            backgroundColor: Colors.green,
          ));
        }
      });
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // void imagePickerOption() {
  //   Get.bottomSheet(
  //     SingleChildScrollView(
  //       child: ClipRRect(
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(10.0),
  //           topRight: Radius.circular(10.0),
  //         ),
  //         child: Container(
  //           color: Colors.white,
  //           height: 250,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 const Text(
  //                   "Pick Image From",
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 ElevatedButton.icon(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: Colors.black,
  //                   ),
  //                   onPressed: () {
  //                     pickImage(ImageSource.camera);
  //                   },
  //                   icon: const Icon(Icons.camera),
  //                   label: const Text("CAMERA"),
  //                 ),
  //                 ElevatedButton.icon(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: Colors.black,
  //                   ),
  //                   onPressed: () {
  //                     pickImage(ImageSource.gallery);
  //                   },
  //                   icon: const Icon(Icons.image),
  //                   label: const Text("GALLERY"),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 ElevatedButton.icon(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: Colors.black,
  //                   ),
  //                   onPressed: () {
  //                     Get.back();
  //                   },
  //                   icon: const Icon(Icons.close),
  //                   label: const Text("CANCEL"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }


  

  void cancelOrderOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Cancel Order",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                   const SizedBox(
                    height: 20,
                  ),
                   Form(
                    key: _formKey5,
                     child: Padding(
                                   padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                   child: TextFormField(
                                     controller: reasonController,
                                     autovalidateMode: AutovalidateMode.onUserInteraction,
                                     cursorColor: Colors.black87,
                                     style: const TextStyle(),
                                     decoration: InputDecoration(
                      filled: true,
                      // hintText: 'Enter message title',
                      label: Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                                text: 'Enter Cancellation Reason',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                children: [
                                  TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ],
                      ),
                      // labelStyle: TextStyle(color: Colors.black54),
                      border: const OutlineInputBorder(),
                                     ),
                                     textInputAction: TextInputAction.done,
                                     keyboardType: TextInputType.emailAddress,
                                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Cancellation Reason';
                      }
                      return null;
                                     },
                                   ),
                                 ),
                   ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                        ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: buttonColour,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                                child: const Text(
                                  "Cancel Order",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                 checkValidations();
                                },
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              // ElevatedButton(
                              //   style: TextButton.styleFrom(
                              //     backgroundColor: buttonCancelColour,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius:
                              //             BorderRadius.circular(30.0)),
                              //   ),
                              //   child: const Text(
                              //     "Close",
                              //     style: TextStyle(
                              //         fontSize: 14,
                              //         letterSpacing: 2.2,
                              //         color: Colors.white),
                              //   ),
                              //   onPressed: () {
                              //     Navigator.of(context).pop();
                              //   },
                              // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


   checkValidations() {
    if (_formKey5.currentState!.validate()) {
      print("Form is valid ");
      _formKey5.currentState!.save();
      sendYourFeedbackApi(reasonController.text.toString(),
           orderId['orderId'] );
    } else {
       Fluttertoast.showToast(
            msg: 'please Enter Reason',
            gravity: ToastGravity.BOTTOM_RIGHT,
            fontSize: 18,
            backgroundColor: Colors.red,
            textColor: white);
    }
  }

  Future sendYourFeedbackApi(
      // ignore: non_constant_identifier_names
      String CancelReason,int orderId) async {
    String url = serverUrl + 'setCancellationReason';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "orderId": orderId,
          "cancelReasons": CancelReason
        }));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        reasonController.clear();
        Get.to(() => const OrderScreenDeliveryManager());
      });
      Fluttertoast.showToast(
          msg: 'Your Feedback Sent Successfully !',
          gravity: ToastGravity.BOTTOM_RIGHT,
          fontSize: 18,
          backgroundColor: Colors.green,
          textColor: white);
    }
  }


}
