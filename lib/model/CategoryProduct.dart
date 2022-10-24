import 'dart:convert';

List<ProductByCategory> productByCategoryFromJson(String str) =>
    List<ProductByCategory>.from(
        json.decode(str).map((x) => ProductByCategory.fromJson(x)));

String productByCategoryToJson(List<ProductByCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductByCategory {
  ProductByCategory({
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

  factory ProductByCategory.fromJson(dynamic json) => ProductByCategory(
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
    this.lastModifiedDate,
    required this.id,
    required this.quantity,
  });

  dynamic createdDate;
  dynamic lastModifiedDate;
  int id;
  String quantity;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        createdDate: json["createdDate"],
        lastModifiedDate: json["lastModifiedDate"],
        id: json["id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate,
        "lastModifiedDate": lastModifiedDate,
        "id": id,
        "quantity": quantity,
      };
}
