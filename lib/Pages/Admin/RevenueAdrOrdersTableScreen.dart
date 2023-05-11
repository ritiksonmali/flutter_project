// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_login_app/ConstantUtil/colors.dart';
import 'package:flutter_login_app/screens/navbar.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RevenueAdrOrdersTableScreen extends StatefulWidget {
  Map<dynamic, dynamic> performanceData;

  RevenueAdrOrdersTableScreen({required this.performanceData});

  @override
  _RevenueAdrOrdersTableScreenState createState() =>
      _RevenueAdrOrdersTableScreenState();
}

class _RevenueAdrOrdersTableScreenState
    extends State<RevenueAdrOrdersTableScreen> {
  List<Map<dynamic, dynamic>> dynamicRows = [];
  @override
  void initState() {
    super.initState();
    widget.performanceData.isNotEmpty
        ? dynamicRows = [
            widget.performanceData['todaysPerformance'],
            widget.performanceData['currentMonthPerformance'],
            widget.performanceData['lastMonthPerformance']
          ]
        : [];
  }

  List<String> timeSlots = [
    "Today",
    "This Month",
    "Last Month",
  ];

  int _sortColumnIndex = 0;
  bool _isAscending = true;

  // void _sortTable(int columnIndex, bool isAscending) {
  //   setState(() {
  //     _sortColumnIndex = columnIndex;
  //     _isAscending = isAscending;
  //     dynamicRows.sort((row1, row2) {
  //       String key = dynamicRows.first.keys.toList()[columnIndex];
  //       dynamic value1 = row1[key];
  //       dynamic value2 = row2[key];
  //       if (isAscending) {
  //         return Comparable.compare(value1, value2);
  //       } else {
  //         return Comparable.compare(value2, value1);
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      appBar: AppBar(
        title: Text(
          "Analysis Table",
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
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(
                borderRadius: const BorderRadius.all(Radius.zero)),
            // columnSpacing: 30,
            dividerThickness: 0.0,
            headingRowColor:
                MaterialStateColor.resolveWith((states) => kLightGreen),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _isAscending,
            columns: const [
              DataColumn(
                label: Text(
                  "Time",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    "Revenue",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                // onSort: (columnIndex, _) {
                //   _sortTable(columnIndex, _isAscending);
                // },
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    "ADR",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                // onSort: (columnIndex, _) {
                //   _sortTable(columnIndex, _isAscending);
                // },
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    "Orders",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                // onSort: (columnIndex, _) {
                //   _sortTable(columnIndex, _isAscending);
                // },
              ),
            ],
            rows: widget.performanceData.isEmpty
                ? [
                    const DataRow(cells: [
                      DataCell(Text("Data is not available",
                          style: TextStyle(fontSize: 14.0))),
                      DataCell(Text("")),
                      DataCell(Text("")),
                      DataCell(Text("")),
                    ])
                  ]
                : List<DataRow>.generate(
                    timeSlots.length,
                    (int index) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            timeSlots[index],
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dynamicRows[index]["revenue"].toStringAsFixed(2),
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dynamicRows[index]["adr"].toStringAsFixed(2),
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dynamicRows[index]["orders"].toString(),
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
