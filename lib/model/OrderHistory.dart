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
    required this.createdDate,
    required this.lastModifiedDate,
    required this.id,
    required this.orderItem,
    required this.address,
    required this.totalprice,
    required this.orderStatus,
  });

  DateTime createdDate;
  DateTime lastModifiedDate;
  int id;
  List<OrderItem> orderItem;
  Address address;
  double totalprice;
  String orderStatus;

  factory OrderHistory.fromJson(dynamic json) => OrderHistory(
        createdDate: DateTime.parse(json["createdDate"]),
        lastModifiedDate: DateTime.parse(json["createdDate"]),
        id: json["id"],
        orderItem: List<OrderItem>.from(
            json["orderItem"].map((x) => OrderItem.fromJson(x))),
        address: Address.fromJson(json["address"]),
        totalprice: json["totalprice"],
        orderStatus: json["orderStatus"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate,
        "lastModifiedDate": lastModifiedDate,
        "id": id,
        "orderItem": List<dynamic>.from(orderItem.map((x) => x.toJson())),
        "address": address.toJson(),
        "totalprice": totalprice,
        "orderStatus": orderStatus,
      };
}

class Address {
  Address({
    required this.createdDate,
    required this.lastModifiedDate,
    required this.id,
    required this.addressLine1,
    required this.addressLine2,
    required this.pincode,
    required this.city,
    required this.state,
    required this.country,
    required this.telephoneNo,
    required this.isSelected,
    required this.mobileNo,
  });

  DateTime createdDate;
  DateTime lastModifiedDate;
  int id;
  String addressLine1;
  String addressLine2;
  int pincode;
  String city;
  String state;
  String country;
  String telephoneNo;
  bool isSelected;
  String mobileNo;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        createdDate: DateTime.parse(json["createdDate"]),
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        id: json["id"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        telephoneNo: json["telephone_no"],
        isSelected: json["isSelected"],
        mobileNo: json["mobile_no"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate.toIso8601String(),
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "id": id,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "pincode": pincode,
        "city": city,
        "state": state,
        "country": country,
        "telephone_no": telephoneNo,
        "isSelected": isSelected,
        "mobile_no": mobileNo,
      };
}

class OrderItem {
  OrderItem({
    required this.createdDate,
    required this.lastModifiedDate,
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });

  DateTime createdDate;
  DateTime lastModifiedDate;
  int id;
  Product product;
  int quantity;
  int price;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        createdDate: DateTime.parse(json["createdDate"]),
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        id: json["id"],
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate.toIso8601String(),
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "id": id,
        "product": product.toJson(),
        "quantity": quantity,
        "price": price,
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.imageUrl,
    required this.status,
    required this.ispopular,
    required this.inventory,
  });

  int id;
  String name;
  String desc;
  int price;
  String imageUrl;
  String status;
  bool ispopular;
  Inventory inventory;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"],
        imageUrl: json["imageUrl"],
        status: json["status"],
        ispopular: json["ispopular"],
        inventory: Inventory.fromJson(json["inventory"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "imageUrl": imageUrl,
        "status": status,
        "ispopular": ispopular,
        "inventory": inventory.toJson(),
      };
}

class Inventory {
  Inventory({
    this.createdDate,
    required this.lastModifiedDate,
    required this.id,
    required this.quantity,
    required this.productId,
  });

  dynamic createdDate;
  DateTime lastModifiedDate;
  int id;
  int quantity;
  int productId;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        createdDate: json["createdDate"],
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        id: json["id"],
        quantity: json["quantity"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate,
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "id": id,
        "quantity": quantity,
        "productId": productId,
      };
}
