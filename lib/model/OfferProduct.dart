class OfferProduct {
  int? id;
  String? name;
  String? desc;
  int? price;
  bool? ispopular;
  String? imageUrl;
  String? status;
  Category? category;
  Discount? discount;
  Inventory? inventory;
  Offer? offer;
  int? cartQauntity;
  bool? added;

  OfferProduct(
      {this.id,
      this.name,
      this.desc,
      this.price,
      this.ispopular,
      this.imageUrl,
      this.status,
      this.category,
      this.discount,
      this.inventory,
      this.offer,
      this.cartQauntity,
      this.added});

  OfferProduct.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    price = json['price'];
    ispopular = json['ispopular'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    discount = json['discount'] != null
        ? new Discount.fromJson(json['discount'])
        : null;
    inventory = json['inventory'] != null
        ? new Inventory.fromJson(json['inventory'])
        : null;
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
    cartQauntity = json['cartQauntity'];
    added = json['added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['price'] = this.price;
    data['ispopular'] = this.ispopular;
    data['imageUrl'] = this.imageUrl;
    data['status'] = this.status;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.discount != null) {
      data['discount'] = this.discount!.toJson();
    }
    if (this.inventory != null) {
      data['inventory'] = this.inventory!.toJson();
    }
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    data['cartQauntity'] = this.cartQauntity;
    data['added'] = this.added;
    return data;
  }
}

class Category {
  String? createdDate;
  String? lastModifiedDate;
  int? id;
  String? title;
  String? metatitle;
  String? content;

  Category(
      {this.createdDate,
      this.lastModifiedDate,
      this.id,
      this.title,
      this.metatitle,
      this.content});

  Category.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    lastModifiedDate = json['lastModifiedDate'];
    id = json['id'];
    title = json['title'];
    metatitle = json['metatitle'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['id'] = this.id;
    data['title'] = this.title;
    data['metatitle'] = this.metatitle;
    data['content'] = this.content;
    return data;
  }
}

class Discount {
  Null? createdDate;
  Null? lastModifiedDate;
  int? id;
  String? name;
  String? descrption;
  String? discountPercent;
  String? status;

  Discount(
      {this.createdDate,
      this.lastModifiedDate,
      this.id,
      this.name,
      this.descrption,
      this.discountPercent,
      this.status});

  Discount.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    lastModifiedDate = json['lastModifiedDate'];
    id = json['id'];
    name = json['name'];
    descrption = json['descrption'];
    discountPercent = json['discount_percent'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['lastModifiedDate'] = this.lastModifiedDate;
    data['id'] = this.id;
    data['name'] = this.name;
    data['descrption'] = this.descrption;
    data['discount_percent'] = this.discountPercent;
    data['status'] = this.status;
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

class Offer {
  int? id;
  String? offercode;
  String? imageUrl;
  String? status;
  bool? flag;

  Offer({this.id, this.offercode, this.imageUrl, this.status, this.flag});

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offercode = json['offercode'];
    imageUrl = json['imageUrl'];
    status = json['status'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['offercode'] = this.offercode;
    data['imageUrl'] = this.imageUrl;
    data['status'] = this.status;
    data['flag'] = this.flag;
    return data;
  }
}
