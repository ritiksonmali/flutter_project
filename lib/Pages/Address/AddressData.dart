// To parse this JSON data, do
//
//     final addressData = addressDataFromJson(jsonString);

import 'dart:convert';

AddressData addressDataFromJson(String str) =>
    AddressData.fromJson(json.decode(str));

String addressDataToJson(AddressData data) => json.encode(data.toJson());

class AddressData {
  AddressData({
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
    required this.mobileNo,
  });

  DateTime createdDate;
  DateTime lastModifiedDate;
  int id;
  String addressLine1;
  String addressLine2;
  String pincode;
  String city;
  String state;
  String country;
  String telephoneNo;
  String mobileNo;

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
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
        mobileNo: json["mobile_no"],
      );

  Map<String, dynamic> toJson() => {
        "createdDate":
            "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "lastModifiedDate":
            "${lastModifiedDate.year.toString().padLeft(4, '0')}-${lastModifiedDate.month.toString().padLeft(2, '0')}-${lastModifiedDate.day.toString().padLeft(2, '0')}",
        "id": id,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "pincode": pincode,
        "city": city,
        "state": state,
        "country": country,
        "telephone_no": telephoneNo,
        "mobile_no": mobileNo,
      };
}
