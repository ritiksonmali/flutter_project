// To parse this JSON data, do
//
//     final categoryData = categoryDataFromJson(jsonString);

import 'dart:convert';

List<CategoryData> categoryDataFromJson(String str) => List<CategoryData>.from(
    json.decode(str).map((x) => CategoryData.fromJson(x)));

String categoryDataToJson(List<CategoryData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryData {
  CategoryData({
    required this.content,
    required this.createdDate,
    required this.id,
    required this.lastModifiedDate,
    required this.metatitle,
    required this.title,
  });

  String content;
  DateTime createdDate;
  int id;
  DateTime lastModifiedDate;
  String metatitle;
  String title;

  factory CategoryData.fromJson(dynamic json) => CategoryData(
        content: json["content"],
        createdDate: DateTime.parse(json["createdDate"]),
        id: json["id"],
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        metatitle: json["metatitle"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "createdDate": createdDate.toIso8601String(),
        "id": id,
        "lastModifiedDate": lastModifiedDate.toIso8601String(),
        "metatitle": metatitle,
        "title": title,
      };
}
