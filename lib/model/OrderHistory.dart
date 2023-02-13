// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);

import 'dart:convert';

OrderHistory orderHistoryFromJson(String str) =>
    OrderHistory.fromJson(json.decode(str));

String orderHistoryToJson(OrderHistory data) => json.encode(data.toJson());

class OrderHistory {
  OrderHistory({
    required this.id,
    required this.orderItem,
    required this.addressResponse,
    this.imageUrl,
    required this.dateTime,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.totalprice,
    required this.orderStatus,
    required this.isWallet,
    required this.priceCutFromWallet,
    required this.isSubscribe,
  });

  int id;
  List<OrderItem> orderItem;
  AddressResponse addressResponse;
  dynamic imageUrl;
  String dateTime;
  DateTime createdDate;
  DateTime lastModifiedDate;
  double totalprice;
  String orderStatus;
  bool isWallet;
  double priceCutFromWallet;
  bool isSubscribe;

  factory OrderHistory.fromJson(dynamic json) => OrderHistory(
        id: json["id"],
        orderItem: List<OrderItem>.from(
            json["orderItem"].map((x) => OrderItem.fromJson(x))),
        addressResponse: AddressResponse.fromJson(json["addressResponse"]),
        imageUrl: json["imageUrl"],
        dateTime: json["dateTime"] != null ? json["dateTime"] : '',
        createdDate: DateTime.parse(json["createdDate"]),
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        totalprice: json["totalprice"],
        orderStatus: json["orderStatus"],
        isWallet: json["isWallet"],
        priceCutFromWallet: json["priceCutFromWallet"] != null
            ? json["priceCutFromWallet"]
            : 0.0,
        isSubscribe: json["isSubscribe"] != null ? json["isSubscribe"] : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderItem": List<dynamic>.from(orderItem.map((x) => x.toJson())),
        "addressResponse": addressResponse.toJson(),
        "imageUrl": imageUrl,
        "dateTime": dateTime,
        "createdDate": createdDate.toIso8601String(),
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "totalprice": totalprice,
        "orderStatus": orderStatus,
        "isWallet": isWallet,
        "priceCutFromWallet": priceCutFromWallet,
        "isSubscribe": isSubscribe,
      };
}

class AddressResponse {
  AddressResponse({
    required this.id,
    required this.addressLine1,
    required this.addressLine2,
    required this.pincode,
    required this.city,
    required this.state,
    required this.country,
    required this.cityId,
    required this.stateId,
    required this.countryId,
    required this.isSelected,
    required this.status,
  });

  int id;
  String addressLine1;
  String addressLine2;
  int pincode;
  String city;
  String state;
  String country;
  int cityId;
  int stateId;
  int countryId;
  bool isSelected;
  String status;

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        id: json["id"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        cityId: json["cityId"],
        stateId: json["stateId"],
        countryId: json["countryId"],
        isSelected: json["isSelected"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "pincode": pincode,
        "city": city,
        "state": state,
        "country": country,
        "cityId": cityId,
        "stateId": stateId,
        "countryId": countryId,
        "isSelected": isSelected,
        "status": status,
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
    this.lastModifiedDate,
    required this.id,
    required this.quantity,
    required this.productId,
  });

  dynamic createdDate;
  dynamic lastModifiedDate;
  int id;
  int quantity;
  int productId;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        createdDate: json["createdDate"],
        lastModifiedDate: json["lastModifiedDate"],
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
