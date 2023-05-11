// import 'package:animate_do/animate_do.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login_app/Controller/OrderController.dart';
// import 'package:flutter_login_app/Pages/Order/OrderDetails.dart';
// import 'package:flutter_login_app/screens/navbar.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../ConstantUtil/colors.dart';

// class UpcomingOrders extends StatefulWidget {
//   const UpcomingOrders({Key? key}) : super(key: key);

//   @override
//   State<UpcomingOrders> createState() => _UpcomingOrdersState();
// }

// class _UpcomingOrdersState extends State<UpcomingOrders> {
//   OrderController orderController = Get.put(OrderController());

//   @override
//   void initState() {
//     super.initState();
//     orderController.getUpcomingOrders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: grey,
//       appBar: AppBar(
//         title: Text(
//           "Upcoming Orders",
//           style: Theme.of(context).textTheme.headline5!.apply(color: white),
//         ),
//         centerTitle: true,
//         backgroundColor: kPrimaryGreen,
//         elevation: 1,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: white,
//           ),
//         ),
//         actions: [
//           IconButton(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//             icon: const Icon(Icons.menu, color: white),
//             onPressed: () {
//               Get.to(() => const Navbar());
//             }, //=> _key.currentState!.openDrawer(),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           color: grey,
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               GetX<OrderController>(
//                   init: OrderController(),
//                   builder: (controller) {
//                     return controller.isLoading.value
//                         ? ListView.builder(
//                             itemCount: 5,
//                             physics: const ClampingScrollPhysics(),
//                             shrinkWrap: true,
//                             itemBuilder: (BuildContext context, int index) {
//                               return Shimmer.fromColors(
//                                 baseColor: Colors.grey[300]!,
//                                 highlightColor: Colors.grey[100]!,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 20),
//                                   child: Container(
//                                     width: size.width,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       color: Colors.white,
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             width: size.width * 0.7,
//                                             height: 20,
//                                             color: Colors.grey[300],
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Container(
//                                             width: size.width,
//                                             height: 100,
//                                             color: Colors.grey[300],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Container(
//                                             width: size.width,
//                                             height: 20,
//                                             color: Colors.grey[300],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             })
//                         : ListView.builder(
//                             itemCount: controller.orders.length,
//                             physics: const ClampingScrollPhysics(),
//                             shrinkWrap: true,
//                             itemBuilder: (BuildContext context, int index) {
//                               var order = controller.orders[index];
//                               return FadeIn(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 20),
//                                   child: Container(
//                                     width: size.width,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(30),
//                                         color: AppColor.secondary
//                                             .withOpacity(0.05)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "#Order Id: ${order.id}",
//                                                 style: const TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 order.orderStatus.toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: order.orderStatus !=
//                                                             "DELIVERED"
//                                                         ? Colors.red
//                                                         : Colors.green),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           ListView.builder(
//                                               itemCount: controller
//                                                   .orders[index]
//                                                   .orderItem
//                                                   .length,
//                                               physics:
//                                                   const ClampingScrollPhysics(),
//                                               shrinkWrap: true,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int position) {
//                                                 var orderItems = controller
//                                                     .orders[index]
//                                                     .orderItem[position];
//                                                 return Row(
//                                                   children: [
//                                                     Container(
//                                                       width: size.width * 0.6,
//                                                       child: Row(
//                                                         children: [
//                                                           const SizedBox(
//                                                             width: 5,
//                                                           ),
//                                                           Flexible(
//                                                             child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   "${orderItems.product.name} × ${orderItems.quantity}",
//                                                                   // currentOrderList[index]['name'],
//                                                                   style: Theme.of(
//                                                                           context)
//                                                                       .textTheme
//                                                                       .bodyMedium,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               }),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Flexible(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     Text(
//                                                       "Total : \₹${order.totalprice}",
//                                                       style: const TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     order.priceCutFromWallet !=
//                                                             0.0
//                                                         ? Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     bottom: 10),
//                                                             child: Text(
//                                                               "Wallet : \₹${order.priceCutFromWallet}",
//                                                               style:
//                                                                   const TextStyle(
//                                                                 fontSize: 20,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                               ),
//                                                             ),
//                                                           )
//                                                         : const SizedBox(),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       print(controller
//                                                           .orders[index]
//                                                           .priceCutFromWallet
//                                                           .toString());
//                                                       controller.update();
//                                                       Get.to(
//                                                           () =>
//                                                               const OrderDetailsScreen(),
//                                                           popGesture: true,
//                                                           arguments: {
//                                                             'orderItem':
//                                                                 controller
//                                                                     .orders[
//                                                                         index]
//                                                                     .orderItem,
//                                                             'priceCutFromWallet':
//                                                                 controller
//                                                                     .orders[
//                                                                         index]
//                                                                     .priceCutFromWallet,
//                                                             'orderId':
//                                                                 controller
//                                                                     .orders[
//                                                                         index]
//                                                                     .id,
//                                                             'address':
//                                                                 "${order.addressResponse.addressLine1}\n${order.addressResponse.addressLine2}-${order.addressResponse.pincode}\n${order.addressResponse.city}\n${order.addressResponse.state} ${order.addressResponse.country}",
//                                                             'totalPrice': order
//                                                                 .totalprice
//                                                                 .toString()
//                                                           });
//                                                     },
//                                                     style: TextButton.styleFrom(
//                                                       backgroundColor:
//                                                           buttonColour,
//                                                     ),
//                                                     child:
//                                                         const Text("Details"),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 order.createdDate != null
//                                                     ? DateFormat(
//                                                             'dd-MM-yyyy hh:mm a')
//                                                         .format(order
//                                                             .createdDate
//                                                             .toUtc()
//                                                             .toLocal())
//                                                     : "",
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyMedium,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             });
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
