import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/Controller/AdminController.dart';
import 'package:flutter_login_app/Pages/Admin/RevenueAdrOrdersTableScreen.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminController adminController = Get.put(AdminController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminController.getRevenueAdrOrders();
  }

  List<Map<String, String>> tableData = [
    {'name': 'John', 'age': '25', 'location': 'New York'},
    {'name': 'Mary', 'age': '30', 'location': 'Los Angeles'},
    {'name': 'Tom', 'age': '40', 'location': 'Chicago'},
  ];

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: Theme.of(context).textTheme.headline5!.apply(color: white),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryGreen,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            icon: const Icon(Icons.menu, color: white),
            onPressed: () {
              Get.to(() => const Navbar());
            }, //=> _key.currentState!.openDrawer(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: GetBuilder<AdminController>(builder: (controller) {
                return controller.isLoading.value
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Card(
                                color: white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 20, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 120,
                                                height: 20,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => RevenueAdrOrdersTableScreen(
                                  performanceData:
                                      adminController.perfomanceData));
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Revenue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          size: 48,
                                          color: Colors.blueAccent,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Today\'s Revenue',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              adminController
                                                      .perfomanceData.isNotEmpty
                                                  ? adminController
                                                      .perfomanceData[
                                                          'todaysPerformance']
                                                          ['revenue']
                                                      .toStringAsFixed(2)
                                                  : "0",
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => RevenueAdrOrdersTableScreen(
                                  performanceData:
                                      adminController.perfomanceData));
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'ADR',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.show_chart,
                                          size: 48,
                                          color: Colors.greenAccent,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Today\'s ADR',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              adminController
                                                      .perfomanceData.isNotEmpty
                                                  ? adminController
                                                      .perfomanceData[
                                                          'todaysPerformance']
                                                          ['adr']
                                                      .toStringAsFixed(2)
                                                  : "0",
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => RevenueAdrOrdersTableScreen(
                                  performanceData:
                                      adminController.perfomanceData));
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Orders',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.shopping_cart,
                                          size: 48,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Today\'s Orders',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              adminController
                                                      .perfomanceData.isNotEmpty
                                                  ? adminController
                                                      .perfomanceData[
                                                          'todaysPerformance']
                                                          ['orders']
                                                      .toString()
                                                  : "0",
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              }),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Table(
            //     border: TableBorder.all(color: Colors.grey),
            //     columnWidths: {
            //       0: FlexColumnWidth(2),
            //       1: FlexColumnWidth(2),
            //       2: FlexColumnWidth(2),
            //       3: FlexColumnWidth(2),
            //     },
            //     children: [
            //       TableRow(
            //         decoration: BoxDecoration(color: Colors.grey[200]),
            //         children: [
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text(
            //                 'Time',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text(
            //                 'Revenue',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text(
            //                 'ADR',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text(
            //                 'Orders',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //       TableRow(
            //         children: [
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('12:00 PM'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('\$300.00'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('\$100.00'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('10'),
            //             ),
            //           ),
            //         ],
            //       ),
            //       TableRow(
            //         decoration: BoxDecoration(color: Colors.grey[200]),
            //         children: [
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('1:00 PM'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('\$500.00'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('\$125.00'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('15'),
            //             ),
            //           ),
            //         ],
            //       ),
            //       TableRow(
            //         children: [
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('2:00 PM'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('\$700.00'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('\$175.00'),
            //             ),
            //           ),
            //           TableCell(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('20'),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
