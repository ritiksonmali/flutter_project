// To parse this JSON data, do
//
//     final OrderWalletModel = OrderWalletModelFromJson(jsonString);

import 'dart:convert';

OrderWalletModel OrderWalletModelFromJson(String str) =>
    OrderWalletModel.fromJson(json.decode(str));

String OrderWalletModelToJson(OrderWalletModel data) =>
    json.encode(data.toJson());

class OrderWalletModel {
  OrderWalletModel({
    required this.createdDate,
    required this.lastModifiedDate,
    required this.id,
    required this.orderItem,
    required this.address,
    required this.imageUrl,
    required this.dateTime,
    required this.totalprice,
    required this.orderStatus,
    required this.isWallet,
    required this.priceCutFromWallet,
  });

  DateTime createdDate;
  DateTime lastModifiedDate;
  int id;
  List<dynamic> orderItem;
  dynamic address;
  dynamic imageUrl;
  dynamic dateTime;
  double totalprice;
  String orderStatus;
  bool isWallet;
  dynamic priceCutFromWallet;

  factory OrderWalletModel.fromJson(dynamic json) => OrderWalletModel(
        createdDate: DateTime.parse(json["createdDate"]),
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        id: json["id"],
        orderItem: List<dynamic>.from(json["orderItem"].map((x) => x)),
        address: json["address"],
        imageUrl: json["imageUrl"],
        dateTime: json["dateTime"],
        totalprice: json["totalprice"],
        orderStatus: json["orderStatus"],
        isWallet: json["isWallet"],
        priceCutFromWallet: json["priceCutFromWallet"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate.toIso8601String(),
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "id": id,
        "orderItem": List<dynamic>.from(orderItem.map((x) => x)),
        "address": address,
        "imageUrl": imageUrl,
        "dateTime": dateTime,
        "totalprice": totalprice,
        "orderStatus": orderStatus,
        "isWallet": isWallet,
        "priceCutFromWallet": priceCutFromWallet,
      };
}
