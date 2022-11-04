// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);

import 'dart:convert';

List<OrderHistory> orderHistoryFromJson(String str) => List<OrderHistory>.from(
    json.decode(str).map((x) => OrderHistory.fromJson(x)));

String orderHistoryToJson(List<OrderHistory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderHistory {
  OrderHistory({
    required this.id,
    required this.orderItem,
    required this.orderStatus,
    required this.totalprice,
  });

  int id;
  List<OrderItem> orderItem;
  String orderStatus;
  String totalprice;

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        id: json["id"],
        orderItem: List<OrderItem>.from(
            json["orderItem"].map((x) => OrderItem.fromJson(x))),
        orderStatus: json["orderStatus"],
        totalprice: json["totalprice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderItem": List<dynamic>.from(orderItem.map((x) => x.toJson())),
        "orderStatus": orderStatus,
        "totalprice": totalprice,
      };
}

class OrderItem {
  OrderItem({
    required this.createdDate,
    required this.id,
    required this.lastModifiedDate,
    required this.price,
    required this.product,
    required this.quantity,
  });

  DateTime createdDate;
  int id;
  DateTime lastModifiedDate;
  String price;
  Product product;
  String quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        createdDate: DateTime.parse(json["createdDate"]),
        id: json["id"],
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        price: json["price"],
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate.toIso8601String(),
        "id": id,
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "price": price,
        "product": product.toJson(),
        "quantity": quantity,
      };
}

class Product {
  Product({
    required this.desc,
    required this.id,
    required this.imageUrl,
    required this.inventory,
    required this.ispopular,
    required this.name,
    required this.price,
    required this.status,
  });

  String desc;
  int id;
  String imageUrl;
  Inventory inventory;
  bool ispopular;
  String name;
  int price;
  String status;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        desc: json["desc"],
        id: json["id"],
        imageUrl: json["imageUrl"],
        inventory: Inventory.fromJson(json["inventory"]),
        ispopular: json["ispopular"],
        name: json["name"],
        price: json["price"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "id": id,
        "imageUrl": imageUrl,
        "inventory": inventory.toJson(),
        "ispopular": ispopular,
        "name": name,
        "price": price,
        "status": status,
      };
}

class Inventory {
  Inventory({
    required this.createdDate,
    required this.id,
    required this.lastModifiedDate,
    required this.quantity,
  });

  DateTime createdDate;
  int id;
  DateTime lastModifiedDate;
  int quantity;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        createdDate: DateTime.parse(json["createdDate"]),
        id: json["id"],
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate.toIso8601String(),
        "id": id,
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "quantity": quantity,
      };
}
