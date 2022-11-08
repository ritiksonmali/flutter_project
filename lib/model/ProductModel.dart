import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.ispopular,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.discount,
    required this.inventory,
    required this.offer,
    required this.cartQauntity,
  });

  int id;
  String name;
  String desc;
  int price;
  bool ispopular;
  String imageUrl;
  String status;
  Category category;
  Discount discount;
  Inventory inventory;
  Offer? offer;
  int cartQauntity;
  int counter = 1;
  bool isAdded = false;

  factory ProductModel.fromJson(dynamic json) => ProductModel(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
        price: json["price"],
        ispopular: json["ispopular"],
        imageUrl: json["imageUrl"],
        status: json["status"],
        category: Category.fromJson(json["category"]),
        discount: Discount.fromJson(json["discount"]),
        inventory: Inventory.fromJson(json["inventory"]),
        offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
        cartQauntity: json["cartQauntity" ]== null ? 0 : json["cartQauntity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "price": price,
        "ispopular": ispopular,
        "imageUrl": imageUrl,
        "status": status,
        "category": category.toJson(),
        "discount": discount.toJson(),
        "inventory": inventory.toJson(),
        "offer": offer == null ? null : offer!.toJson(),
        "cartQauntity": cartQauntity,
      };
}

class Category {
  Category({
    required this.createdDate,
    required this.lastModifiedDate,
    required this.id,
    required this.title,
    required this.metatitle,
    required this.content,
  });

  DateTime createdDate;
  DateTime lastModifiedDate;
  int id;
  String title;
  String metatitle;
  String content;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        createdDate: DateTime.parse(json["createdDate"]),
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        id: json["id"],
        title: json["title"],
        metatitle: json["metatitle"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate":
            "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "lastModifiedDate":
            "${lastModifiedDate.year.toString().padLeft(4, '0')}-${lastModifiedDate.month.toString().padLeft(2, '0')}-${lastModifiedDate.day.toString().padLeft(2, '0')}",
        "id": id,
        "title": title,
        "metatitle": metatitle,
        "content": content,
      };
}

class Discount {
  Discount({
    this.createdDate,
    this.lastModifiedDate,
    required this.id,
    required this.name,
    required this.descrption,
    required this.discountPercent,
    required this.status,
  });

  dynamic createdDate;
  dynamic lastModifiedDate;
  int id;
  String name;
  String descrption;
  String discountPercent;
  String status;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        createdDate: json["createdDate"],
        lastModifiedDate: json["lastModifiedDate"],
        id: json["id"],
        name: json["name"],
        descrption: json["descrption"],
        discountPercent: json["discount_percent"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate": createdDate,
        "lastModifiedDate": lastModifiedDate,
        "id": id,
        "name": name,
        "descrption": descrption,
        "discount_percent": discountPercent,
        "status": status,
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
  int quantity;

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

class Offer {
  Offer({
    required this.id,
    required this.offercode,
    required this.imageUrl,
    required this.status,
    required this.flag,
  });

  int id;
  String offercode;
  String imageUrl;
  String status;
  bool flag;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        offercode: json["offercode"],
        imageUrl: json["imageUrl"],
        status: json["status"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offercode": offercode,
        "imageUrl": imageUrl,
        "status": status,
        "flag": flag,
      };
}