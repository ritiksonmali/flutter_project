import 'dart:convert';

List<Offer> offerFromJson(String str) =>
    List<Offer>.from(json.decode(str).map((x) => Offer.fromJson(x)));

String offerToJson(List<Offer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  factory Offer.fromJson(dynamic json) => Offer(
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
