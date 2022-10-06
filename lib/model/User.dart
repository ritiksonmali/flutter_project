import 'dart:convert';

Users usersFromJson(dynamic str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  int? id;
  String? email;
  String? firstName;
  String? lastName;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
      };

  void getUsers(int id, String email, String firstname, String lastname) {
    this.id = id;
    this.email = email;
    this.firstName = firstname;
    this.lastName = lastname;
  }
}
