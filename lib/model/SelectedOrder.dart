class SelectedOrder {
  String? createdDate;
  String? lastModifiedDate;
  int? id;
  Product? product;
  int? quantity;
  int? price;

  SelectedOrder(
      {this.createdDate,
      this.lastModifiedDate,
      this.id,
      this.product,
      this.quantity,
      this.price});

  SelectedOrder.fromJson(dynamic json) {
    createdDate = json['createdDate'];
    lastModifiedDate = json['lastModifiedDate'];
    id = json['id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? desc;
  int? price;
  String? imageUrl;
  String? status;
  bool? ispopular;
  Inventory? inventory;

  Product(
      {this.id,
      this.name,
      this.desc,
      this.price,
      this.imageUrl,
      this.status,
      this.ispopular,
      this.inventory});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    ispopular = json['ispopular'];
    inventory = json['inventory'] != null
        ? new Inventory.fromJson(json['inventory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    data['status'] = this.status;
    data['ispopular'] = this.ispopular;
    if (this.inventory != null) {
      data['inventory'] = this.inventory!.toJson();
    }
    return data;
  }
}

class Inventory {
  Null? createdDate;
  String? lastModifiedDate;
  int? id;
  int? quantity;
  int? productId;

  Inventory(
      {this.createdDate,
      this.lastModifiedDate,
      this.id,
      this.quantity,
      this.productId});

  Inventory.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    lastModifiedDate = json['lastModifiedDate'];
    id = json['id'];
    quantity = json['quantity'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['productId'] = this.productId;
    return data;
  }
}
