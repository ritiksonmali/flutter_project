// To parse this JSON data, do
//
//     final subscriptionOrderModel = subscriptionOrderModelFromJson(jsonString);

import 'dart:convert';

List<SubscriptionOrderModel> subscriptionOrderModelFromJson(String str) =>
    List<SubscriptionOrderModel>.from(
        json.decode(str).map((x) => SubscriptionOrderModel.fromJson(x)));

String subscriptionOrderModelToJson(List<SubscriptionOrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionOrderModel {
  SubscriptionOrderModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.frequency,
    required this.quantity,
    required this.status,
    required this.product,
  });

  int id;
  DateTime startDate;
  DateTime? endDate;
  String time;
  int frequency;
  int quantity;
  String status;
  Product product;

  factory SubscriptionOrderModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionOrderModel(
        id: json["id"],
        startDate: DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        time: json["time"],
        frequency: json["frequency"],
        quantity: json["quantity"],
        status: json["status"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate!.toIso8601String(),
        "time": time,
        "frequency": frequency,
        "quantity": quantity,
        "status": status,
        "product": product.toJson(),
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
    required this.weight,
    required this.isVegan,
    required this.isSubscribe,
  });

  int id;
  String name;
  String desc;
  int price;
  String imageUrl;
  String status;
  bool ispopular;
  Inventory inventory;
  String weight;
  bool isVegan;
  bool isSubscribe;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"],
        imageUrl: json["imageUrl"],
        status: json["status"],
        ispopular: json["ispopular"],
        inventory: Inventory.fromJson(json["inventory"]),
        weight: json["weight"],
        isVegan: json["isVegan"],
        isSubscribe: json["isSubscribe"],
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
        "weight": weight,
        "isVegan": isVegan,
        "isSubscribe": isSubscribe,
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
